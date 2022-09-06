

x = {
   {z = 1};
   {y = 2};
}

for i=1,#{pairs(x)} do
   for k,v in pairs(x[i]) do print(k,'=',v,'type(v):',type(v)) end
end

print('x.y=',x[2])
