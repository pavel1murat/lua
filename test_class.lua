# -*- mode:tcl -*-

Module = { 
    module_class = 'EmptyEvent' ,
    blin         = 'ohoho'
}

AModule = { 
    module_class = 'AModule' ,
    blin         = 'BLIN' 
}

-- 

function Module:create(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- Base class method 'create'


m0 = Module:create()

m1 = Module:create{ 
    module_class = 'RootInput',
    blin = 1 
}

m2 = Module:create(AModule) 


print('m0.module_class, m0.blin:', string.format("%-10s %-10s", m0.module_class, m0.blin))

print('m1.module_class, m1.blin:', string.format("%-10s %-10s", m1.module_class, m1.blin))

print('m2.module_class, m2.blin:', string.format("%-10s %-10s", m2.module_class, m2.blin))
