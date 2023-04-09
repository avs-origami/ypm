#!/bin/bash
./configure --prefix=/usr

make
make DESTDIR=$1 install

ln -sv $1/usr/bin/vim $1/usr/bin/vi
for L in $1/usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv $1/usr/share/vim/vim90/doc $1/usr/share/doc/vim-9.0.0228
