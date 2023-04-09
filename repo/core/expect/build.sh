#!/bin/bash
./configure --prefix=/usr \
	--with-tcl=/usr/lib     \
        --enable-shared         \
        --mandir=/usr/share/man \
	--with-tclinclude=/usr/include/

make
make test
make DESTDIR=$1 install

ln -svf expect5.45.4/libexpect5.45.4.so $1/usr/lib
