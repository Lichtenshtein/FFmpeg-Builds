#!/bin/bash

SCRIPT_REPO="https://github.com/DMTarmey/flite.git"
# Forked repo, original author: dantmnf

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

ffbuild_dockerbuild() {

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
	
}

ffbuild_configure() {
    echo --enable-libflite
}

ffbuild_unconfigure() {
    echo --disable-libflite
}