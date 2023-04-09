#!/bin/bash
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

make
make DESTDIR=$1 install
