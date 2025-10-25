#!/bin/bash

SCRIPT_REPO="https://github.com/mm2/Little-CMS.git"
SCRIPT_COMMIT="5cdf3044d290e556beddc197b350aa88cc9bf00f"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing
# where the fuck is it cloning shit?
# no such directory. no such directory. fuck you.

ffbuild_dockerbuild() {

# apt-get install liblcms2-dev

#git clone --depth=1 https://github.com/mm2/Little-CMS.git
# cd Little-CMS
./configure --prefix=="$FFBUILD_PREFIX" --host="$FFBUILD_TOOLCHAIN" --disable-shared --enable-static
make -j$(nproc)
make install DESTDIR="$FFBUILD_DESTDIR"
# cd ..
  
}

ffbuild_configure() {
    echo --enable-lcms2
}

ffbuild_unconfigure() {
    echo --disable-lcms2
}
