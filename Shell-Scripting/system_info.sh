#!/bin/bash

current_date=$(date)
host_name=$(hostname)
user_name=$(whoami)

echo "Current Date: $current_date"
echo "Hostname: $host_name"
echo "Username: $user_name"

echo "Disk Usage:"
df -h

echo "Running Processes:"
ps

read -p "Enter your name: " input_name
echo "Hello, $input_name"

mkdir -p system_info
touch system_info/processes.txt

ps > system_info/processes.txt

echo "Process information saved to system_info/processes.txt"

