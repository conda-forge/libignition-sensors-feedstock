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
    ctest --output-on-failure -C Release -E "UNIT_Lidar_TEST|UNIT_Camera_TEST|INTEGRATION_camera_plugin|INTEGRATION_depth_camera_plugin|INTEGRATION_gpu_lidar_sensor_plugin|INTEGRATION_rgbd_camera_plugin|INTEGRATION_thermal_camera_plugin"
else
    ctest --output-on-failure -C Release
fi
