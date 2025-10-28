#!/bin/bash

SCRIPT_REPO="https://github.com/lensfun/lensfun.git"
SCRIPT_COMMIT="ef7a8498b4b010cd927cf773a710489dcbb5b312"

# #229 0.875 -- Looking for include file endian.h - not found
# #229 0.882 -- Found PkgConfig: /usr/bin/pkg-config (found version "1.8.1") 
# #229 0.883 -- Checking for one of the modules 'glib-2.0'
# #229 0.899 CMake Error at cmake/modules/FindGLIB2.cmake:69 (MESSAGE):
# #229 0.899   Could not find glib2
# #229 0.899 Call Stack (most recent call first):
# #229 0.899   CMakeLists.txt:116 (FIND_PACKAGE)

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

#    apt-get install -y libgtk-3-dev
#    apt-get install -y libglib2.0-dev

# dpkg -L libglib2.0-dev
# ldconfig -p | grep libglib
# ldconfig -p | grep glib

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
    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DGLIB2_ROOT=/lib/x86_64-linux-gnu -DCMAKE_BUILD_TYPE=Release -DINSTALL_HELPER_SCRIPTS=off -DBUILD_TESTS=OFF -DBUILD_DOC=OFF -DBUILD_FOR_SSE2=ON -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_STATIC=on -DBUILD_SHARED_LIBS=NO ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --enable-liblensfun
}

ffbuild_unconfigure() {
    echo --disable-liblensfun
}
