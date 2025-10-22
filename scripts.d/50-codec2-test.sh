#!/bin/bash

SCRIPT_REPO="https://github.com/drowe67/codec2.git"
SCRIPT_COMMIT="96e8a19c2487fd83bd981ce570f257aef42618f9"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing
# no fucking clue what the directories on remote machine are.
# official instructions don't fit.
# like a fucking blind game with 50 mins periods per move
# building. error. building. error. google. building. error. google. building. error. error. error. open software, fuck yeah. 
# doen't build. then fuck it.

ffbuild_dockerbuild() {

# apt-get install -y libcodec2-dev

    mkdir build && cd build
    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DHEADERS_ONLY=ON ..
#  cmake ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --enable-libcodec2
}

ffbuild_unconfigure() {
    echo --disable-libcodec2
}
