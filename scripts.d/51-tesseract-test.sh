#!/bin/bash

SCRIPT_REPO="https://github.com/tesseract-ocr/tesseract.git"
SCRIPT_COMMIT="c1d663761b93d2d7d3aae6b7d47dc07cfa6d84e1"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing

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

./autogen.sh
./configure CXXFLAGS="-Wall -O2" --disable-debug --disable-shared --with-tensorflow -fno-math-errno
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
