#!/bin/sh

mkdir build
cd build

# Download lddx tool for macOS debugging 
curl -O -L https://github.com/traversaro/robotology-superbuild/releases/download/2020_11_test_4/lddx
chmod +x ./lddx
./lddx -h

echo "lddx RenderSystem_GL"
./lddx -r -d ${PREFIX}/lib/OGRE/RenderSystem_GL.dylib
echo "lddx Plugin_ParticleFX"
./lddx -r -d ${PREFIX}/lib/OGRE/Plugin_ParticleFX.dylib
echo "lddx Plugin_BSPSceneManager"
./lddx -r -d ${PREFIX}/lib/OGRE/Plugin_BSPSceneManager.dylib
echo "lddx Plugin_OctreeSceneManager"
./lddx -r -d ${PREFIX}/lib/OGRE/Plugin_OctreeSceneManager.dylib

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

ctest --output-on-failure -C Release
