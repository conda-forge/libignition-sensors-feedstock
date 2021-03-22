#!/bin/sh

mkdir build
cd build

# Download lddx tool for macOS debugging 
curl -O https://github.com/traversaro/robotology-superbuild/releases/download/2020_11_test_4/lddx

./lddx -h
./lddx ${PREFIX}/lib/libOgreMain.dylib
./lddx ${PREFIX}/lib/libignition-rendering4.dylib

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_TESTING=ON \
      ..

cmake --build . --config Release
cmake --build . --config Release --target install

# Debug
otool -L ${PREFIX}/lib/libignition-sensors4.dylib
otool -L ${PREFIX}/lib/libOgreMain.dylib
otool -L ${PREFIX}/lib/libignition-sensors4-lidar.dylib

./lddx ${PREFIX}/lib/libignition-sensors4.dylib
./lddx ${PREFIX}/lib/libignition-sensors4-lidar.dylib

ctest --output-on-failure -C Release
