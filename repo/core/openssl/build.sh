#!/bin/bash
./config --prefix=/usr     \
	--openssldir=/etc/ssl \
        --libdir=lib          \
        shared                \
        zlib-dynamic

make

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl DESTDIR=$1 install

mv -v $1/usr/share/doc/openssl $1/usr/share/doc/openssl-3.0.5
