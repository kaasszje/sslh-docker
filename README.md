Build will pull source from https://github.com/yrutschle/sslh.git<br>
<br>
Make an env file with several parameters.<br>
Example:<br>
SSH_HOST=192.168.1.6<br>
SSH_POST=22<br>
HTTPS_HOST=192.168.1.6<br>
HTTPS_PORT=443<br>
HTTP_HOST=192.168.1.20<br>
HTTP_PORT=8005<br>
OTHER_HOST=192.168.1.6<br>
OTHER_PORT=80<br>
<br>
Run with:<br>
docker run --env-file=./env --name sslh2 -d --rm -p 9443:443 kaasszje/sslh<br>
<br>
Dockerfile:<br>
FROM alpine AS builder<br>
RUN apk add --no-cache libconfig libconfig-dev make gcc build-base perl pcre-dev pcre git<br>
RUN mkdir /build<br>
RUN git clone https://github.com/yrutschle/sslh.git /build<br>
RUN cd /build; export USELIBWRAP=; make -e install<br>
<br>
FROM alpine<br>
<br>
ENV LISTEN_IP 0.0.0.0<br>
ENV LISTEN_PORT 443<br>
ENV SSH_HOST localhost<br>
ENV SSH_PORT 22<br>
ENV OPENVPN_HOST localhost<br>
ENV OPENVPN_PORT 1194<br>
ENV HTTPS_HOST localhost<br>
ENV HTTPS_PORT 443<br>
ENV HTTP_HOST localhost<br>
ENV HTTP_PORT 80<br>
ENV SOCKS_HOST localhost<br>
ENV SOCKS_PORT 1080<br>
ENV OTHER_HOST localhost<br>
ENV OTHER_PORT 443<br>
<br>
RUN apk add --no-cache libconfig pcre<br>
COPY --from=builder /build/sslh-select /usr/local/bin/sslh<br>
ADD entry.sh /usr/local/bin/entry.sh<br>
RUN chmod +x /usr/local/bin/entry.sh<br>
ENTRYPOINT ["/usr/local/bin/entry.sh"]<br>
<br>
With this you should be able to build it for any platform.<br>
Will be trying to make a transparent proxy or perhaps the client ip in side a header through nginx.<br>
