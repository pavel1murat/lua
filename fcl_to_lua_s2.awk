#------------------------------------------------------------------------------

BEGIN {
    printed = 0;
}


/=/ {
    if ($NF != "{") {
        /* opening bracket - do nothing */
        print $0" ;"
        printed = 1;
    }
    else {
        /* 3 parameters and an equal sign */
        if ((NF == 3) && ($2 == "=")) {

            printf("--  %s\n",$0)
            if (index("@",$3) != 0) {
                /* @something */
                $3 = $3
            }
            else {
                $3 = "\""$3"\""
            }
            print $0" ;"
            printed = 1;
        }
        else {
            print $0
            printed = 1;
        }
    }

}

{
    if (printed == 0) {
        print $0
    }
    printed = 0
}
END {
}




