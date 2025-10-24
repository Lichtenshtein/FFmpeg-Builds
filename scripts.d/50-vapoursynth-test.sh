#!/bin/bash

SCRIPT_REPO="https://github.com/vapoursynth/vapoursynth.git"
SCRIPT_COMMIT="8707cbfdaf2991404e4473b16adf4f7b286431d3"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing
# vapourfuck. nah.

ffbuild_dockerbuild() {

apt-get install -y libzimg-dev zimg autoconf automake libtool g++ pkg-config build-essential python3-dev unzip 
apt-get install -y openssl cmake libevent-dev libjpeg-dev libgif-dev libpng-dev libwebp-dev libmagickcore5 libmagickwand5 libmemcached-dev
pip3 install Cython

git clone https://github.com/sekrit-twc/zimg.git
cd zimg
./autogen.sh
./configure --prefix=="$FFBUILD_PREFIX" --enable-static --disable-shared
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"

# git clone --depth=1 https://github.com/vapoursynth/vapoursynth.git
cd vapoursynth
./autogen.sh
./configure --prefix=="$FFBUILD_PREFIX" --host="$FFBUILD_TOOLCHAIN" --disable-shared --enable-static
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --enable-vapoursynth
}

ffbuild_unconfigure() {
    echo --disable-vapoursynth
}
