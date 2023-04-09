#!/bin/bash
pwconv
grpconv

mkdir -p /etc/default
useradd -D --gid 999

echo "Set a root password:"
passwd
