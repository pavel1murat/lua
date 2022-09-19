
require 'lib/new'

------------------------------------------------------------------------------
-- function newb (arg)
--    newtbl = {}     -- output table
-- 
--    for k,v in pairs(arg) do
--       print("---------------- <lua>: <b> is ssssss called, k = ",k,type(v));
-- 
--       string_key = true
--       for k1,v1 in ipairs(arg) do
--          if (k1 == k) then
--             string_key = false;
--             break;
--          end ;
--       end
--       print("---------------- <lua> string_key:",string_key)
-- --      
--       if (string_key) then
--          newtbl[k]  = v;
--       else
--          -- if the key is numeric, assume it is a table, insert its contents,
--          -- print('an element with a numeric key:',k,' manage it ')
--          if      (type(v) == 'table' ) then
--             for k2,v2 in pairs(v) do ;
--                newtbl[k2] = v2 ;
--             end
--          else
--             if (type(v) == 'string') then
--                --  this ('string') shouldn't be happening
--                print("-------------- <lua>: newt this --string-- shouldn't be happening")
--                table.insert(newtbl,v);
--             end
--          end
--       end
--    end
--    
--    --   newtbl = {xxxxxxxxx = 5}
--    print("---------------- <lua> <b> before newtable");
--    
--    newtbl["xxxxxxxxxxxx"] = 5
--    return newtbl;
-- end
-- 

stntuple = {
   producers = {
      StntupleMaker1 = {
         module_type = "StntupleMaker" ;
         makeTracks   = 1;
         makeHelices  = 1;
      } ;
      StntupleMaker2 = { mtype = "StntupleMaker" } ;
      StntupleMaker3 = { mtype = "StntupleMaker" } ;
   } ;

   filters = {
      StntupleFilter1 = { module_type = "FFFFFF_1" };
      StntupleFilter2 = { module_type = "FFFFFF_2" };
   };
};

print("---------------- <lua>: after stntuple")

production = {
   producers = {
      ProductionMaker1 = {
         mtyp = "SSSS1" ;
         minP = 10.1 ;
      } ;
      ProductionMaker2 = { mtyp = "SSSS2" } ;
      ProductionMaker3 = { mtyp = "SSSS2" } ;
   } ;

   filters = {
      ProductionFilter1 = { mtyp = "FFFFFF_1" };
      ProductionFilter2 = { mtyp = "FFFFFF_2" };
   };
};

print("---------------- <lua>: after production")

physics = {

   producers = new {
      ma = { module_type = "MA" };
      stntuple.producers ;
      production.producers ;
   };

   filters =  new {
      stntuple.filters ;
      production.filters
   };
   
--   x = 1.55;
--   
--   y= b {x = 2} ;
--
   -- z = fun("assfaaf");
}

print("---------------- <lua>: done initializing")

-- physics = physics1;

