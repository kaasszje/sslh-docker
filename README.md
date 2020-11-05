Build will pull source from https://github.com/yrutschle/sslh.git

Make an env file with several parameters.
Example:
SSH_HOST=192.168.1.6
SSH_POST=22
HTTPS_HOST=192.168.1.6
HTTPS_PORT=443
HTTP_HOST=192.168.1.20
HTTP_PORT=8005
OTHER_HOST=192.168.1.6
OTHER_PORT=80

Run with:
docker run --env-file=./env --name sslh2 -d --rm -p 9443:443 kaasszje/sslh

Dockerfile:
FROM alpine AS builder
RUN apk add --no-cache libconfig libconfig-dev make gcc build-base perl pcre-dev pcre git
RUN mkdir /build
RUN git clone https://github.com/yrutschle/sslh.git /build
RUN cd /build; export USELIBWRAP=; make -e install

FROM alpine

ENV LISTEN_IP 0.0.0.0
ENV LISTEN_PORT 443
ENV SSH_HOST localhost
ENV SSH_PORT 22
ENV OPENVPN_HOST localhost
ENV OPENVPN_PORT 1194
ENV HTTPS_HOST localhost
ENV HTTPS_PORT 443
ENV HTTP_HOST localhost
ENV HTTP_PORT 80
ENV SOCKS_HOST localhost
ENV SOCKS_PORT 1080
ENV OTHER_HOST localhost
ENV OTHER_PORT 443

RUN apk add --no-cache libconfig pcre
COPY --from=builder /build/sslh-select /usr/local/bin/sslh
ADD entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh
ENTRYPOINT ["/usr/local/bin/entry.sh"]

With this you should be able to build it for any platform.
Will be trying to make a transparent proxy or perhaps the client ip in side a header through nginx.
