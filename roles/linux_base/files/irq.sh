#!/bin/bash


irq=$(awk -F: '/eth0/{ print $1 }' /proc/interrupts)
if [ -e /proc/irq/${irq}/smp_affinity ]; 
then 
  echo 1 > /proc/irq/${irq}/smp_affinity
fi
