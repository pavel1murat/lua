#!/usr/bin/bash

topdir="/projects/mu2e/app/users/murat/muse/"$1

# step 1: directory itself 

idir=$topdir

if [ ! -d $topdir ] ; then
    echo ">>> ERROR: $topdir doesn\'t exist, EXIT."
    return ;
fi

for f in `ls $idir | grep .fcl` ; do
    f1=`echo $f | sed s/\.fcl/.lua/`
#------------------------------------------------------------------------------
# create a subdirectory only if needed
#------------------------------------------------------------------------------
    odir=./converted/$1 ; if [ ! -d $odir ] ; then mkdir -p $odir ; fi

    echo --------------------------------converting $idir/$f
    ./fcl_to_lua.rb -f $idir/$f  >| $odir/$f1 
done
#------------------------------------------------------------------------------
# dir/fcl and dir/test - those may or may not exist
#------------------------------------------------------------------------------
for subdir in fcl test ; do

    idir=$topdir/$subdir ; if [ ! -d $idir ] ; then continue ; fi

    odir=./converted/$1/$subdir ;

    for f in `ls $idir | grep .fcl` ; do
        f1=`echo $f | sed s/\.fcl/.lua/`
#------------------------------------------------------------------------------
# create a subdirectory only if needed
#------------------------------------------------------------------------------
        if [ ! -d $odir ] ; then mkdir -p $odir ; fi
        
        echo --------------------------------converting $idir/$f
        ./fcl_to_lua.rb -f $idir/$f  >| $odir/$f1 
    done
done
