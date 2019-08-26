#!/bin/bash

# Ask the password to login
read -sp 'Password: ' passvar
echo

if [ "$passvar" = "<your hardcoded password>" ]; then
echo -e "\e[1;32m[+] Welcome user, you are authorized to use this script \e[0m"
echo -e "\e[1;31m--------NMAP TCP and UDP Sync Full Port Scan-------- \e[0m"

# Ask the user for input
echo -e "\e[1;32m[+] Hello, please enter the IP to be scanned \e[0m"
read varIP
echo -e "\e[1;32m[+] Nmap result save as: \e[0m"
read varFName

echo -e "\e[1;32m[+] Initiating fast nmap scan to detect the ports \e[0m"
mkdir "Nmap Scan"
cd "Nmap Scan"
nmap -p- -T4 -Pn $varIP --max-rate 20000 --min-rate 5000 --max-parallelism 50 --min-parallelism 30 --max-retries 3 | tee -a op1

echo -e "\e[1;32m[+] Extracting Ports \e[0m"
ports=$(cat "op1" | awk '/open/{print $1}' | cut -d "/" -f 1 | sed 's/ //g' | tr '\n' ',' | sed s'/.$//')
echo -e "\e[1;32m[+] Identified TCP port(s) : $ports \e[0m"

echo -e "\e[1;32m[+] Initiating T4 scans \e[0m"
echo -e "\e[1;32m[+] Initiating Default script TCP scan \e[0m"
nmap $varIP -p ${ports} -Pn -A -sC -T4 -oA ${varFName}_Default_Script_TCP | tee
echo -e "\e[1;32m[+] Default script TCP scan done and initiating vulnerabliltiy TCP script scan \e[0m"
nmap $varIP -p ${ports} -Pn -A -sC -T4 --script vuln -oA ${varFName}_Vulnerability_Script_TCP | tee
echo -e "\e[1;32m[+] Vuln script scan done and initiating full throttle UDP scan \e[0m"
nmap -p- -Pn $varIP -sU --max-rate 20000 --min-rate 5000 --max-parallelism 50 --min-parallelism 30 --max-retries 3 | tee -a ${varFName}_UDP
chmod 700 *

else
 echo "wrong password, bye."
fi
