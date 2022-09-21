#!/usr/bin/bash
# 
idir=converted/$1


for f in `ls $idir | grep .lua` ; do
    echo -------------------------- checking $idir/$f
    ./test_conversion.lua $idir/$f 
done
