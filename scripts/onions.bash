#!/bin/bash

# Print onion addresses

# Check to see if electrs is running
if ./start ps electrs > /dev/null 2>&1; then
    electrs_onion="$(./start exec -u tor tor cat /var/lib/tor/electrs/hostname)"
    echo "Electrum Server: $electrs_onion"
fi

bitcoin_onion="$(./start exec -u bitcoin bitcoin bitcoin-cli getnetworkinfo | python3 -c "import sys, json; print(json.load(sys.stdin)['localaddresses'][0]['address'])")"
echo "Bitcoin Server: $bitcoin_onion"
