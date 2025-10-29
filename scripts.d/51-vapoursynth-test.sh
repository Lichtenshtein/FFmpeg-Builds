#!/bin/bash

SCRIPT_REPO="https://github.com/vapoursynth/vapoursynth.git"
SCRIPT_COMMIT="8707cbfdaf2991404e4473b16adf4f7b286431d3"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

# wtf it this? why i added this?
# apt-get install -y openssl cmake libevent-dev libjpeg-dev libgif-dev libpng-dev libwebp-dev libmagickcore5 libmagickwand5 libmemcached-dev

# apt-get install -y devscripts equivs 

apt-get install -y libzimg-dev intltool \
libavutil-dev libavcodec-dev libswscale-dev \
python3-dev python3.12 python3.12-venv

# python3 -m venv Cython
python3.12 -m venv Cython
source Cython/bin/activate    
pip install Cython

# again. let's help ourselves find python3.12 for that stupid fuck
dpkg -L libglib2.0-dev
ldconfig -p | grep libglib
ldconfig -p | grep glib
find / -name "python*.pc" 2>/dev/null

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
#    export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/x86_64-linux-gnu/glib-2.0:/usr/include/glib-2.0:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/glib-2.0/include:$PKG_CONFIG_PATH"
    
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
