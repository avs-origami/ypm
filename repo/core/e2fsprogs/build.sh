#!/bin/bash
mkdir build
cd build

../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck

make
make DESTDIR=$1 install

rm -fv $1/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v $1/usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir $1/usr/share/info/libext2fs.info
makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info $1/usr/share/info
install-info --dir-file=/usr/share/info/dir $1/usr/share/info/com_err.info
