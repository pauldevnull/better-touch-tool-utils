#!/bin/bash

JQ=/usr/local/bin/jq
url="https://api.robinhood.com/api-token-auth/"
headers="Accept: application/json"
credentials="username=YOUR_USERNAME_HERE&password=YOUR_PASSWORD_HERE"
token=$(curl -s $url -H "${headers}" -d "${credentials}" | $JQ '.token' | sed -e "s:\"::g")
account_url="https://api.robinhood.com/accounts/"
authorization="Authorization: Token ${token}"
portfolio_url=$(curl -s $account_url -H "${headers}" -H "${authorization}" | $JQ '.results[0].portfolio' | sed -e "s:\"::g")
portfolio=$(curl -s $portfolio_url -H "${headers}" -H "${authorization}")
equity=$(echo $portfolio | $JQ '.equity' | bc)
equity_previous_close=$(echo $portfolio | $JQ '.equity_previous_close' | bc)
change=$(awk -v var1=$equity -v var2=$equity_previous_close 'BEGIN { print ( var1 - var2 ) }' | xargs printf "%.4f")
percent_change=$(awk -v var1=$change -v var2=$equity 'BEGIN { print ( var1 / var2 ) }' | xargs printf "%.4f")
percent_change=$(awk -v var1=1 -v var2=$percent_change 'BEGIN { print ( var1 - var2 ) }' | xargs printf "%.2f")
arrow=" ▲ "
if [[ $percent_change < 0 ]]; then
	arrow=" ▼ "
fi
equity=$(echo $equity | xargs printf "%.2f")
echo "$ "$equity $arrow $percent_change" %"
