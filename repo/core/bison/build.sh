#!/bin/bash
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make
make check
make DESTDIR=$1 install
