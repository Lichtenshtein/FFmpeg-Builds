#!/bin/bash

SCRIPT_REPO="https://github.com/lensfun/lensfun.git"
SCRIPT_COMMIT="ef7a8498b4b010cd927cf773a710489dcbb5b312"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

#git clone --depth=1 https://github.com/lensfun/lensfun.git

cd lensfun
mkdir build
cd build
cmake ../
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
cd ../..

}

ffbuild_configure() {
    echo --enable-liblensfun
}

ffbuild_unconfigure() {
    echo --disable-liblensfun
}
