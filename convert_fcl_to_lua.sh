#!/usr/bin/bash

topdir="/projects/mu2e/app/users/murat/muse"

for stub in fcl test ; do

    idir=$topdir/$1/$stub
    odir=./converted/$1/$stub
    
    if [ ! -d $idir ] ; then continue ; fi
                             
    if [ ! -d $odir ] ; then mkdir -p $odir ; fi

    for f in `ls $idir | grep .fcl` ; do
        f1=`echo $f | sed s/\.fcl/.lua/`
        ./fcl_to_lua.rb -f $idir/$f  >| $odir/$f1 
    done
done
