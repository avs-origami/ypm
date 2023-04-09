#!/bin/bash
patch -Np1 -i ../kbd-2.5.1-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make
make DESTDIR=$1 install

mkdir -pv $1/usr/share/doc/kbd-2.5.1
cp -R -v docs/doc/* $1/usr/share/doc/kbd-2.5.1
