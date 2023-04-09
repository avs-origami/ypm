#!/bin/bash
./configure --prefix=/usr                   \
	--docdir=/usr/share/doc/bash-5.1.16 \
        --without-bash-malloc               \
        --with-installed-readline

make
make DESTDIR=$1 install
