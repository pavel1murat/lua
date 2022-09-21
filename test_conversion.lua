#!/usr/bin/lua

-- 
-- package.path = "?.lua;converted/?.lua"

-- require 'table'
require 'lib/new'
require 'lib/print_table'

script = arg[1]
tbl    = arg[2]  -- don't say 'table' !!!

dofile(script)
