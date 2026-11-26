FROM seffeng/alpine:3.24

LABEL author="zxf <seffeng@live.com>"

ARG BASE_DIR="/opt/websrv"

ENV VALKEY_NAME=valkey\
 VALKEY_VERSION=9.2.0\
 CONFIG_DIR="${BASE_DIR}/config/valkey"\
 INSTALL_DIR="${BASE_DIR}/program/valkey"\
 BASE_PACKAGE="make g++ jemalloc-dev"\
 EXTEND="openssl-dev"

ENV VALKEY_URL="https://github.com/valkey-io/valkey/archive/refs/tags/${VALKEY_VERSION}.tar.gz"

WORKDIR /tmp
COPY    conf ./conf

RUN apk update && apk add --no-cache ${BASE_PACKAGE} ${EXTEND} &&\
 wget ${VALKEY_URL} &&\
 tar -zxf ${VALKEY_VERSION}.tar.gz &&\
 mkdir -p ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR} ${INSTALL_DIR} ${BASE_DIR}/data/${VALKEY_NAME} &&\
 rm -rf ${INSTALL_DIR} &&\
 cd ${VALKEY_NAME}-${VALKEY_VERSION} &&\
 make BUILD_TLS=yes -j$(nproc) &&\
 make PREFIX=${INSTALL_DIR} install &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR} &&\
 ln -s ${INSTALL_DIR}/bin/valkey-benchmark /usr/local/bin/valkey-benchmark &&\
 ln -s ${INSTALL_DIR}/bin/valkey-check-aof /usr/local/bin/valkey-check-aof &&\
 ln -s ${INSTALL_DIR}/bin/valkey-check-rdb /usr/local/bin/valkey-check-rdb &&\
 ln -s ${INSTALL_DIR}/bin/valkey-cli /usr/local/bin/valkey-cli &&\
 ln -s ${INSTALL_DIR}/bin/valkey-sentinel /usr/local/bin/valkey-sentinel &&\
 ln -s ${INSTALL_DIR}/bin/valkey-server /usr/local/bin/valkey-server &&\

 ln -s /usr/local/bin/valkey-benchmark /usr/local/bin/redis-benchmark &&\
 ln -s /usr/local/bin/valkey-check-aof /usr/local/bin/redis-check-aof &&\
 ln -s /usr/local/bin/valkey-check-rdb /usr/local/bin/redis-check-rdb &&\
 ln -s /usr/local/bin/valkey-cli /usr/local/bin/redis-cli &&\
 ln -s /usr/local/bin/valkey-sentinel /usr/local/bin/redis-sentinel &&\
 ln -s /usr/local/bin/valkey-server /usr/local/bin/redis-server &&\
 echo -e "#!/bin/sh\n${INSTALL_DIR}/bin/valkey-server ${CONFIG_DIR}/valkey.conf" > ${CONFIG_DIR}/start.sh &&\
 echo -e "#!/bin/sh\nvalkey-cli shutdown > /dev/null" > ${CONFIG_DIR}/stop.sh &&\
 chmod +x ${CONFIG_DIR}/start.sh ${CONFIG_DIR}/stop.sh &&\
 apk del ${BASE_PACKAGE} &&\
 rm -rf /var/cache/apk/* &&\
 rm -rf /tmp/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR}/data/valkey"]

EXPOSE 6379

CMD ["valkey-server", "/opt/websrv/config/valkey/valkey.conf"]