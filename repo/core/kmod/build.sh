#!/bin/bash
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib

make
make DESTDIR=$1 install

mkdir -pv $1/usr/sbin

for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv $1/usr/bin/kmod $1/usr/sbin/$target
done

ln -sfv kmod $1/usr/bin/lsmod
