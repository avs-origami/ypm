#!/bin/bash
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -v build
cd build

../configure --prefix=/usr        \
	      LD=ld                    \
        --enable-languages=c,c++ \
        --disable-multilib       \
        --disable-bootstrap      \
        --with-system-zlib

make

#ulimit -s 32768

#chown -Rv ydu .
#su ydu -c "PATH=$PATH make -k check"

#../contrib/test_summary

make DESTDIR=$1 install

#chown -v -R root:root \
#    $1/usr/lib/gcc/$($1/usr/bin/gcc -dumpmachine)/12.2.0/include{,-fixed}
