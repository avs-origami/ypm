#!/bin/bash
chmod -v u+w $1/usr/lib/libtcl8.6.so

cd unix
make install-private-headers
cd ..

ln -sfv $1/usr/bin/tclsh8.6 $1/usr/bin/tclsh
mv $1/usr/share/man/man3/{Thread,Tcl_Thread}.3
