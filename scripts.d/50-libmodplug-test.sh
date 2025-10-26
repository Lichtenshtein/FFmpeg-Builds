#!/bin/bash

SCRIPT_REPO="https://github.com/mywave82/libmodplug.git"
SCRIPT_COMMIT="dadf7058372c04ab28ee1fb5475d05e5e191e72e"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing
# 0.152 /stage.sh: line 32: ./configure: No such file or directory

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

    mkdir build
    cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=NO ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"


#    ./configure "${myconf[@]}"
#    make -j$(nproc)
#    make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --enable-libmodplug
}

ffbuild_unconfigure() {
    echo --disable-libmodplug
}
