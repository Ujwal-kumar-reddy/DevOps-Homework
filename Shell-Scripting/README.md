# Shell Scripting

## System Information Script

The `system_info.sh` script displays basic system information and demonstrates shell scripting commands and concepts.

### Script

```bash
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

```

### Output

```text
Current Date: Thu Sep 3 11:03:30 UTC 2026
Hostname: UJWAL
Username: ujwalsalapala
Disk Usage:
[output of df -h]

Running Processes:
[output of ps]

Enter your name: Ujwal
Hello, Ujwal
Process information saved to system_info/processes.txt
```
