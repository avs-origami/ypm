#!/bin/bash
patch -Np1 -i ../coreutils-9.1-i18n-1.patch

autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

make
make DESTDIR=$1 install

mkdir -pv $1/usr/sbin
mkdir -pv $1/usr/share/man/man8

mv -v $1/usr/bin/chroot $1/usr/sbin
mv -v $1/usr/share/man/man1/chroot.1 $1/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $1/usr/share/man/man8/chroot.8
