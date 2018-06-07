#!/bin/bash

JQ=/usr/local/bin/jq
url="https://www.supportxmr.com/api/miner/YOUR_WALLET_HERE/stats"
response=$(curl -s $url)
hashrate=$(echo $response | $JQ '.hash')
unpaid=$(echo $response | $JQ '.amtDue')
parsed_unpaid=$(awk -v var1=$unpaid -v var2=1000000000000 'BEGIN { print  ( var1 / var2 ) }' | xargs printf "%.5f")
echo $hashrate" H/s | "$parsed_unpaid" XMR"
