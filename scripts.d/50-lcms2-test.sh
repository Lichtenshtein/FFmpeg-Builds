#!/bin/bash

SCRIPT_REPO="https://github.com/mm2/Little-CMS.git"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

apt-get install liblcms2-dev

git clone --depth=1 https://github.com/mm2/Little-CMS.git
cd Little-CMS
./configure
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
cd ..
  
}

ffbuild_configure() {
    echo --enable-lcms2
}

ffbuild_unconfigure() {
    echo --disable-lcms2
}
