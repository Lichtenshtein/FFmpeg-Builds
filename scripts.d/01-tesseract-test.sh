#!/bin/bash

SCRIPT_REPO="https://github.com/tesseract-ocr/tesseract.git"
SCRIPT_COMMIT="c1d663761b93d2d7d3aae6b7d47dc07cfa6d84e1"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

# Build FFmpeg #115 attempt
#10 49.52 make[1]: Entering directory '/01-tesseract-test'
#10 49.55   CXX      src/arch/libtesseract_native_la-dotproduct.lo
#10 49.55   CXX      src/arch/libtesseract_avx_la-dotproductavx.lo
#10 49.56   CXX      src/arch/libtesseract_avx2_la-intsimdmatrixavx2.lo
#10 49.56   CXX      src/arch/libtesseract_avx512_la-dotproductavx512.lo
#10 49.64 x86_64-w64-mingw32-g++: warning: /usr/include/leptonica:: linker input file unused because linking not done
#10 49.64 x86_64-w64-mingw32-g++: error: /usr/include/leptonica:: linker input file not found: No such file or directory
#10 49.64 make[1]: *** [Makefile:6426: src/arch/libtesseract_native_la-dotproduct.lo] Error 1
#10 49.64 make[1]: *** Waiting for unfinished jobs....
#10 50.41 x86_64-w64-mingw32-g++: warning: /usr/include/leptonica:: linker input file unused because linking not done
#10 50.41 x86_64-w64-mingw32-g++: error: /usr/include/leptonica:: linker input file not found: No such file or directory
#10 50.41 make[1]: *** [Makefile:6195: src/arch/libtesseract_avx512_la-dotproductavx512.lo] Error 1
#10 50.44 x86_64-w64-mingw32-g++: warning: /usr/include/leptonica:: linker input file unused because linking not done
#10 50.44 x86_64-w64-mingw32-g++: error: /usr/include/leptonica:: linker input file not found: No such file or directory
#10 50.45 make[1]: *** [Makefile:6181: src/arch/libtesseract_avx_la-dotproductavx.lo] Error 1
#10 50.47 x86_64-w64-mingw32-g++: warning: /usr/include/leptonica:: linker input file unused because linking not done
#10 50.47 x86_64-w64-mingw32-g++: error: /usr/include/leptonica:: linker input file not found: No such file or directory
#10 50.47 make[1]: *** [Makefile:6188: src/arch/libtesseract_avx2_la-intsimdmatrixavx2.lo] Error 1
#10 50.47 make[1]: Leaving directory '/01-tesseract-test'
#10 50.47 make: *** [Makefile:7990: all-recursive] Error 1
#10 ERROR: process "/bin/sh -c run_stage /stage.sh" did not complete successfully: exit code: 2

ffbuild_dockerbuild() {

# main
apt-get install -y libleptonica-dev \
libpng-dev \
libjpeg8-dev \
libtiff5-dev \
libwebpdemux2 libwebp-dev \
libopenjp2-7-dev \
libgif-dev \
libarchive-dev libcurl4-openssl-dev

# fswebcam gpsd gpsd-clients libarchive-dev libcurl4-openssl-dev \
# libgif-dev libjpeg8-dev  liblog4cplus-dev libopenjp2-7-dev \
# libpng-dev  libtiff5-dev libwebp-dev \
# libwebpdemux2 mpg321 pkg-config python3-opencv software-properties-common

# tensflow
apt-get install -y libprotoc-dev
python3 -m venv tensflow
source tensflow/bin/activate    
pip install tensorflow


export TESSDATA_PREFIX=".\tessdata"
# export TESSDATA_PREFIX="./tessdata

# costraited 'release build' flags
# --disable-openmp --disable-shared 'CXXFLAGS=-g -O2 -fno-math-errno -Wall -Wextra -Wpedantic'

dpkg -L libleptonica-dev
pkg-config --variable pc_path pkg-config
find / -name "features.h" 2>/dev/null
find / -name "archive.h" 2>/dev/null

export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/usr/include/leptonica"
export C_INCLUDE_PATH="$C_INCLUDE_PATH:/usr/include/leptonica"
# export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include -I$FFBUILD_PREFIX/include/x86_64-linux-gnu -I/usr/include/x86_64-linux-gnu"
export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"
export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"

export LEPTONICA_CFLAGS="/usr/include/leptonica:$LEPTONICA_CFLAGS"
export LEPTONICA_LIBS="/usr/lib/x86_64-linux-gnu:$LEPTONICA_LIBS"

./autogen.sh
./configure CXXFLAGS="-Wall -O2" --disable-debug --disable-shared --with-tensorflow --host="$FFBUILD_TOOLCHAIN" --prefix="$FFBUILD_PREFIX"
make -j$(nproc)
# make ScrollView.jar
make install DESTDIR="$FFBUILD_DESTDIR"
# make install-langs DESTDIR="$FFBUILD_DESTDIR"
ldconfig

}

ffbuild_configure() {
    echo --enable-libtesseract
}

ffbuild_unconfigure() {
    echo --disable-libtesseract
}
