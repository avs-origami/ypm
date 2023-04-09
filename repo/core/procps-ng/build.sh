#!/bin/bash
./configure --prefix=/usr                            \
            --docdir=/usr/share/doc/procps-ng-4.0.0 \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd

make
make DESTDIR=$1 install
