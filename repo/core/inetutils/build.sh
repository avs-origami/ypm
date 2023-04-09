#!/bin/bash
./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make
make DESTDIR=$1 install

mkdir -pv $1/usr/sbin/
mv -v $1/usr/{,s}bin/ifconfig
