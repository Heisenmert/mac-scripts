#!/bin/sh

###Interfaces has bypass proxy list###
echo "Wi-Fi" >> /tmp/mac_networks.txt
echo "Thunderbolt Bridge" >> /tmp/mac_networks.txt
echo "USB Ethernet" >> /tmp/mac_networks.txt
echo "USB 10/100 LAN" >> /tmp/mac_networks.txt
echo "USB 10/100/1000 LAN" >> /tmp/mac_networks.txt
echo "Display Ethernet" >> /tmp/mac_networks.txt

###Domains that wanted to add to bypass proxy list###
domain1="domain1"
domain2="domain2"
networksetup -listallnetworkservices > /tmp/ethernet.txt

while IFS= read -r i 

do

    echo "#####################"
    if grep -w "$i" /tmp/ethernet.txt > /dev/null 2>&1; then

      echo "$i is an interface on the Mac, should check for bypass proxy."
      curr_domains=$(networksetup -getproxybypassdomains "$i")

      if [[ "$curr_domains" == *"$domain1"* && "$curr_domains" == *"$domain2"* ]]; then
        echo "Limited Access bypass proxy domains for $i are configured"

      elif [[ "$curr_domains" == *"$domain1"* ]]; then
        echo "domain1 is at the list but domain2 is NOT!, will be added for $i network interface."
        if [ "$curr_domains" == "There aren't any bypass domains set on $i." ]; then
          echo "There aren't any bypass domains at the list"
          sudo networksetup -setproxybypassdomains "$i" $domain2
        else
          echo "There are some bypass domains at the list"
          sudo networksetup -setproxybypassdomains "$i" $(networksetup -getproxybypassdomains "$i") $domain2
        fi

      elif [[ "$curr_domains" == *"$domain2"* ]]; then
        echo "domain2 is at the list but domain1 is NOT!, will be added for $i network interface."
        if [ "$curr_domains" == "There aren't any bypass domains set on $i." ]; then
          echo "There aren't any bypass domains at the list"
          sudo networksetup -setproxybypassdomains "$i" $domain1
        else
          echo "There are some bypass domains at the list"
          sudo networksetup -setproxybypassdomains "$i" $(networksetup -getproxybypassdomains "$i") $domain1
        fi

      else
        echo "None of them configured. Will be added both." 
        if [ "$curr_domains" == "There aren't any bypass domains set on $i." ]; then
            echo "There aren't any bypass domains at the list"
            sudo networksetup -setproxybypassdomains "$i" $domain1
            sleep 1s
            sudo networksetup -setproxybypassdomains "$i" $(networksetup -getproxybypassdomains "$i") $domain2
        else
            echo "There are some bypass domains at the list"
            sudo networksetup -setproxybypassdomains "$i" $(networksetup -getproxybypassdomains "$i") $domain1
            sleep 1s
            sudo networksetup -setproxybypassdomains "$i" $(networksetup -getproxybypassdomains "$i") $domain2
        fi
      fi

    else
      echo "$i is not an interface on the Mac, will continue..."
    fi
    echo "#####################"
done < /tmp/mac_networks.txt

#delete the txt files
rm -rf /tmp/ethernet.txt
rm -rf /tmp/mac_networks.txt
exit 0
















