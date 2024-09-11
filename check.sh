#!/bin/bash

# # Extract IP addresses from the Vagrantfile
# IPS=$(awk '/ip: / {print $4}' Vagrantfile | tr -d '",')

# # Print the extracted IP addresses for debugging
# echo "Extracted IP addresses:"
# echo "$IPS"

# # Loop through the IP addresses and run the hostname command
# for IP in $IPS; do
#   echo "Connecting to $IP..."
#   ssh -o "StrictHostKeyChecking=no" vagrant@$IP hostname
# done

for port in 2222 2200 2201; do
  ssh vagrant@127.0.0.1 -p $port hostname
done
