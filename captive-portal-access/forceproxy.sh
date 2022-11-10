#!/bin/sh

sleep 180s

#Re-Setting Proxy for due to timeout or connection
networksetup -setwebproxy "Wi-Fi" "your proxy address here" 80
sleep 1s
networksetup -setsecurewebproxy "Wi-Fi" "your proxy address here" 80
sleep 1s

