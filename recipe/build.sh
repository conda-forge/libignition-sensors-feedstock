#!/bin/sh

mkdir build
cd build

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=TRUE \
      -DCMAKE_MACOSX_RPATH=FALSE \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_TESTING=ON \
      ..

cmake --build . --config Release
cmake --build . --config Release --target install

if [[ ${HOST} =~ .*darwin.* ]]; then
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
    ctest -VV --output-on-failure -C Release -E "UNIT_Lidar_TEST|UNIT_Camera_TEST|INTEGRATION"
fi
else
    ctest -VV --output-on-failure -C Release
fi
