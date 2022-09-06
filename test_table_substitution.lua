-- meta class
FclTable = {}

function FclTable:new (o)
   o = o or {}
   setmetatable(o, {})
   -- self.__index = self
   return self;            -- constructor 
end

function FclTable:print (title)
   print('---- ',title, ': self = ',self)
   for i,v in pairs(self) do
      print("i:v = ",i,":",v,'  ',type(v));
      -- if (type(v) == 'table') then v:print('title') end
   end
end
   
t1 = FclTable:new() ;

t1.producers = FclTable:new();

t1:print('t1:001:')

t1.a = 33

t1:print('t1:002')

t2 = FclTable:new {
   producers =  FclTable:new {
      t2_b = "t2_emoeb" ;
      t2_a = "t2_emoea" ;
   }
}

physics = FclTable:new {
   producers = FclTable:new {
      t1.producers;
      t2.producers;
   }
};

physics.filters = FclTable:new ()

physics:print('003')

print('001: physics.producers   = ',physics.producers)
print('     physics.producers.a = ',physics.producers.a)
print('     physics.producers.b = ',physics.producers.b)

-- want to substitute y with x


print('physics.producers.t2_b = ',physics.producers.t2_b)

