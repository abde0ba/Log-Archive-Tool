#!/bin/bash

mkdir -p /logs

while true; do
    echo "System running at $(date)" >> /logs/system.log
    sleep 2
done