green=`tput setaf 2`
reset=`tput sgr0`
echo "${green}Adding LLVM to sources${reset}"
llvmText="deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main
# 4.0
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main
# 5.0
deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main
deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main
"

if [ -e /etc/apt/sources.list.d/llvm.list ]
then
    echo "${green}Skipping LLVM Source installation - already there!${reset}"
else
    llvmText > /etc/apt/sources.list.d/llvm.list
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add -
fi

echo "${green}Updating & Upgrading Sources${reset}"
apt-get update
apt-get -y upgrade
apt-get install -y build-essential cmake autoconf clang-4.0 mingw-w64 gobjc++-mingw-w64 gobjc-mingw-w64
ls -s /usr/bin/clang-4.0 /usr/bin/clang
ls -s /usr/bin/clang++-4.0 /usr/bin/clang++

echo "${green}Getting wclang${reset}"
git clone https://github.com/tpoechtrager/wclang
cd wclang
echo "${green}Building wclang${reset}"
cmake -DCMAKE_INSTALL_PREFIX=/usr .
make
echo "${green}Copying Binaries to /usr/bin${reset}"
cd src
cp wclang /usr/bin/x86_64-w64-mingw32-clang
cp wclang /usr/bin/x86_64-w64-mingw32-clang++
cd ../../

echo "${green}Getting OBJFW${reset}"
git clone https://github.com/Midar/objfw
cd objfw
echo "${green}Running Config${reset}"
autoreconf
./configure --host=x86_64-w64-mingw32 --enable-static
echo "${green}Building (This might fail)${reset}"
make -j16
echo "${green}Patching${reset}"
cd test
echo "int main() {return 0;}" > test.c
gcc -o tests.exe test.c
cd ../
make install
echo "${green}Finished${reset}"