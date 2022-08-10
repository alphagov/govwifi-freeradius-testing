FROM ubuntu:20.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends supervisor gosu nano wget curl openssh-client rsync ca-certificates zip unzip && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wpasupplicant freeradius freeradius-rest freeradius-utils freeradius-config openssl && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential git libssl-dev autoconf automake libtool pkg-config zlib1g zlib1g-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN git -c advice.detachedHead=false clone https://github.com/facebook/watchman.git -b v2022.08.08.00 --depth 1 /watchman
WORKDIR /watchman
RUN ./autogen.sh && \
    ./configure.sh --without-python --without-pcre && \
    make && \
    make install

COPY start.sh /usr/local/bin
RUN chmod 744 /usr/local/bin/start.sh

COPY supervisord.conf /etc

RUN mkdir /home/runuser && \
    groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser && \
    chown -R runuser:runuser /home/runuser

ENV CERTDIR=/etc/freeradius/3.0/certs

RUN sed -i '1s/^/testing\tCleartext-Password := "password"\n/' /etc/freeradius/3.0/mods-config/files/authorize

RUN sed -i '1s/^/client any_client {\n\tipaddr = 0.0.0.0\/0\n\tsecret = testing123\n}\n/' /etc/freeradius/3.0/clients.conf

CMD ["/usr/local/bin/start.sh"]