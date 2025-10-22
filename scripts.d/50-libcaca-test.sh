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

# apt-get install -y libx11 xorgproto libncurses5-dev
apt-get install -y mesa-common-dev libgl-dev libglu-dev freeglut3-dev pkg-config libtool
# git clone --depth=1 https://github.com/chiefjazzdiewltr/libcaca.git

	mkdir xorgproto
    cd xorgproto
    git clone https://gitlab.freedesktop.org/xorg/proto/xorgproto.git
    cd xorgproto
    ./autogen.sh
    ./configure --prefix=="$FFBUILD_PREFIX" --host="$FFBUILD_TOOLCHAIN" --disable-shared --enable-static
	make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
    cd ../..

	mkdir libX11
    cd libX11
	git clone https://gitlab.freedesktop.org/xorg/lib/libX11.git
    cd libX11
	./autogen.sh
	./configure --prefix="$FFBUILD_PREFIX" --host="$FFBUILD_TOOLCHAIN" --disable-shared --enable-static
	make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
	cd ../..
	
    mkdir freeglut
    cd freeglut
	git clone https://github.com/freeglut/freeglut.git
    cd freeglut
    cmake -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" --host="$FFBUILD_TOOLCHAIN" --disable-shared --enable-static
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
    cd ../..

     local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --host="$FFBUILD_TOOLCHAIN"
        --disable-shared
        --enable-static
        --enable-ncurses
		--enable-imlib2
		--enable-gl
		--enable-freeglu
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
