#!/bin/bash

SCRIPT_REPO="https://github.com/MartinEesmaa/uavs3e.git"
SCRIPT_COMMIT="eca828b2cf05ebb7fef2e2505e3ee2a2156ba2b1"

ffbuild_enabled() {
    [[ $TARGET == win32 ]] && return -1
    [[ $TARGET == *arm64 ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    echo "git clone \"$SCRIPT_REPO\" . && git checkout \"$SCRIPT_COMMIT\""
}

ffbuild_dockerbuild() {
    mkdir build/linux
    cd build/linux

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DCOMPILE_10BIT=1 -DCOMPILE_FFMPEG=ON -DBUILD_SHARED_LIBS=NO ../..
    make -j$(nproc)
    make install


    # Just in case to detect header files default before FFmpeg
    cp -f "$FFBUILD_PREFIX"/include/uavs3e/uavs3e.h "$FFBUILD_PREFIX"/include
    cp -f "$FFBUILD_PREFIX"/include/uavs3e/com_api.h "$FFBUILD_PREFIX"/include
}

ffbuild_configure() {
    echo --enable-libuavs3e
}

ffbuild_unconfigure() {
    (( $(ffbuild_ffver) > 700 )) || return 0
    echo --disable-libuavs3e
}
