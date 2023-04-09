#!/bin/bash
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install



./configure --prefix=/usr \
	-disable-static \
	--with-curses    \
	--docdir=/usr/share/doc/readline-8.1.2

make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" DESTDIR=$1 install

### Probably not gonna need the docs but you could install them
# install -v -m644 doc/*.{ps,pdf,html,dvi} $1/usr/share/doc/readline-8.1.2
