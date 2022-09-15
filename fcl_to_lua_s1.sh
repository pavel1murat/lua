#!/bin/bash
# step1 : simplest part of the conversion

replace() {
    cat $1 | sed 's/{/new {/g'  |\
        sed 's/#include/require/g'        |\
        sed 's/#/-- #/g'        |\
        sed 's/: /= /g'         |\
        sed 's/ :/ =/g'         |\
        sed 's/\[/new {/g'         |\
        sed 's/\]/\}/g'         |\
        sed 's/\}/\} ;/g'       |\
        sed 's/BEGIN_PROLOG/-- BEGIN_PROLOG/g' |\
        sed 's/END_PROLOG/-- END_PROLOG/g'
}

#        sed 's/@local:://g'     | \
#        sed 's/@sequence:://g'  | \
#        sed 's/@table:://g'     | \

# how to replace all strings ?

process_offline() {
    for f in `cd pushd /data/sdb5/mu2e/app/users/murat/muse ; find Offline/fcl -name \*.fcl -print ; popd > /dev/null` ; do
        d=`dirname $f`
        bn=`basename $f | sed 's/.fcl//'`
        
        if [ -d converted/$d ] ; then
            x=1 ;
        else
            mkdir -p converted/$d
            # echo neemoe ;
        fi
        echo "-- -*-mode:lua -*-"                       >| converted/$d/$bn.lua
        replace /data/sdb5/mu2e/app/users/murat/muse/$f >> converted/$d/$bn.lua
    done
}
echo "-- -*-mode:lua -*-"  
replace $1
