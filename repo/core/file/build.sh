#!/bin/bash
./configure --prefix=/usr

make
make check
make DESTDIR=$1 install
