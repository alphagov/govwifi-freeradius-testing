FROM ubuntu:20.04

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gosu nano curl ca-certificates freeradius openssl iproute2 && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git build-essential libssl-dev devscripts pkg-config libnl-3-dev libnl-genl-3-dev \
    freeradius-utils && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /home/runuser && \
    groupadd --gid 1000 runuser && \
    useradd --home-dir /home/runuser --shell /bin/bash --uid 1000 --gid 1000 runuser && \
    chown -R runuser:runuser /home/runuser

ENV certdir=/etc/freeradius/3.0/certs

RUN git clone --depth 1 --no-single-branch https://github.com/FreeRADIUS/freeradius-server.git
RUN /freeradius-server/scripts/ci/eapol_test-build.sh
RUN cp /freeradius-server/scripts/ci/eapol_test/eapol_test /usr/local/bin/

CMD ["/usr/local/bin/start.sh"]
