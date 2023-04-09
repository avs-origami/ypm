#!/bin/bash
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin DESTDIR=$1 install

mkdir -pv $1/usr/share/doc/iproute2-5.19.0
cp -v COPYING README* $1/usr/share/doc/iproute2-5.19.0
