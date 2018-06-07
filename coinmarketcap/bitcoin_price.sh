#!/bin/bash

JQ=/usr/local/bin/jq
url="https://api.coinmarketcap.com/v1/ticker/bitcoin/"
response=$(curl -s $url | $JQ '.[0]')
price_usd=$(echo $response | $JQ '.price_usd' | xargs printf "%.0f")
percent_change_1h=$(echo $response | $JQ '.percent_change_1h' | xargs printf "%.2f")
arrow=" ▲ "
if [[ $percent_change_1h < 0 ]]; then
	arrow=" ▼ "
fi
echo "$ "$price_usd$arrow$percent_change_1h"%"
