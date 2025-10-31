#!/bin/bash

SCRIPT_REPO="https://github.com/vapoursynth/vapoursynth.git"
SCRIPT_COMMIT="e46204429041e95a881b61eedddd46c08f9a307c"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return 1
    return -1
}

# i have no idea what i'm doing

# ERROR. ERROR. ERROR.
# Build FFmpeg #93 attempt
#229 45.74 + make -j4
#229 45.76   CXX      src/core/libvapoursynth_la-lutfilters.lo
#229 45.76   CXX      src/core/libvapoursynth_la-memoryuse.lo
#229 45.76   CXX      src/core/libvapoursynth_la-mergefilters.lo
#229 45.76   CXX      src/core/libvapoursynth_la-reorderfilters.lo
#229 46.79   CXX      src/core/libvapoursynth_la-settings.lo
#229 48.06   CXX      src/core/libvapoursynth_la-simplefilters.lo
#229 48.28   CXX      src/core/libvapoursynth_la-textfilter.lo
#229 49.38 In file included from src/core/settings.cpp:8:
#229 49.38 src/core/vscore.h: In member function 'const VSFilterDependency* VSNode::getDependency(int) const':
#229 49.38 src/core/vscore.h:885:32: warning: comparison of integer expressions of different signedness: 'int' and 'std::vector<VSFilterDependency>::size_type' {aka 'long long unsigned int'} [-Wsign-compare]
#229 49.38   885 |         if (index < 0 || index >= dependencies.size())
#229 49.38       |                          ~~~~~~^~~~~~~~~~~~~~~~~~~~~~
#229 49.72   CXX      src/core/libvapoursynth_la-vsapi.lo
#229 50.05   CXX      src/core/libvapoursynth_la-vscore.lo
#229 50.91   CXX      src/core/libvapoursynth_la-vslog.lo
#229 51.73   CXX      src/core/libvapoursynth_la-vsresize.lo
#229 52.35 In file included from src/core/vsapi.cpp:21:
#229 52.35 src/core/vscore.h: In member function 'const VSFilterDependency* VSNode::getDependency(int) const':
#229 52.35 src/core/vscore.h:885:32: warning: comparison of integer expressions of different signedness: 'int' and 'std::vector<VSFilterDependency>::size_type' {aka 'long long unsigned int'} [-Wsign-compare]
#229 52.35   885 |         if (index < 0 || index >= dependencies.size())
#229 52.35       |                          ~~~~~~^~~~~~~~~~~~~~~~~~~~~~
#229 53.66 In file included from src/core/vscore.cpp:21:
#229 53.66 src/core/vscore.h: In member function 'const VSFilterDependency* VSNode::getDependency(int) const':
#229 53.66 src/core/vscore.h:885:32: warning: comparison of integer expressions of different signedness: 'int' and 'std::vector<VSFilterDependency>::size_type' {aka 'long long unsigned int'} [-Wsign-compare]
#229 53.66   885 |         if (index < 0 || index >= dependencies.size())
#229 53.66       |                          ~~~~~~^~~~~~~~~~~~~~~~~~~~~~
#229 54.49 src/core/vscore.cpp: In constructor 'VSPlugin::VSPlugin(const std::filesystem::__cxx11::path&, const std::string&, const std::string&, bool, VSCore*)':
#229 54.49 src/core/vscore.cpp:2099:31: warning: cast between incompatible function types from 'FARPROC' {aka 'long long int (*)()'} to 'VSInitPlugin' {aka 'void (*)(VSPlugin*, const VSPLUGINAPI*)'} [-Wcast-function-type]
#229 54.49  2099 |     VSInitPlugin pluginInit = reinterpret_cast<VSInitPlugin>(GetProcAddress(libHandle, "VapourSynthPluginInit2"));
#229 54.49       |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#229 54.49 src/core/vscore.cpp:2102:22: warning: cast between incompatible function types from 'FARPROC' {aka 'long long int (*)()'} to 'VSInitPlugin' {aka 'void (*)(VSPlugin*, const VSPLUGINAPI*)'} [-Wcast-function-type]
#229 54.49  2102 |         pluginInit = reinterpret_cast<VSInitPlugin>(GetProcAddress(libHandle, "_VapourSynthPluginInit2@8"));
#229 54.49       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#229 54.49 src/core/vscore.cpp:2106:23: warning: cast between incompatible function types from 'FARPROC' {aka 'long long int (*)()'} to 'vs3::VSInitPlugin' {aka 'void (*)(void (*)(const char*, const char*, const char*, int, int, VSPlugin*), void (*)(const char*, const char*, void (*)(const VSMap*, VSMap*, void*, VSCore*, const vs3::VSAPI3*), void*, VSPlugin*), VSPlugin*)'} [-Wcast-function-type]
#229 54.49  2106 |         pluginInit3 = reinterpret_cast<vs3::VSInitPlugin>(GetProcAddress(libHandle, "VapourSynthPluginInit"));
#229 54.49       |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#229 54.49 src/core/vscore.cpp:2109:23: warning: cast between incompatible function types from 'FARPROC' {aka 'long long int (*)()'} to 'vs3::VSInitPlugin' {aka 'void (*)(void (*)(const char*, const char*, const char*, int, int, VSPlugin*), void (*)(const char*, const char*, void (*)(const VSMap*, VSMap*, void*, VSCore*, const vs3::VSAPI3*), void*, VSPlugin*), VSPlugin*)'} [-Wcast-function-type]
#229 54.49  2109 |         pluginInit3 = reinterpret_cast<vs3::VSInitPlugin>(GetProcAddress(libHandle, "_VapourSynthPluginInit@12"));
#229 54.49       |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#229 55.27   CXX      src/core/libvapoursynth_la-vsthreadpool.lo
#229 55.90   CXX      src/core/expr/libvapoursynth_la-jitcompiler_x86.lo
#229 57.13   CYTHON   src/cython/vapoursynth.c
#229 57.64 In file included from src/core/vsthreadpool.cpp:21:
#229 57.64 src/core/vscore.h: In member function 'const VSFilterDependency* VSNode::getDependency(int) const':
#229 57.64 src/core/vscore.h:885:32: warning: comparison of integer expressions of different signedness: 'int' and 'std::vector<VSFilterDependency>::size_type' {aka 'long long unsigned int'} [-Wsign-compare]
#229 57.64   885 |         if (index < 0 || index >= dependencies.size())
#229 57.64       |                          ~~~~~~^~~~~~~~~~~~~~~~~~~~~~
#229 59.10   CXX      src/vspipe/vspipe-vspipe.o
#229 59.31 In file included from src/core/expr/jitcompiler_x86.cpp:28:
#229 59.31 src/core/expr/jitasm.h: In constructor 'jitasm::detail::ResultT<float, 4>::ResultT(float)':
#229 59.31 src/core/expr/jitasm.h:8634:56: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
#229 59.31  8634 |                 ResultT(const float imm) : val_(Imm32(*(uint32*)&imm)) {}
#229 59.31       |                                                        ^~~~~~~~~~~~~
#229 59.31 src/core/expr/jitasm.h: In member function 'void jitasm::detail::ResultT<double, 8>::StoreResult(jitasm::Frontend&, const jitasm::detail::ResultDest&)':
#229 59.31 src/core/expr/jitasm.h:8709:64: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
#229 59.31  8709 |                                 f.mov(f.dword_ptr[f.rsp - 8], *reinterpret_cast<uint32*>(&imm_));
#229 59.31       |                                                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#229 59.74   CXX      src/vspipe/vspipe-printgraph.o
#229 61.26   CXX      src/vspipe/vspipe-vsjson.o
#229 61.91   CXX      src/common/vspipe-wave.o
#229 62.32   CXX      src/vsscript/libvapoursynth_script_la-vsscript.lo
#229 62.41 In file included from /usr/include/python3.12/Python.h:12,
#229 62.41                  from ./include/cython/vapoursynth_api.h:14,
#229 62.41                  from src/vsscript/vsscript.cpp:24:
#229 62.41 /usr/include/python3.12/pyconfig.h:120:3: error: #error unknown multiarch location for pyconfig.h
#229 62.41   120 | # error unknown multiarch location for pyconfig.h
#229 62.41       |   ^~~~~
#229 62.43 In file included from /usr/include/python3.12/pyport.h:4,
#229 62.43                  from /usr/include/python3.12/Python.h:38:
#229 62.43 /usr/include/python3.12/pyconfig.h:120:3: error: #error unknown multiarch location for pyconfig.h
#229 62.43   120 | # error unknown multiarch location for pyconfig.h
#229 62.43       |   ^~~~~
#229 62.46 In file included from /usr/include/python3.12/Python.h:51:
#229 62.46 /usr/include/python3.12/unicodeobject.h:68:2: error: #error Must define SIZEOF_WCHAR_T
#229 62.46    68 | #error Must define SIZEOF_WCHAR_T
#229 62.46       |  ^~~~~
#229 62.52   CXX      src/core/libvapoursynth_la-audiofilters.lo
#229 62.53 src/vsscript/vsscript.cpp:33:10: fatal error: Windows.h: No such file or directory
#229 62.53    33 | #include <Windows.h>
#229 62.53       |          ^~~~~~~~~~~
#229 62.53 compilation terminated.
#229 62.53 make: *** [Makefile:1262: src/vsscript/libvapoursynth_script_la-vsscript.lo] Error 1

