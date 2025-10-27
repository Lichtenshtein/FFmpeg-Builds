#!/bin/bash

SCRIPT_REPO="https://github.com/ImageMagick/bzip2.git"
SCRIPT_COMMIT="abffe764f875f71d051efb19d4c83139375f82d7"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# 7.727 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0xd39): undefined reference to `__imp_BZ2_bzReadClose'
# 7.727 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0xf37): undefined reference to `__imp_BZ2_bzReadOpen'
# 7.727 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0xf8d): undefined reference to `__imp_BZ2_bzRead'
# 7.727 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0xfdd): undefined reference to `__imp_BZ2_bzReadGetUnused'
# 7.727 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0x105b): undefined reference to `__imp_BZ2_bzReadClose'
# 7.727 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0x1132): undefined reference to `__imp_BZ2_bzReadClose'
# 7.727 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0x32d0): undefined reference to `__imp_BZ2_bzlibVersion'
# 7.728 /opt/ct-ng/lib/gcc/x86_64-w64-mingw32/13.2.0/../../../../x86_64-w64-mingw32/bin/ld: bzip2.o:bzip2.c:(.text+0x3316): undefined reference to `__imp_BZ2_bzlibVersion'
# 7.750 collect2: error: ld returned 1 exit status
# 7.752 make: *** [Makefile:40: bzip2] Error 1
#
# > Important note for people upgrading .so's from 0.9.0/0.9.5 to version
# 1.0.X.  All the functions in the library have been renamed, from (eg)
# bzCompress to BZ2_bzCompress, to avoid namespace pollution.
# Unfortunately this means that the libbz2.so created by
# Makefile-libbz2_so will not work with any program which used an older
# version of the library.  I do encourage library clients to make the
# effort to upgrade to use version 1.0, since it is both faster and more
# robust than previous versions.
#
# why the fuck.

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
