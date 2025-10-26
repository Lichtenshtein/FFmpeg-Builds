#!/bin/bash

SCRIPT_REPO="https://github.com/drowe67/codec2.git"
SCRIPT_COMMIT="96e8a19c2487fd83bd981ce570f257aef42618f9"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing
# 56 14.53 [ 20%] Performing install step for 'codec2_native'
# 56 14.55 Error copying file "/50-codec2-test/build/src/codec2_native/src/generate_codebook" to "/50-codec2-test/build/src".
# 56 14.55 make[2]: *** [src/CMakeFiles/codec2_native.dir/build.make:103: src/codec2_native-prefix/src/codec2_native-stamp/codec2_native-install] Error 1
# 56 14.55 make[1]: *** [CMakeFiles/Makefile2:229: src/CMakeFiles/codec2_native.dir/all] Error 2
# 56 14.55 make[1]: *** Waiting for unfinished jobs....
# 56 14.57 [ 21%] Building C object src/CMakeFiles/fdmdv_put_test_bits.dir/kiss_fftr.c.obj
# 56 14.66 [ 21%] Built target framer
# 56 14.87 /50-codec2-test/src/deframer.c: In function 'main':
# 56 14.87 /50-codec2-test/src/deframer.c:156:45: warning: 'best_location' may be used uninitialized [-Wmaybe-uninitialized]
# 56 14.87   156 |           errors += twoframes[best_location + u] ^ uw[u];
# 56 14.87       |                               ~~~~~~~~~~~~~~^~~
# 56 14.87 /50-codec2-test/src/deframer.c:111:7: note: 'best_location' was declared here
# 56 14.87   111 |   int best_location, errors;
# 56 14.87       |       ^~~~~~~~~~~~~
# 56 15.11 [ 21%] Linking C executable deframer.exe
# 56 15.31 [ 21%] Built target deframer
# 56 16.04 [ 21%] Linking C executable fdmdv_put_test_bits.exe
# 56 16.18 [ 21%] Built target fdmdv_put_test_bits
# 56 16.18 make: *** [Makefile:156: all] Error 2
# 56 ERROR: process "/bin/sh -c run_stage /stage.sh" did not complete successfully: exit code: 2

ffbuild_dockerbuild() {

    mkdir build
    cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=NO ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
    
}

ffbuild_configure() {
    echo --enable-libcodec2
}

ffbuild_unconfigure() {
    echo --disable-libcodec2
}
