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
RUN chmod 700 /usr/local/bin/entry.sh
ENTRYPOINT ["/usr/local/bin/entry.sh"]
