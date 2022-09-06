--
require 'print_table'

-- function print_table (offset,title, table)
--    x = string.format('%s%s : {', offset,title)
--    print(x)
--    if (table == nil) then print ('nil table') return end
-- 
--    local off = offset
--    off2 = ''
--    for i,v in pairs(table) do
--       -- print("i:v = ",i,":",v,'  ',type(v));
--       if (type(v) == 'table') then
--          print_table(off..'   ',i,v)
--       else
--          s = string.format("%s%s : ",off..'   ',i);
--          print (s,v)
--       end
--    end
--    print(string.format("%s}",offset))
-- end

------------------------------------------------------------------------------
function insert_contents(tbl,t)
   for k,v in pairs(t) do
      if (t[k] == v) then
         tbl[k] = v;
      else
         print('insert_contents TROUBLE: don\'t know what to do: ',k,v);
      end
   end
end
------------------------------------------------------------------
-- arg: always a table {(one and only one)} with a list of things in it
------------------------------------------------------------------------------
function new (tbl)
   n     = #{pairs(tbl)};
   print('new : ENTER npars: ', n)
   t     = {}     -- output table
   
   for k,v in pairs(tbl) do
      print("k,v : ",k,"=",v,'  ',type(v));
      if (tbl[k] == v) then 
         print('a named a = x element, insert it ')
         t[k]  = v;
      else
         print('v is a table, insert its content')
         insert_contents(t,v)
      end
   end
   print('new : EXIT')
   return t;
end

----------------------------------


print('------------------------------------- initializing t0')
t0 = new {
   x = new {
      e1 = "t1_emoeb" ;
      e2 = "t2_emoea" ;
   };
  new {
     e3 = "e3_emoe";
     e4 = "e4_emoe";
  }
}

print('------------------------------------- printing t0')
print_table(t0)

-- print('------------------------------------- initializing t1')
-- t1 = new {
--    producers =  new {
--       t1_b = "t1_emoeb" ;
--       t1_a = "t1_emoea" ;
--    }
-- }
-- print_table('t1.producers',t1.producers)
-- 
-- print('------------------------------------- printing t2')
-- t2 = new {
--    producers =  new {
--       t2_b = "t2_emoeb" ;
--       t2_a = "t2_emoea" ;
--    }
-- }
-- 
-- print_table('t2.producers',t2.producers)
-- 
-- print('------------------------------------- initializing physics')
-- physics = new {
--    producers = new {
--       t1.producers,
--       t2.producers
--    }
-- }
-- 
-- print('------------------------------------- printing physics')
-- print_table('physics'     ,physics     )
