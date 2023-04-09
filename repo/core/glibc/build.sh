patch -Np1 -i ../glibc-2.36-fhs-1.patch

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/usr/lib

make

touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make DESTDIR=$1 install

sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

mkdir -p $1/etc
cp -v ../nscd/nscd.conf $1/etc/nscd.conf
mkdir -pv $1/var/cache/nscd

install -v -Dm644 ../nscd/nscd.tmpfiles $1/usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service $1/usr/lib/systemd/system/nscd.service

mkdir -pv /usr/lib/locale

cp ../../tzdata2022c.tar.gz $1/install