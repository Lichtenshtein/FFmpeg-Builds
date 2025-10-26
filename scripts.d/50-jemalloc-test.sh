#!/bin/bash

SCRIPT_REPO="https://github.com/facebook/jemalloc.git"
SCRIPT_COMMIT="6ced85a8e5d73e882aa999a1fbc95b9312461804"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}


ffbuild_dockerbuild() {

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --disable-initial-exec-tls
        --with-lg-quantum=3
        --enable-autogen
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"

    ./autogen.sh "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --custom-allocator=jemalloc
}
