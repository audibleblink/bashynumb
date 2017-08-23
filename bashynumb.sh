#!/usr/bin/env bash

# Thanks to arr0way for the section and banner code and some of the 
# enum calls - https://highon.coffee/blog/linux-local-enumeration-script

BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"

printf "$GREEN"
/bin/cat << "EOF"
  _                _                             _
 | |              | |                           | |
 | | _   ____  ___| | _  _   _ ____  _   _ ____ | | _
 | || \ / _  |/___) || \| | | |  _ \| | | |    \| || \
 | |_) | ( | |___ | | | | |_| | | | | |_| | | | | |_) )
 |____/ \_||_(___/|_| |_|\__  |_| |_|\____|_|_|_|____/
                        (____/
EOF
printf "$NORMAL"
printf "Version: $YELLOW 1.0 $NORMAL \n"
printf "Twitter: $BLUE @4lex $NORMAL \n"
printf "\n"
printf "$RED Disclaimer: Use this 'software' at your own risk. $NORMAL  \n"
sleep 1

function section() {
  printf "\n"
  printf "\n"
  printf "$BLUE"
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '#'
  printf "##"
  printf "\n"
  printf "$RED"
  printf "$BLUE## $RED $@"
  printf "\n"
  printf "$BLUE"
  printf "##"
  printf "\n"
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '#'
  printf "$NORMAL"
}

section "Current User Info"
/usr/bin/id
echo
/bin/hostname

section "Linux Version"
/bin/cat /etc/issue;
echo
/bin/cat /etc/*-release

section "Kernel Info"
/bin/uname -ar

section "Network Info"
/bin/cat /etc/sysconfig/network
echo
/bin/cat /etc/resolv.conf
echo
ifconfig -a|| ip addr
echo
route || ip route

section "Active Listening Services"
/bin/netstat -tulpn 

section "File System Info"
/bin/df -h
echo
/bin/mount | column -t
echo
/bin/cat /etc/fstab

section "Users"
/bin/cat /etc/passwd

section "Groups"
/bin/cat /etc/group

section "SUID Files"
/usr/bin/find / -perm -g=s -o -perm -4000 ! -type l -exec ls -ld {} \; 2>/dev/null

section "World Writable Directories"
/usr/bin/find / -perm -222 -type d 2>/dev/null

section "World Writable Files"
/usr/bin/find / -type f -perm 0777 2>/dev/null

section "Root-owned, Writable Files"
find / -type f -user root -writable -exec ls -ld {} \; 2>/dev/null

section "Root-owned, Writable and Executable Files"
find / -type f -executable -user root -writable -exec ls -ld {} \; 2>/dev/null

section "Current User Sessions"
/usr/bin/w

section "Processes Running as root"
/bin/ps -ef | /bin/grep root | /bin/grep -ve "\]$"

section "Commands User Can Run with sudo"
test [ echo 1 | sudo -S -l ] 2>/dev/null || echo "${USER} has no passwordless sudo commands configured"

section "Cron Info"
/bin/ls -lah /etc/cron*
echo
/bin/cat /etc/crontab
echo
/usr/bin/crontab -l

section "Installed Packages"
/usr/bin/dpkg --list

