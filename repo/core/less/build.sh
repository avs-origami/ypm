#!/bin/bash
./configure --prefix=/usr --sysconfdir=/etc

make
make DESTDIR=$1 install
