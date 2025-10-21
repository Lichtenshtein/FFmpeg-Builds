#!/bin/bash

SCRIPT_REPO="https://github.com/chiefjazzdiewltr/libcaca.git"
SCRIPT_COMMIT="cc351000e1e2a7a78eefc9523599565ebbfda9b2"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {
    ./bootstrap

# git clone --depth=1 https://github.com/chiefjazzdiewltr/libcaca.git

     local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --host="$FFBUILD_TOOLCHAIN"
        --disable-shared
        --enable-static
		--enable-slang
#		--enable-conio
        --enable-ncurses
		--disable-imlib2
		--enable-gl
		--enable-win32
		--enable-network
        --disable-extra-programs
        --disable-csharp 
        --disable-java 
        --disable-cxx 
        --disable-python 
        --disable-ruby 
        --disable-doc 
        --disable-cocoa 
#        --disable-ncurses
    )

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
  
}

ffbuild_configure() {
    echo --enable-libcaca
}

ffbuild_unconfigure() {
    echo --disable-libcaca
}
