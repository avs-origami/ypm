#!/bin/bash
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1

make
make DESTDIR=$1 install
