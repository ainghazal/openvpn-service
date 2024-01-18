OVPN_DATA = ovpn-data-local
VPN_SERVER_NAME = vpn.local
CLIENT ?= client0

start:
	docker run -v ${OVPN_DATA}:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

init-volume:
	docker volume create --name ${OVPN_DATA}
	docker run -v ${OVPN_DATA}:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://${VPN_SERVER_NAME}
	docker run -v ${OVPN_DATA}:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

gen-cert:
	docker run -v ${OVPN_DATA}:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full ${CLIENT} nopass
	docker run -v ${OVPN_DATA}:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient ${CLIENT} > certs/${CLIENT}.ovpn
