#!/bin/bash
./configure --prefix=/usr \
	--docdir=/usr/share/doc/flex-2.6.4 \
	--disable-static

make
make check
make DESTDIR=$1 install

ln -sv flex $1/usr/bin/lex
