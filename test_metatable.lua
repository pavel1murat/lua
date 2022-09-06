-- 
t1 = setmetatable({key1 = "value1"}, {
      __index = function(tbl, key)
	
         if key == "key2" then
            return "metatablevalue"
         else
            return tbl[key]
         end
      end
})

print(' --- test 1:', t1.key1,t1.key2) ;


mymetatable = {}
t2 = setmetatable({key1 = "value1"}, { __newindex = mymetatable })

print(' --- test 2:', t2.key1)

t2.newkey = "new value 2"
print(t2.newkey,mymetatable.newkey)

t2.key1 = "new  value 1"


-- call: test_002(t2)
function test_002(x)
   print(x.key1,x.newkey1)
end

-- test3: length of the table

t3 = {'1', two='2', pi=math.pi, popen=io.popen} ;

setmetatable(t3,{__index = { len = function(len)
                                local incr=0
                                for _ in pairs(len) do
                                   incr=incr+1
                                end
                                return incr
end}})
t3:len()
