------------------------------------------------------------------
-- arg: always a table {(one and only one)} with a list of things in it
-- use the fact taht lua allows to write 'new({})' as 'new {}'
------------------------------------------------------------------------------
function new (tbl)
   n     = #{pairs(tbl)};
   print('new : ENTER npars: ', n)
   t     = {}     -- output table
   
   for k,v in pairs(tbl) do
      print("k,v : ",k,"=",v,'  ',type(v));
      -- figure whether k is a string or numeric key
      string_key = true
      for k1,_ in ipairs(tbl) do
         if (k1 == k) then string_key = false; break; end
      end
      
      if (string_key) then
         -- if string key, just insert an element
         print('an element with a string key:',k,' insert it ')
         t[k]  = v;
      else
         -- if the key is numeric, assume it is a table, insert its contents,
         for k2,v2 in pairs(v) do
            t[k2] = v2
         end
      end
      -- insert_contents(t,v)
   end
   print('new : EXIT')
   return t;
end
