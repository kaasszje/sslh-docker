#!/bin/sh

sslh -f -u root --listen $LISTEN_IP:$LISTEN_PORT \
	   --ssh $SSH_HOST:$SSH_PORT \
	   --tls $HTTPS_HOST:$HTTPS_PORT \
	   --http $HTTP_HOST:$HTTP_PORT \
	   --openvpn $OPENVPN_HOST:$OPENVPN_PORT \
	   --socks5 $SOCKS_HOST:$SOCKS_PORT \
           --anyprot $OTHER_HOST:$OTHER_PORT \
           $@
