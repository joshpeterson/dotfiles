#! /bin/sh
git clone https://git.llvm.org/git/llvm.git/
cd llvm/tools
git clone https://git.llvm.org/git/clang.git/
cd ..
cd llvm/projects
git clone https://git.llvm.org/git/compiler-rt.git/
cd ..
cd llvm/projects
git clone https://git.llvm.org/git/openmp.git/
cd ..
cd llvm/projects
git clone https://git.llvm.org/git/libcxx.git/
git clone https://git.llvm.org/git/libcxxabi.git/
cd ..
cd llvm/projects
git clone https://git.llvm.org/git/test-suite.git/
cd ..
git config branch.master.rebase true
