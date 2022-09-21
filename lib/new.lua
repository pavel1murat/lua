------------------------------------------------------------------
-- arg: always a table {(one and only one)} with a list of things in it
-- use the fact that lua allows to write 'new({})' as 'new {}'
------------------------------------------------------------------------------
verbose=nil
-- require 'table'

function new (arg)
   newtbl = {}     -- output table

   for k,v in pairs(arg) do
      if (verbose) then print("---------------- <lua>: <b> is ssssss called, k = ",k,type(v)); end

      string_key = true
      for k1,v1 in ipairs(arg) do
         if (k1 == k) then
            string_key = false;
            break;
         end ;
      end
      if (verbose) then print("---------------- <lua> string_key:",string_key) ; end
--      
      if (string_key) then
         newtbl[k]  = v;
      else
         -- if the key is numeric, assume it is a table, insert its contents,
         if (verbose) then print('an element with a numeric key:',k,' manage it ') ; end
         if      (type(v) == 'table' ) then
            for k2,v2 in pairs(v) do ;
               newtbl[k2] = v2 ;
            end
         else
            if (type(v) == 'string') or (type(v) == 'number') then
               --  arg is a a list of things: strings, numbers... 
               table.insert(newtbl,v);
            end
         end
      end
   end
   
   if (verbose) then print("---------------- <lua> <b> before newtable"); end
   
   -- newtbl["xxxxxxxxxxxx"] = 5
   return newtbl;
end