# Build FFmpeg #96 attempt
#229 42.86 + ./configure --prefix=/opt/ffbuild --disable-shared --enable-static --host=x86_64-w64-mingw32
#229 42.94 checking for a BSD-compatible install... /usr/bin/install -c
#229 42.95 checking whether build environment is sane... yes
#229 42.96 checking for x86_64-w64-mingw32-strip... x86_64-w64-mingw32-strip
#229 42.96 checking for a race-free mkdir -p... /usr/bin/mkdir -p
#229 42.96 checking for gawk... gawk
#229 42.96 checking whether make sets $(MAKE)... yes
#229 42.97 checking whether make supports nested variables... yes
#229 42.98 checking whether make supports nested variables... (cached) yes
#229 42.98 checking build system type... x86_64-pc-linux-gnu
#229 43.01 checking host system type... x86_64-w64-mingw32
#229 43.02 checking how to print strings... printf
#229 43.02 checking whether make supports the include directive... yes (GNU style)
#229 43.02 checking for x86_64-w64-mingw32-gcc... x86_64-w64-mingw32-gcc
#229 43.05 checking whether the C compiler works... no
#229 43.07 configure: error: in `/51-vapoursynth-test':
#229 43.07 configure: error: C compiler cannot create executables
#229 43.07 See `config.log' for more details

