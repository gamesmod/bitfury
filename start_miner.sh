#!/bin/bash

while true
do
  ping -c 1 github.com
  if [[ $? == 0 ]]; then
    echo "Network available"
    break;
  else
    echo "Network not up yet..."
    sleep 5
  fi
done


_IP=$(hostname -I)




echo "Updating code and settings..."
cd /miner && git pull

echo "Loading environment variables..."
source /miner/settings.conf


echo "Starting proxy..."
cd /miner/stratum-mining-proxy/
screen -S stratum1 -d -m ./mining_proxy.py -o $POOL1_ADDRESS -p $POOL1_PORT -cu $POOL1_USER -cp $POOL1_PASS -rt -gp 8332 -v
screen -S stratum2 -d -m ./mining_proxy.py -o $POOL1_ADDRESS -p $POOL1_PORT -cu $POOL1_USER -cp $POOL1_PASS -rt -gp 8333 -v
screen -S stratum3 -d -m ./mining_proxy.py -o $POOL1_ADDRESS -p $POOL1_PORT -cu $POOL1_USER -cp $POOL1_PASS -rt -gp 8334 -v

echo "Starting miner..."
cd /run/shm
screen -S miner -d -m /miner/pi-miner/miner


MINER_RUNNING=1
exit 0
