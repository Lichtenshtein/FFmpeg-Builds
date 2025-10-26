#!/bin/bash
set -xe
shopt -s globstar
cd "$(dirname "$0")"
source util/vars.sh

source "variants/${TARGET}-${VARIANT}.sh"

for addin in ${ADDINS[*]}; do
    source "addins/${addin}.sh"
done

if docker info -f "{{println .SecurityOptions}}" | grep rootless >/dev/null 2>&1; then
    UIDARGS=()
else
    UIDARGS=( -u "$(id -u):$(id -g)" )
fi

rm -rf ffbuild
mkdir ffbuild

FFMPEG_REPO="${FFMPEG_REPO:-https://github.com/Lichtenshtein/FFmpeg.git}"
FFMPEG_REPO="${FFMPEG_REPO_OVERRIDE:-$FFMPEG_REPO}"
GIT_BRANCH="${GIT_BRANCH:-master}"
GIT_BRANCH="${GIT_BRANCH_OVERRIDE:-$GIT_BRANCH}"

BUILD_SCRIPT="$(mktemp)"
trap "rm -f -- '$BUILD_SCRIPT'" EXIT

cat <<EOF >"$BUILD_SCRIPT"
    set -xe
    cd /ffbuild
    rm -rf ffmpeg prefix

    git clone --filter=blob:none --branch='$GIT_BRANCH' '$FFMPEG_REPO' ffmpeg
    cd ffmpeg
    chmod +x configure

    BRANCH_NAME=\$(basename '$GIT_BRANCH')

    if [ -f "/patches/ffmpeg/\$BRANCH_NAME.patch" ]; then
        git apply "/patches/ffmpeg/\$BRANCH_NAME.patch"
    fi

    ./configure --prefix=/ffbuild/prefix --pkg-config-flags="--static" \$FFBUILD_TARGET_FLAGS \$FF_CONFIGURE \
        --enable-decoder=h264,hevc,av1 \
        --enable-filter=vpp_amf --enable-filter=sr_amf \
#        --enable-libtesseract  \
        --enable-bzlib \
        --enable-cuda --enable-libnpp --enable-cuvid --enable-nvdec --enable-nvenc --enable-cuda-nvcc \
        --enable-d3d11va --enable-dxva2 --enable-d3d12va \
        --enable-hardcoded-tables \
        --enable-gray \
        --custom-allocator=jemalloc
#        --enable-libcaca \
#        --enable-liblensfun \
#        --enable-libcodec2 \
#        --enable-vapoursynth \
        --enable-opengl \
        --enable-libmodplug \
        --enable-indev=lavfi \
        --enable-filter=eq \
        --enable-filter=scale \
        --enable-avformat --enable-avcodec --enable-avutil --enable-swresample \
        --extra-cflags="\$FF_CFLAGS" --extra-cxxflags="\$FF_CXXFLAGS" --extra-libs="\$FF_LIBS" \
        --extra-ldflags="\$FF_LDFLAGS" --extra-ldexeflags="\$FF_LDEXEFLAGS" \
        --cc="\$CC" --cxx="\$CXX" --ar="\$AR" --ranlib="\$RANLIB" --nm="\$NM" \
        --extra-version="VVCEasy"
    make -j\$(nproc) V=1
    make install install-doc
EOF

[[ -t 1 ]] && TTY_ARG="-t" || TTY_ARG=""

PATCHES_MOUNT=""
if [ -d "patches/ffmpeg" ]; then
    PATCHES_MOUNT="-v $PWD/patches:/patches"
fi

# docker run --rm -i $TTY_ARG "${UIDARGS[@]}" -v "$PWD/ffbuild":/ffbuild $PATCHES_MOUNT -v "$BUILD_SCRIPT":/build.sh "$IMAGE" bash /build.sh
docker run --rm -i $TTY_ARG "${UIDARGS[@]}" -v $PWD/ffbuild:/ffbuild -v "$BUILD_SCRIPT":/build.sh -v $PWD/patches/:/ffbuild/patches  "$IMAGE" bash /build.sh

if [[ -n "$FFBUILD_OUTPUT_DIR" ]]; then
    mkdir -p "$FFBUILD_OUTPUT_DIR"
    package_variant ffbuild/prefix "$FFBUILD_OUTPUT_DIR"
    [[ -n "$LICENSE_FILE" ]] && cp "ffbuild/ffmpeg/$LICENSE_FILE" "$FFBUILD_OUTPUT_DIR/LICENSE.txt"
    rm -rf ffbuild
    exit 0
fi

mkdir -p artifacts
ARTIFACTS_PATH="$PWD/artifacts"
BUILD_NAME="ffmpeg_vvceasy-$(./ffbuild/ffmpeg/ffbuild/version.sh ffbuild/ffmpeg)-${TARGET}-${VARIANT}${ADDINS_STR:+-}${ADDINS_STR}"

mkdir -p "ffbuild/pkgroot/$BUILD_NAME"
package_variant ffbuild/prefix "ffbuild/pkgroot/$BUILD_NAME"

[[ -n "$LICENSE_FILE" ]] && cp "ffbuild/ffmpeg/$LICENSE_FILE" "ffbuild/pkgroot/$BUILD_NAME/LICENSE.txt"

cd ffbuild/pkgroot

for bin in ffmpeg ffprobe ffplay; do
    [[ -f ./$BUILD_NAME/bin/$bin.exe ]] && mv ./$BUILD_NAME/bin/$bin.exe ./$BUILD_NAME/bin/${bin}_vvceasy.exe
    [[ -f ./$BUILD_NAME/bin/$bin ]] && mv ./$BUILD_NAME/bin/$bin ./$BUILD_NAME/bin/${bin}_vvceasy
done

if [[ "${TARGET}" == win* ]]; then
    OUTPUT_FNAME="${BUILD_NAME}.7z"
    docker run --rm -i $TTY_ARG "${UIDARGS[@]}" -v "${ARTIFACTS_PATH}":/out -v "${PWD}/${BUILD_NAME}":"/${BUILD_NAME}" -w / "$IMAGE" 7z a -mx -stl "/out/${OUTPUT_FNAME}" "$BUILD_NAME"
else
    OUTPUT_FNAME="${BUILD_NAME}.tar.xz"
    docker run --rm -i $TTY_ARG "${UIDARGS[@]}" -v "${ARTIFACTS_PATH}":/out -v "${PWD}/${BUILD_NAME}":"/${BUILD_NAME}" -w / "$IMAGE" tar cJf "/out/${OUTPUT_FNAME}" "$BUILD_NAME"
fi
cd -

rm -rf ffbuild

if [[ -n "$GITHUB_ACTIONS" ]]; then
    echo "build_name=${BUILD_NAME}" >> "$GITHUB_OUTPUT"
    echo "${OUTPUT_FNAME}" > "${ARTIFACTS_PATH}/${TARGET}-${VARIANT}${ADDINS_STR:+-}${ADDINS_STR}.txt"
fi
