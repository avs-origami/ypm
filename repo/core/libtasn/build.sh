#!/bin/bash
./configure --prefix=/usr --disable-static &&

make
make DESTDIR=$1 install
