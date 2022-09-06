

a = {
   x= "aaaa";
   y= "bbbb";
}


b = {
   b1 = {};
   b2 = {};
}
table.insert(b,a)


setmetatable(b,{__index={len=function(len) local incr=0 for _ in pairs(len) do incr=incr+1 end return incr end}})
             b:len()
