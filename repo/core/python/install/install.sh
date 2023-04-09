#!/bin/bash
mkdir -pv $1/etc
cat > $1/etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

ln -sv $1/usr/bin/python3 $1/usr/bin/python
ln -sv $1/usr/bin/pip3 $1/usr/bin/pip
