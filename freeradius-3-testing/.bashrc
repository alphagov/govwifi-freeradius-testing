#!/bin/bash

export HOSTIP="$(/sbin/ip route | awk '/default/ { print $3 }')"

clear
echo "Welcome to the FreeRADIUS testing environment"
echo ""
echo "If this console is running in the same container as FreeRADIUS (you used 'docker exec') then"
echo "keep 127.0.0.1 as the host for the following commands."
echo ""
echo "If you are running this console in a separate container (you used docker run) then you will" 
echo 'need to replace 127.0.0.1 with $HOSTIP'
echo ""
echo "1 - basic PAP authentication:"
echo "> radtest testing password localhost 0 testing123"
echo ""
echo "2 - simple chap or mschap authentication:"
echo "> radtest -t chap testing password localhost 0 testing123"
echo "> radtest -t mschap testing password localhost 0 testing123"
echo ""
echo "3 - EAP-TTLS authentication:"
echo "> eapol_test -a 127.0.0.1 -c /etc/freeradius/eapol-test/eap-ttls.conf -s testing123"
echo ""
echo "4 - PEAP-MSCHAPv2 (PEAPv0) authentication (used by GovWifi):"
echo "> eapol_test -a 127.0.0.1 -c /etc/freeradius/eapol-test/peap-mschapv2.conf -s testing123"
echo ""
echo "5 - TLS, i.e. certficate-only, device wifi:"
echo "> eapol_test -a 127.0.0.1 -c /etc/freeradius/eapol-test/tls.conf -s testing123"
echo ""