#!/bin/bash

# This script will set optomizations for all active interfaces detected. 

nics=$(/sbin/ifconfig | egrep -o '^[a-z]+[0-9]+')
ifcfg=/sbin/ifconfig
ethtool=/usr/sbin/ethtool

for nic in ${nics[@]}; 
do
    case ${nic/[0-9]} in  
        'ib') # Ignore Infiniband interfaces
            continue ;;
        'bond') # Ignore virtual bond interfaces
            continue ;;
    esac
    
    rxtx=$(${ethtool} -g ${nic} | awk '/Pre-set/,/TX/ { if($0 ~ /RX:|TX:/) { print $2 }}' | tr -s '\n' ' ')
    ${ethtool} -G ${nic} $(echo ${rxtx} | awk '{ print "rx " $1 " tx " $2 }')
    ${ifcfg} ${nic} txqueuelen 2048
    ${ethtool} -C ${nic} adaptive-rx off rx-usecs 0 rx-frames 0 
    ${ethtool} -K ${nic} lro on # large receive offload capability 
done
