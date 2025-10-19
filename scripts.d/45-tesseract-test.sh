#!/bin/bash

SCRIPT_REPO="https://github.com/tesseract-ocr/tesseract.git"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return 0
}

# i have no idea what i'm doing

ffbuild_dockerbuild() {

apt-get install -y autoconf automake build-essential ca-certificates cmake \
fswebcam g++ git gpsd gpsd-clients libarchive-dev libcairo2-dev libcurl4-openssl-dev \
libgif-dev libicu-dev libjpeg8-dev libleptonica-dev liblog4cplus-dev libopenjp2-7-dev \
libpango1.0-dev libpng-dev libprotoc-dev libtiff5-dev libtool libwebp-dev \
libwebpdemux2 m4 make mpg321 pkg-config python3-opencv software-properties-common unzip wget zlib1g-dev

apt-get install --no-install-recommends asciidoc docbook-xsl xsltproc

mkdir -p "$FFBUILD_DESTPREFIX"/leptonica/lib
INSTALL_DIR="$FFBUILD_DESTPREFIX"/leptonica/build

pip install --upgrade pip
pip install tensorflow
python3 -c "import tensorflow as tf; print(tf.reduce_sum(tf.random.normal([1000, 1000])))"

git clone --depth 1 https://github.com/zlib-ng/zlib-ng.git
cd zlib-ng
cmake -Bbuild -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_SHARED_LIBS=OFF -DZLIB_COMPAT=ON -DZLIB_ENABLE_TESTS=OFF -DINSTALL_UTILS=OFF
cmake --build build --config Release --target install
cd ..

curl -sSL https://download.sourceforge.net/libpng/lpng1640.zip -o lpng1640.zip
unzip -qq lpng1640.zip
cd lpng1640
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DPNG_TESTS=OFF -DPNG_SHARED=OFF
cmake --build build --config Release --target install
cd ..

curl -sSL https://www.nasm.us/pub/nasm/releasebuilds/3.01rc9/nasm-3.01rc9.zip -o ./nasm/nasm-3.01rc9.zip
cd nasm
unzip -qq nasm-3.01rc9.zip
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DPNG_TESTS=OFF -DPNG_SHARED=OFF
cmake --build build --config Release --target install
cd ..

git clone --depth 1 https://github.com/libjpeg-turbo/libjpeg-turbo.git
cd libjpeg-turbo
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DWITH_TURBOJPEG=OFF
cmake --build build --config Release --target install
cd ..

git clone --depth 1 https://gitlab.com/libtiff/libtiff.git
cd libtiff
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -Dtiff-tools=OFF -Dtiff-tests=OFF -Dtiff-contrib=OFF -Dtiff-docs=OFF
cmake --build build --config Release --target install
cd ..

git clone --depth 1 https://github.com/zdenop/jbigkit.git
cd jbigkit
cmake -Bbuild -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_PROGRAMS=OFF -DBUILD_TOOLS=OFF -DCMAKE_WARN_DEPRECATED=OFF
cmake --build build --config Release --target install
cd ..

git clone --depth 1 https://github.com/facebook/zstd.git
cd zstd/build/cmake
cmake -Bbuild -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" 
cmake --build build --config Release --target install
cd ../../..

git clone --depth 1 https://github.com/tukaani-project/xz.git
cd xz
cmake -Bbuild -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON
cmake --build build --config Release --target install
cd ..

git clone --depth 1 https://github.com/xbmc/giflib.git
cd giflib
cmake -Bbuild -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" 
cmake --build build --config Release --target install
cd ..

git clone --depth 1 https://chromium.googlesource.com/webm/libwebp
cd libwebp
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DWEBP_BUILD_WEBP_JS=OFF -DWEBP_BUILD_ANIM_UTILS=OFF -DWEBP_BUILD_CWEBP=OFF -DWEBP_BUILD_DWEBP=OFF -DWEBP_BUILD_GIF2WEBP=OFF -DWEBP_BUILD_IMG2WEBP=OFF -DWEBP_BUILD_VWEBP=OFF -DWEBP_BUILD_WEBPMUX=OFF -DWEBP_BUILD_EXTRAS=OFF -DWEBP_BUILD_WEBP_JS=OFF
cmake --build build --config Release --target install
cd ..

git clone --depth 1 https://github.com/uclouvain/openjpeg.git
cd openjpeg
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" 
cmake --build build --config Release --target install
cd ..

git clone --depth=1 https://github.com/DanBloomberg/leptonica.git
cd leptonica
cmake -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$INSTALL_DIR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" -DSW_BUILD=OFF -DBUILD_PROG=OFF -DBUILD_SHARED_LIBS=ON -DBUILD_PROG=ON
cmake --build build --config Release --target install
cd ..

git clone --depth=1 https://github.com/tesseract-ocr/tesseract.git
git clone https://github.com/tesseract-ocr/tessdata.git tesseract-ocr.tessdata
cd tesseract
./autogen.sh
./configure CXXFLAGS="-Wall -O2" --disable-debug --disable-shared --with-tensorflow -fno-math-errno
make -j$(nproc)
make ScrollView.jar
make install DESTDIR="$FFBUILD_DESTDIR"
make install-langs DESTDIR="$FFBUILD_DESTDIR"
ldconfig
make training -j$(nproc)
make install training-install DESTDIR="$FFBUILD_DESTDIR"
cd ..

export TESSDATA_PREFIX="$FFBUILD_DESTDIR"/tessdata
mv tessdata $TESSDATA_PREFIX
  
}

ffbuild_configure() {
    echo --enable-libtesseract
}

ffbuild_unconfigure() {
    echo --disable-libtesseract
}
