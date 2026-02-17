FROM debian:13.3-slim

ENV DEBIAN_FRONTEND="noninteractive"
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY src/* /usr/local/bin/

RUN chmod -R +x /usr/local/bin/* /entrypoint.sh; \
	\
	apt-get update; \
    apt-get -y --no-install-recommends install \
		ca-certificates \
		gosu \
		jq \
		locales \
		wget; \
    apt-get -y autoremove; \
	apt-get -y autoclean; \
	apt-get -y clean; \
	rm -Rf /var/lib/apt/lists/* \
	\
	sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen; \
	locale-gen

EXPOSE 42420/tcp

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "run.sh" ]
