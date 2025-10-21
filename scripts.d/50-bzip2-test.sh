#!/bin/bash

SCRIPT_REPO="https://github.com/ImageMagick/bzip2.git"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

apt-get install libbz2-dev

git clone --depth=1 https://github.com/ImageMagick/bzip2.git
cd bzip2
./configure
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
cd ..
  
}

ffbuild_configure() {
    echo --enable-bzlib
}

ffbuild_unconfigure() {
    echo --disable-bzlib
}
