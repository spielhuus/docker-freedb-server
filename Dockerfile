FROM debian:buster-slim

ARG CDDB_VERSION

COPY cddbd-$CDDB_VERSION /usr/local/cddbd/cddbd-$CDDB_VERSION

RUN apt-get update -q && apt-get upgrade -q -y && \
    apt-get install bzip2 curl axel uwsgi locales -q -y

RUN sed -i 's/# de_CH.UTF-8 UTF-8/de_CH.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    ln -s /etc/locale.alias /usr/share/locale/locale.alias && \
    locale-gen && update-locale LANG=en_US.UTF-8
RUN cp /usr/share/zoneinfo/Europe/Zurich /etc/localtime && \
echo "Europe/Zurich" > /etc/timezone

# install cddbd
COPY target/cddbd-$CDDB_VERSION.tar.gz /target/
RUN tar xfz /target/cddbd-$CDDB_VERSION.tar.gz -C /

COPY cddbd.ini /usr/local/cddbd
COPY start.sh /usr/local/cddbd
RUN chmod a+x /usr/local/cddbd/start.sh

ENTRYPOINT ["/usr/local/cddbd/start.sh"]

EXPOSE 8888

