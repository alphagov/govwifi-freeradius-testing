FROM freeradius-3-testing-shared

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git build-essential libssl-dev devscripts pkg-config libnl-3-dev libnl-genl-3-dev \
    freeradius-utils && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN git clone --depth 1 --single-branch --branch v3.2.x https://github.com/FreeRADIUS/freeradius-server.git && \
    /freeradius-server/scripts/ci/eapol_test-build.sh && \
    cp /freeradius-server/scripts/ci/eapol_test/eapol_test /usr/local/bin/

COPY eapol_configs /eapol_configs
RUN chown -R runuser:runuser /eapol_configs

RUN echo '\nchown -R runuser:runuser /eapol_configs' >> /usr/local/bin/start.sh && \
    echo 'exec env HOST_IP=$HOST_IP gosu runuser /bin/bash' >> /usr/local/bin/start.sh

