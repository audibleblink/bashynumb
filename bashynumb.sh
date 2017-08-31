#!/usr/bin/env bash

# Shoutout to arr0way for the section and banner code and some of the
# enum calls - https://highon.coffee/blog/linux-local-enumeration-script

export PATH=/usr/bin:/bin:/usr/sbin:/sbin
if [ -t 1 ]; then # stdout is a term
  RED="\033[31m"
  YELLOW="\033[33m"
  BLUE="\033[34m"
  CYAN="\033[36m"
  NORMAL="\033[0;39m"
fi

printf "$CYAN"
cat << "EOF"
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
  printf "\n"
}

section "Current User Info"
id
echo on
hostname

section "Linux Version"
cat /etc/issue;
echo
cat /etc/*-release

section "Kernel Info"
uname -ar

section "Network Info"
cat /etc/network/interfaces || cat /etc/sysconfig/network
echo
cat /etc/resolv.conf
echo
ifconfig -a || ip addr
echo
route || ip route

section "Active Listening Services"
netstat -tulpn

section "File System Info"
df -h
echo
mount | column -t
echo
cat /etc/fstab

section "Users"
cat /etc/passwd

section "Groups"
cat /etc/group

section "Cron Info"
ls -lah /etc/cron*
echo
cat /etc/crontab
echo
crontab -l

section "SUID Files"
find / -perm -g=s -o -perm -4000 ! -type l -exec ls -ld {} \; 2>/dev/null | column -t

section "Root-owned, Writable and Executable Files"
find / -type f -executable -user root -writable -exec ls -ld {} \; 2>/dev/null | column -t

section "Root-owned, Writable Files"
find / -type f -user root -writable -exec ls -ld {} \; 2>/dev/null | column -t

section "World Writable Directories"
find / -perm -222 -type d -exec ls -ld {} \; 2>/dev/null | column -t

section "World Writable Files"
find / -type f -perm 0777 -exec ls -lah {} \; 2>/dev/null | column -t

section "Commands User Can Run with sudo"
test [ echo '' | sudo -S -l ] 2>/dev/null || echo "${USER} has no passwordless sudo commands configured"

section "Current User Sessions"
w

section "Processes Running as root"
ps -ef | grep root | grep -ve "\]$"

section "Installed Packages"
dpkg --list

