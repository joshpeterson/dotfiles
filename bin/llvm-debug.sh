#!/bin/sh
if [ ! -d "build" ]; then
  mkdir build
fi

cd build

if [ ! -d "debug" ]; then
  mkdir debug
fi

cd debug

cmake -G Ninja -D CMAKE_BUILD_TYPE=Debug ../../llvm
ninja clang && ninja -j2

cd ../..
