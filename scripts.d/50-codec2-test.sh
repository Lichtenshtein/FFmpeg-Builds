#!/bin/bash

# SCRIPT_REPO="https://github.com/drowe67/codec2.git"
# SCRIPT_COMMIT="96e8a19c2487fd83bd981ce570f257aef42618f9"

# fork repo 1
SCRIPT_REPO="https://github.com/zups/codec2.git"
SCRIPT_COMMIT="371c82ae557f1b033cf4b625be435bb4b88ef70b"
#
# 1.086 CMake Error at CMakeLists.txt:29 (zephyr_get_include_directories_for_lang_as_string):
# 1.086   Unknown CMake command "zephyr_get_include_directories_for_lang_as_string".

# fork repo 2
# SCRIPT_REPO="https://github.com/rhythmcache/codec2.git"
# SCRIPT_COMMIT="6e0a0e09c065aa5401eb9c30d724240fffe890f1"
#
# #56 3.738 CMake Error at src/CMakeLists.txt:72 (message):
# #56 3.738   Cross-compiling requires
# #56 3.738   -DGENERATE_CODEBOOK=<path-to-native-generate_codebook>
#
# #55 3.723 make[2]: *** No rule to make target 'src/codec2_native/src/generate_codebook', needed by 'src/codebooknewamp2_energy.c'.  Stop.
# #55 3.725 make[1]: *** [CMakeFiles/Makefile2:226: src/CMakeFiles/codec2.dir/all] Error 2
# #55 3.725 make[1]: *** Waiting for unfinished jobs....

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
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

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DGENERATE_CODEBOOK="$FFBUILD_PREFIX/build/src/codec2_native/src/generate_codebook" -DCMAKE_BUILD_TYPE=Release -DUNITTEST=FALSE -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=NO ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"
    
}

ffbuild_configure() {
    echo --enable-libcodec2
}

ffbuild_unconfigure() {
    echo --disable-libcodec2
}
