#!/bin/bash
if [ $(expect -c "spawn ls") != "spawn ls" ]
then
	echo "Error: PTYs aren't working properly."
	exit 1
fi

mkdir -v build
cd build

../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

make tooldir=/usr
make -k check
make tooldir=/usr DESTDIR=$1 install

rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a
