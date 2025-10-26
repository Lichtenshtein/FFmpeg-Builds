#!/bin/bash

SCRIPT_REPO="https://github.com/ImageMagick/bzip2.git"
SCRIPT_COMMIT="abffe764f875f71d051efb19d4c83139375f82d7"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing
# line 32: ./configure: No such file or directory
# no. stop trying. you won't succeed. you'll never build anything yourself with these scripts.

ffbuild_dockerbuild() {

#    local myconf=(
#        --prefix="$FFBUILD_PREFIX"
#        --disable-shared
#        --enable-static
#    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"

#    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
  
}

ffbuild_configure() {
    echo --enable-bzlib
}

ffbuild_unconfigure() {
    echo --disable-bzlib
}
