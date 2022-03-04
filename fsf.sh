#!/bin/sh

echo "- Getting latest Fairy-Stockfish ..."

if [ -d Fairy-Stockfish/src ]; then
    cd Fairy-Stockfish/src
    make clean > /dev/null
    git pull
else
    git clone --depth 1 https://github.com/ianfab/Fairy-Stockfish.git
    cd Fairy-Stockfish/src
fi

echo "- Determining CPU architecture ..."

#ARCH=x86-64
#EXE=stockfish-x86_64

if [ -f /proc/cpuinfo ]; then
    if grep "^flags" /proc/cpuinfo | grep -q popcnt ; then
        ARCH=fsf
        EXE=stockfish-x86_64-modern
    fi

    if grep "^vendor_id" /proc/cpuinfo | grep -q Intel ; then
        if grep "^flags" /proc/cpuinfo | grep bmi2 | grep -q popcnt ; then
            ARCH=x86-64-bmi2
            EXE=stockfish-x86_64-bmi2
        fi
    fi
fi

echo "- Building $EXE ... (patience advised)"
make build ARCH=$ARCH EXE=../../$EXE largeboards=yes > /dev/null

cd ../..
echo "- Done!"
