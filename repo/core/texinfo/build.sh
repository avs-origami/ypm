#!/bin/bash
./configure --prefix=/usr

make
make DESTDIR=$1 install
