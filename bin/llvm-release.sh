#!/bin/sh
if [ ! -d "build" ]; then
  mkdir build
fi

cd build

if [ ! -d "release" ]; then
  mkdir release
fi

cd release

cmake -G Ninja -D CMAKE_BUILD_TYPE=Release ../../llvm
ninja

cd ../..
