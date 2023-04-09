#!/bin/bash
sed '20,$ d' -i trust/trust-extract-compat &&
cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

mkdir p11-build &&
cd    p11-build &&

meson --prefix=/usr     \
      --buildtype=release \
      -Dtrust_paths=/etc/pki/anchors &&

ninja
DESTDIR=$1 ninja install &&
ln -sfv $1/usr/libexec/p11-kit/trust-extract-compat \
        $1/usr/bin/update-ca-certificates

cp -fv $1/usr/lib//pkcs11/p11-kit-trust.so $1/usr/lib/libnssckbi.so
