------------------------------------------------------------------
-- arg: always a table {(one and only one)} with a list of things in it
-- use the fact that lua allows to write 'new({})' as 'new {}'
------------------------------------------------------------------------------
function new (arg)
   newtbl = {}     -- output table

   for k,v in pairs(arg) do
      print("---------------- <lua>: <b> is ssssss called, k = ",k,type(v));

      string_key = true
      for k1,v1 in ipairs(arg) do
         if (k1 == k) then
            string_key = false;
            break;
         end ;
      end
      print("---------------- <lua> string_key:",string_key)
--      
      if (string_key) then
         newtbl[k]  = v;
      else
         -- if the key is numeric, assume it is a table, insert its contents,
         -- print('an element with a numeric key:',k,' manage it ')
         if      (type(v) == 'table' ) then
            for k2,v2 in pairs(v) do ;
               newtbl[k2] = v2 ;
            end
         else
            if (type(v) == 'string') then
               --  this ('string') shouldn't be happening
               print("-------------- <lua>: newt this --string-- shouldn't be happening")
               table.insert(newtbl,v);
            end
         end
      end
   end
   
   --   newtbl = {xxxxxxxxx = 5}
   print("---------------- <lua> <b> before newtable");
   
   newtbl["xxxxxxxxxxxx"] = 5
   return newtbl;
end

-- function new (tbl)
--    n     = #{pairs(tbl)};
--    -- print('new : ENTER npars: ', n)
--    t     = {}     -- output table
--    
--    for k,v in pairs(tbl) do
--       -- print("k,v : ",k,"=",v,'  ',type(v));
--       -- figure whether k is a string or numeric key
--       string_key = true
--       for k1,_ in ipairs(tbl) do
--          if (k1 == k) then string_key = false; break; end
--       end
--       
--       if (string_key) then
--          -- if string key, just insert an element
--          -- print('an element with a string key:',k,' insert it ')
--          t[k]  = v;
--       else
--          -- if the key is numeric, assume it is a table, insert its contents,
--          -- print('an element with a numeric key:',k,' manage it ')
--          if (type(v) == 'table') then
--             for k2,v2 in pairs(v) do
--                t[k2] = v2
--             end
--          else
--             -- is that supposed to happen ?
--             if (type(v) == 'string') then
--                table.insert(t,v);
--             end
--          end
--       end
--       -- print('element ',v,' of type ',type(v),' inserted')
--       -- insert_contents(t,v)
--    end
--    -- print('new : EXIT')
--    return t;
-- end
