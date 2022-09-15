
require 'io'

-- --------------------------------------
function split(inputstr, sep)
   sep=sep or '%s'
   local t={}
   for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do
      table.insert(t,field)
      if s=="" then return t end
   end
end 

local rfile = io.open("converted/Offline/fcl/standardServices.s1", "r")

for line in rfile:lines() do
   words = split(line,' ')
   if ((#words == 3) and (words[2] == '=')) then
      print (" emoe")
      words[3] = '"'..words[3]..'"'
      print (words[1]," ",words[2]," ",words[3]," ;")
   else
      print(line)
   end
end
