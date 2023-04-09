#!/bin/bash
./configure --prefix=/usr

make
make html

set +e
chown -Rv ydu .
su ydu -c "PATH=$PATH make check"
set -e

make DESTDIR=$1 install
install -d -m755 $1/usr/share/doc/sed-4.8
install -m644 doc/sed.html $1/usr/share/doc/sed-4.8