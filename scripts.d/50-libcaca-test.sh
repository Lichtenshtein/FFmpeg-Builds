#!/bin/bash

SCRIPT_REPO="https://github.com/chiefjazzdiewltr/libcaca.git"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

git clone --depth=1 https://github.com/chiefjazzdiewltr/libcaca.git
cd libcaca
./configure --enable-ncurses --enable-slang --enable-conio --disable-imlib2 --enable-gl --enable-win32 --enable-network
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
cd ..
  
}

ffbuild_configure() {
    echo --enable-libcaca
}

ffbuild_unconfigure() {
    echo --disable-libcaca
}
