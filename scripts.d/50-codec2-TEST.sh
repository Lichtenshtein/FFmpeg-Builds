#!/bin/bash

SCRIPT_REPO="https://github.com/drowe67/codec2.git"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

apt-get install libcodec2-dev

git clone --depth=1 https://github.com/drowe67/codec2.git
cd codec2
mkdir build_linux
cd build_linux
cmake ..
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
cd ..\..

}

ffbuild_configure() {
    echo --enable-libcodec2
}

ffbuild_unconfigure() {
    echo --disable-libcodec2
}