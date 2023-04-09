#!/bin/bash
./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&

make
make DESTDIR=$1 install
