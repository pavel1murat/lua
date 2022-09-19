function newt (tbl)
   newtbl = {}     -- output table
--   
   for k,v in pairs(tbl) do
--      -- print("k,v : ",k,"=",v,'  ',type(v));
--      -- figure whether k is a string or numeric key
      string_key = true
      for k1,_ in ipairs(tbl) do
         if (k1 == k) then string_key = false; break;
         end ;
      end
--         
--         -- if string key, just insert an element
--         -- print('an element with a string key:',k,' insert it ')
      if (string_key) then newtbl[k]  = v;
      else
--            -- if the key is numeric, assume it is a table, insert its contents,
--            -- print('an element with a numeric key:',k,' manage it ')
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
--         -- print('element ',v,' of type ',type(v),' inserted')
--         -- insert_contents(t,v)
   end
--   -- print('new : EXIT')
   return newtbl;
end
 

------------------------------------------------------------------------------
function fun (arg)

   if (type(arg) == "table") then
      for k,v in pairs(arg) do
         if (k == "x") then return 2*v ; end
      end
      return -18;
   else
      if (type(arg) == "number") then
         val = 2*arg;
         return val
      end
      if (type(arg) == "string") then
         x = arg .. "EMOE"
         return x;
      end
   end
end

------------------------------------------------------------------------------
function newb (arg)
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
-- 

stntuple = {
   producers = {
      StntupleMaker1 = { mtyp = "StntupleMaker" } ;
      StntupleMaker2 = { mtyp = "StntupleMaker" } ;
      StntupleMaker3 = { mtyp = "StntupleMaker" } ;
   } ;

   filters = {
      StntupleFilter1 = { mtyp = "FFFFFF_1" };
      StntupleFilter2 = { mtyp = "FFFFFF_2" };
   };
};

print("---------------- <lua>: after stntuple")

production = {
   producers = {
      ProductionMaker = { mtyp = "SSSS" }
   } ;

   filters = {
      ProductionFilter1 = { mtyp = "FFFFFF_1" };
      ProductionFilter2 = { mtyp = "FFFFFF_2" };
   };
};

print("---------------- <lua>: after production")

physics = {

   producers = newb {
      ma = {mtyp = "AA"};
      stntuple.producers 
   };

--   filters =  {
--      stntuple.filters ;
--      production.filters
--   };
--   
--   x = 1.55;
--   
--   y= b {x = 2} ;
--
   -- z = fun("assfaaf");
}

print("---------------- <lua>: done initializing")

-- physics = physics1;

