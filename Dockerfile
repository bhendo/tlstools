FROM python:3.7-slim

WORKDIR /tools

RUN mkdir -p /output && \
    pip install sslyze && \
    sslyze --update_trust_stores && \
    apt-get update && \
    apt-get install -y --no-install-recommends bsdmainutils && \
    savedAptMark="$(apt-mark showmanual)" && \
    apt-get install -y --no-install-recommends git && \
    git clone https://github.com/mozilla/cipherscan.git && \
    cipherscan/cscan.sh || : && \
    apt-mark auto '.*' > /dev/null && \
	  apt-mark manual $savedAptMark && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/*

COPY ./analyze.py /tools/cipherscan/analyze.py

COPY ./docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
