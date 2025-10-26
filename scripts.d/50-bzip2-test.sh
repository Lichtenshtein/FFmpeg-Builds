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
# right. fuck me.
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
