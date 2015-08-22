#!/bin/bash

set -e

BASEDIR=`dirname "$0"`

#make -C "$BASEDIR/.."
pushd "$BASEDIR/.."
./piedpiper_make
popd

FILES=($BASEDIR/tibby.264 $BASEDIR/black.264 $BASEDIR/../res/BAMQ2_JVC_C.264 $BASEDIR/../res/BA1_FT_C.264)

if [ "$#" -eq 1 ]
then
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    for f in $(ls $1); do
        FILES+=("$1$f")
    done
    IFS=$SAVEIFS
fi

IFS=""
for f in ${FILES[@]}; do
    rm -f /tmp/a.pip* /tmp/a.264
    echo "============== $f ================" >&2
    echo "    ./h264dec $f /tmp/a.pip"
    ./h264dec "$f" /tmp/a.pip
    echo "    ./h264dec /tmp/a.pip /tmp/a.264"
    ./h264dec /tmp/a.pip /tmp/a.264
    diff /tmp/a.264 "$f"
done
