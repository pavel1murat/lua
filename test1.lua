x = {
   a = "dddd";
   b = "dddff";
   {x=3}
}

for i,v in pairs(x) do
   numeric = false
   for i1,_ in ipairs(x) do
      if (i1 == i) then
         -- print(i1)
         numeric = true
         break
      end
   end
   print('i, numeric: ',i,numeric)
end
