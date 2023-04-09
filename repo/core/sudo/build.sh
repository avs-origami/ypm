#!/bin/bash
./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.11p3 \
            --with-passprompt="[sudo] password for %p: " &&

make
make DESTDIR=$1 install
#cp -fv $1/usr/lib/sudo/libsudo_util.so.0.0.0 $1/usr/lib/sudo/libsudo_util.so.0
