#!/bin/bash
ln -svr $1/usr/bin/cpp $1/usr/lib

mkdir -pv $1/usr/lib/bfd-plugins
cp -fv /etc/ypm/pkg/gcc/usr/libexec/gcc/$($1/usr/bin/gcc -dumpmachine)/12.2.0/liblto_plugin.so \
        $1/usr/lib/bfd-plugins/

mkdir -pv $1/usr/share/gdb/auto-load/usr/lib
mv -v $1/usr/lib/*gdb.py $1/usr/share/gdb/auto-load/usr/lib
