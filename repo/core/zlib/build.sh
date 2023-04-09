#!/bin/bash
./configure --prefix=/usr

make
make check
make DESTDIR=$1 install

rm -fv $1/usr/lib/libz.a
