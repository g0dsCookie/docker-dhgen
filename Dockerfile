FROM alpine:3.7

ARG MAJOR
ARG MINOR
ARG PATCH
LABEL	maintainer="g0dsCookie <g0dscookie@cookieprojects.de>" \
	version="${MAJOR}.${MINOR}.${PATCH}" \
	description="A simple DH parameter generator."

RUN apk add --no-cache bash openssl \
 && mkdir /data

COPY docker-entrypoint.sh /

VOLUME [ "/data" ]

ENV	DH=2048:2;4096:2 \
	FILENAME=dh%s.pem \
	TIMEOUT=86400 \
	USER=root \
	GROUP=root \
	CHMOD=0640

WORKDIR /data
USER root

ENTRYPOINT [ "/docker-entrypoint.sh" ]
