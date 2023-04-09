#!/bin/bash
for lib in ncurses form panel menu ; do
    rm -vf                    $1/usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > $1/usr/lib/lib${lib}.so
    cp -fv misc/${lib}w.pc         $1/usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     $1/usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > $1/usr/lib/libcursesw.so
ln -sfv libncurses.so      $1/usr/lib/libcurses.so

mkdir -pv $1/usr/share/doc/ncurses-6.3
cp -v -R doc/* $1/usr/share/doc/ncurses-6.3
