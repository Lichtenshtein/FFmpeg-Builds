#!/bin/bash

SCRIPT_REPO="https://gitlab.freedesktop.org/glvnd/libglvnd.git"
SCRIPT_COMMIT="c046a760d845416e98ac4128757b2b356c47fdaa"

ffbuild_enabled() {
    [[ $TARGET != linux* ]] && return 1
    return 0
}

ffbuild_dockerbuild() {
    set -e

    mkdir -p build && cd build

    local myconf=(
        -Db_lto=$([ "${USE_LTO}" == "1" ] && echo true || echo false)
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=$([ "${PREFER_SHARED}" == "1" ] && echo shared || echo static)
        -Dc_std=gnu17
        -Dcpp_std=gnu++20
        -Dasm=enabled
        -Dx11=enabled
        -Degl=true
        -Dglx=enabled
        -Dgles1=true
        -Dgles2=true
        -Dheaders=true
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --cross-file="$FFBUILD_MESON_CROSS"
        )
    fi

    meson setup "${myconf[@]}" .. \
        -Dc_args="$CFLAGS $CPPFLAGS ${USELTO}${USELTO_C}" \
        -Dcpp_args="$CXXFLAGS $CPPFLAGS ${USELTO}${USELTO_C}" \
        -Dc_link_args="$LDFLAGS ${USELTO}${USELTO_L}" \
        -Dcpp_link_args="$LDFLAGS ${USELTO}${USELTO_L}" || return 1

    ninja -j"$(nproc)" $NINJA_V || return 1
    DESTDIR="$FFBUILD_DESTDIR" ninja install || return 1

    for LIB in libGL.so.1 libGLX.so.0 libOpenGL.so.0 libEGL.so.1 libGLESv1_CM.so.1 libGLESv2.so.2; do
        gen-implib "$FFBUILD_DESTPREFIX"/lib/{"${LIB}","${LIB%%.*}.a"}
        rm "$FFBUILD_DESTPREFIX"/lib/"${LIB%%.*}".so*
    done

    for LIB in gl glx opengl egl glesv1_cm glesv2; do
        echo "Libs: -ldl" >> "$FFBUILD_DESTPREFIX"/lib/pkgconfig/"${LIB}".pc
    done
}
