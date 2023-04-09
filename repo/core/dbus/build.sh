#!/bin/bash
./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --runstatedir=/run                   \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-1.14.0 \
            --with-system-socket=/run/dbus/system_bus_socket

make
make DESTDIR=$1 install

mkdir -pv $1/var/lib/dbus
ln -sfv $1/etc/machine-id $1/var/lib/dbus
