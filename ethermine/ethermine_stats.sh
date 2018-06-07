#!/bin/bash

JQ=/usr/local/bin/jq
url="https://api.ethermine.org/miner/YOUR_WALLET_HERE/dashboard"
response=$(curl -s $url | $JQ '.data.currentStatistics')
current_hashrate=$(echo $response | $JQ '.currentHashrate')
parsed_hashrate=$(awk -v var1=$current_hashrate -v var2=1000000 'BEGIN { print  ( var1 / var2 ) }')
unpaid=$(echo $response | $JQ '.unpaid')
parsed_unpaid=$(awk -v var1=$unpaid -v var2=1000000000000000000 'BEGIN { print  ( var1 / var2 ) }' | xargs printf "%.5f")
echo $parsed_hashrate | xargs printf "%.0f"" MH/s | "$parsed_unpaid" ETH"
