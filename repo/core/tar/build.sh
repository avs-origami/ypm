#!/bin/bash
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make
make DESTDIR=$1 install
make DESTDIR=$1 -C doc install-html docdir=/usr/share/doc/tar-1.34
