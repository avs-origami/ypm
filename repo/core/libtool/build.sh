#!/bin/bash
./configure --prefix=/usr

make
make DESTDIR=$1 install
rm -fv $1/usr/lib/libltdl.a
