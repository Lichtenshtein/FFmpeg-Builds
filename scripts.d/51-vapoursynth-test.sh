#!/bin/bash

SCRIPT_REPO="https://github.com/vapoursynth/vapoursynth.git"
SCRIPT_COMMIT="8707cbfdaf2991404e4473b16adf4f7b286431d3"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

# wtf it this?
# apt-get install -y openssl cmake libevent-dev libjpeg-dev libgif-dev libpng-dev libwebp-dev libmagickcore5 libmagickwand5 libmemcached-dev

# apt-get install -y devscripts equivs 

apt-get install -y libzimg-dev intltool \
libavutil-dev libavcodec-dev libswscale-dev \
python3-dev Cython

# pip3 install Cython

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"

    ./autogen.sh
    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --enable-vapoursynth
}

ffbuild_unconfigure() {
    echo --disable-vapoursynth
}
