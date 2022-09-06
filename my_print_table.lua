--
function print_table (offset,title, table)
   x = string.format('%s%s : {', offset,title)
   print(x)
   if (table == nil) then print ('nil table') return end

   local off = offset
   off2 = ''
   for i,v in pairs(table) do
      -- print("i:v = ",i,":",v,'  ',type(v));
      if (type(v) == 'table') then
         print_table(off..'   ',i,v)
      else
         s = string.format("%s%s : ",off..'   ',i);
         print (s,v)
      end
   end
   print(string.format("%s}",offset))
end

