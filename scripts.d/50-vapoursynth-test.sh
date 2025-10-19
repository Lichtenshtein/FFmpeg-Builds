#!/bin/bash

SCRIPT_REPO="https://github.com/vapoursynth/vapoursynth.git"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

apt-get install -y libzimg-dev zimg autoconf automake libtool g++ git pkg-config build-essential python3-dev unzip 
pip3 install Cython

git clone --depth=1 https://github.com/vapoursynth/vapoursynth.git
cd vapoursynth
./autogen.sh
./configure
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
cd ..

}

ffbuild_configure() {
    echo --enable-vapoursynth
}

ffbuild_unconfigure() {
    echo --disable-vapoursynth
}
