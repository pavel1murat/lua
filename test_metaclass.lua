k-- Meta class

Rectangle = {area = 0, length = 0, breadth = 0}

-- Derived class method new

function Rectangle:new (o,length,width)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   self.l  = length or 0
   self.w  = width  or 0
   self.a  = self.l*self.w;
   return o
end

-- Derived class method printArea

function Rectangle:printArea()
   print("The area of Rectangle is ",self.a)
end

r = Rectangle:new(nil,10,20);

r:printArea();
