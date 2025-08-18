#!/bin/bash

SCRIPT_REPO="https://github.com/cynagenautes/AudioToolboxWrapper"
# Forked repo, original author: dantmnf

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

ffbuild_dockerbuild() {
    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" .. -G Ninja
    ninja -j$(nproc)
    DESTDIR="$FFBUILD_DESTDIR" ninja install

    rm "$FFBUILD_DESTPREFIX"/bin/atw_ldwrapper
}

ffbuild_configure() {
    echo --enable-audiotoolbox --disable-outdev=audiotoolbox
}

ffbuild_unconfigure() {
    echo --disable-audiotoolbox
}

ffbuild_libs() {
    echo -lAudioToolboxWrapper
}
