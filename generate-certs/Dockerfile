FROM ubuntu:20.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl ca-certificates gnupg openssl

RUN curl --location https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs build-essential

RUN apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

COPY src /src

RUN mkdir /tls
WORKDIR /tls

# Config file for intermediate cert
RUN echo \
'[v3_ca]\n\
basicConstraints = CA:TRUE\n'\
>> intermediate.conf

# Config file for client/device cert
RUN echo \
'[v3_ca]\n\
basicConstraints = CA:FALSE\n'\
>> client.conf

# Create a self-signed cert
RUN openssl req -passout pass:"password" -subj "/C=GB/CN=www.test-rootca.co.uk"  -x509 -newkey rsa:4096 \
    -keyout rootca.key -out rootca.pem -sha256 -days 365

# Create an intermediate certificate signing request (CSR)
RUN openssl req -new -newkey rsa:4096 -passout pass:"password" -subj "/C=GB/CN=www.test-intca.co.uk" -keyout \
    intca.key -sha256 -out intca.csr

# Create new INTERMEDIATE cert using the CSR and sign with ROOT cert/key. Use -CAcreateserial to create a serial file.
# Subsequent signings by the root cert will need to point to this serial file using -CAserial instead
RUN openssl x509 -req -passin pass:"password" -CA ./rootca.pem -CAkey ./rootca.key -in ./intca.csr \
    -out ./intca.pem -extensions v3_ca -CAcreateserial -extfile ./intermediate.conf

# Create a client certificate signing request (CSR)
RUN openssl req -new -newkey rsa:4096 -passout pass:"password" -subj "/C=GB/CN=testclient" -keyout \
    client.key -sha256 -out client.csr

# Create new CLIENT cert and sign with INTERMEDIATE cert/key.
# Can't use -CAcreateserial for subsequent signings, as above
RUN openssl x509 -req -passin pass:"password" -CA ./intca.pem -CAkey ./intca.key -in ./client.csr \
    -out ./client.pem -extensions v3_ca -CAcreateserial -extfile ./client.conf


EXPOSE 8080

CMD ["/bin/bash"]
