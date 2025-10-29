#!/bin/bash

SCRIPT_REPO="https://github.com/lensfun/lensfun.git"
SCRIPT_COMMIT="9b46201746f466614efe573cbc5c3d292dd5633d"

# SCRIPT_REPO="https://github.com/Lichtenshtein/lensfun.git"
# SCRIPT_COMMIT="60b39ece3464ba6a730e5e7f5f8221e89c9a72c9"

#229 4.086 make[2]: *** [libs/regex/CMakeFiles/tre_regex.dir/build.make:107: libs/regex/CMakeFiles/tre_regex.dir/regexec.c.obj] Error 1
#229 4.090 make[2]: *** [libs/regex/CMakeFiles/tre_regex.dir/build.make:77: libs/regex/CMakeFiles/tre_regex.dir/regcomp.c.obj] Error 1
#229 4.090 make[1]: *** [CMakeFiles/Makefile2:149: libs/regex/CMakeFiles/tre_regex.dir/all] Error 2
#229 4.090 make[1]: *** Waiting for unfinished jobs....
#229 4.167 running build
#229 4.168 running build_py
#229 4.170 creating build
#229 4.170 creating build/lib
#229 4.171 creating build/lib/lensfun
#229 4.171 copying /51-lensfun-test/build/apps/lensfun/__init__.py -> build/lib/lensfun
#229 4.202 [ 13%] Built target python-package
#229 4.203 make: *** [Makefile:156: all] Error 2

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

#    apt-get install -y libgtk-3-dev
#    apt-get install -y libglib2.0-dev libxml2-utils python3-dev

apt-get install -y libpng-dev libsystre 

# stupid blind fuck can't find glib
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

#    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"
    export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/x86_64-linux-gnu/glib-2.0:/usr/include/glib-2.0:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/glib-2.0/include:$PKG_CONFIG_PATH"
    
    mkdir build
    cd build
    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DINSTALL_HELPER_SCRIPTS=off -DBUILD_TESTS=OFF -DBUILD_DOC=OFF -DBUILD_FOR_SSE2=ON -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_STATIC=on -DBUILD_SHARED_LIBS=NO ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --enable-liblensfun
}

ffbuild_unconfigure() {
    echo --disable-liblensfun
}
