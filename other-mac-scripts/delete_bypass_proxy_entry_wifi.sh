#!/bin/sh

#List Bypass Proxy Domains for WiFi Interface
curr_domains=$(networksetup -getproxybypassdomains "Wi-Fi")

#Enter domain to delete as hardcoded
new_domain_to_delete=""

if [[ "$curr_domains" == *"$new_domain_to_delete"* ]]; then
  echo "User has the domain that should be removed."
  curr_domains=${curr_domains//$new_domain_to_delete}
  sudo networksetup -setproxybypassdomains "Wi-Fi" $curr_domains

else
  echo "The $new_domain_to_delete isn't even at the proxy bypass list"
  exit 1
fi

