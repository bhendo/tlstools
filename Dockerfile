FROM alpine

WORKDIR /app

RUN apk --update add \
      git \
      bash \
      python \
      py-pip \
      util-linux \
      ca-certificates \
      openssl && \
    apk --update add --no-cache --virtual .build-deps \
      build-base \
      perl \
      python-dev \
      zlib-dev \
      openssl-dev \
      gmp-dev && \
    git clone https://github.com/tomato42/tlsfuzzer.git && \
    pip install --upgrade pip && \
    pip install --pre six \
      ecdsa \
      tlslite-ng  \
      m2crypto \
      pycrypto \
      gmpy && \
    git clone https://github.com/mozilla/cipherscan.git && \
    git clone https://github.com/PeterMosmans/openssl.git --depth 1 -b 1.0.2-chacha && \
    cd openssl && \
    ./Configure zlib no-shared experimental-jpake enable-md2 enable-rc5 \
      enable-rfc3779 enable-gost enable-static-engine linux-x86_64 && \
    make depend && \
    make && \
    make report && \
    cp /app/openssl/apps/openssl /app/cipherscan/openssl && \
    cd /app/cipherscan && \
    ./cscan.sh || : && \
    rm -rf /var/cache/apk/* && \
    rm -rf /app/openssl && \
    apk del .build-deps

COPY ./docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
