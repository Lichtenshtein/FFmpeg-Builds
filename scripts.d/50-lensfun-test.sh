#!/bin/bash

SCRIPT_REPO="https://github.com/lensfun/lensfun.git"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

git clone --depth=1 https://github.com/lensfun/lensfun.git

cd lensfun
mkdir build
cd build
cmake ../
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
cd ../..

}

ffbuild_configure() {
    echo --enable-lensfun
}

ffbuild_unconfigure() {
    echo --disable-lensfun
}
