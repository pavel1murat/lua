#!/usr/bin/lua

-- 
package.path = "?.lua;converted/?.lua"
require 'new'
require 'print_table'

script=arg[1]
dofile(script)
