FROM debian:13.3-slim

ENV DEBIAN_FRONTEND="noninteractive"

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY src/* /usr/local/bin/

RUN chmod -R +x /usr/local/bin/* /entrypoint.sh; \
	apt-get update; \
    apt-get install -y gosu jq wget; \
    apt-get -y autoremove; \
	apt-get -y autoclean; \
	apt-get -y clean; \
	rm -Rf /var/lib/apt/lists/*

EXPOSE 42420/tcp

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "run.sh" ]
