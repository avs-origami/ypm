#!/bin/bash
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

python3 configure.py --bootstrap

mkdir -pv $1/usr/bin
mkdir -pv $1/usr/share/bash-completion/completions
mkdir -pv $1/usr/share/zsh/site-functions/_ninja

install -vm755 ninja $1/usr/bin/
install -vDm644 misc/bash-completion $1/usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  $1/usr/share/zsh/site-functions/_ninja
