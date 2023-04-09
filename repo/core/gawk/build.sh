#!/bin/bash
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr

make
make DESTDIR=$1 install