# Build FFmpeg #98 attempt
# same error as in №93. my clue is that C wants python shit from /usr/include/x86_64-linux-gnu/python3.12/
# but digs in /usr/include/python3.12/. don't know how to point it to right location. let's try ln
# python3.12 -c "from sysconfig import get_paths; print(get_paths()['include'])"
# #229 20.33 /usr/include/python3.12

# Build FFmpeg #105 attempt
# can't resolve the headers problem.
# 229 34.91 /usr/include/x86_64-linux-gnu/sys/timeb.h:21:10: fatal error: features.h: No such file or directory

# Build FFmpeg #106 attempt
# i'm giving up, i don't know how to solve this problem...
#229 27.39 make: *** [Makefile:1346: src/core/libvapoursynth_la-lutfilters.lo] Error 1
#229 27.39 make: *** [Makefile:1367: src/core/libvapoursynth_la-reorderfilters.lo] Error 1
#229 27.39 In file included from /opt/ct-ng/x86_64-w64-mingw32/sysroot/mingw/include/pthread.h:64,
#229 27.39                  from /opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/x86_64-w64-mingw32/bits/gthr-default.h:35,
#229 27.39                  from /opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/x86_64-w64-mingw32/bits/gthr.h:148,
#229 27.39                  from /opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/ext/atomicity.h:35,
#229 27.39                  from /opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/bits/shared_ptr_base.h:61,
#229 27.39                  from /opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/bits/shared_ptr.h:53,
#229 27.39                  from /opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/memory:80,
#229 27.39                  from src/core/mergefilters.cpp:23:
#229 27.39 /usr/include/x86_64-linux-gnu/sys/types.h:25:10: fatal error: features.h: No such file or directory
#229 27.39    25 | #include <features.h>
#229 27.39       |          ^~~~~~~~~~~~
#229 27.39 compilation terminated.
#229 27.40 make: *** [Makefile:1360: src/core/libvapoursynth_la-mergefilters.lo] Error 1

ffbuild_dockerbuild() {

apt-get install -y libzimg-dev intltool \
libavutil-dev libavcodec-dev libswscale-dev \
python3-dev

python3.12 -m venv Cython
source Cython/bin/activate    
pip install Cython

# again. lets find python3.12
dpkg -L python3.12
ldconfig -p | grep python3.12
find / -name "python*.pc" 2>/dev/null
find / -name "pyconfig.h" 2>/dev/null
find / -name "features.h" 2>/dev/null
find / -name "archive.h" 2>/dev/null
# python3.12 -c "from sysconfig import get_paths; print(get_paths()['include'])"

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    # why not
#    mv /usr/include/python3.12 /usr/include/python3.12-12
#    mkdir /usr/include/python3.12
#    ln -s /usr/include/x86_64-linux-gnu/python3.12 /usr/include/python3.12

    export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/usr/include/x86_64-linux-gnu/python3.12"
    export C_INCLUDE_PATH="$C_INCLUDE_PATH:/usr/include/x86_64-linux-gnu/python3.12"
    export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/usr/include/x86_64-linux-gnu"
    export C_INCLUDE_PATH="$C_INCLUDE_PATH:/usr/include/x86_64-linux-gnu"
#    export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:/opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/parallel"
#    export C_INCLUDE_PATH="$C_INCLUDE_PATH:/opt/ct-ng/x86_64-w64-mingw32/include/c++/13.2.0/parallel"
    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"
#    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include/x86_64-linux-gnu"
    export PKG_CONFIG_PATH="/usr/include/x86_64-linux-gnu/python3.12:/usr/include/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH"
    
    ./autogen.sh
    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

}

ffbuild_configure() {
    echo --enable-vapoursynth
}

ffbuild_unconfigure() {
    echo --disable-vapoursynth
}
