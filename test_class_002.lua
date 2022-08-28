# -*- mode:tcl -*-

-----------------------

Table = {}

--[[
function Table:create(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
--]]

function Table:create(o)
  o = o or {}
  setmetatable(o, 
{
    __add = function(Table, newtable)
	
               for i = 1, table.maxn(newtable) do
                   table.insert(Table, Table.maxn(mytable)+1,newtable[i])
               end
               return Table
               end
}
  )
  self.__index = self
  return o
end

-------------------------------------------------
function Table:print(o)
print("emoe\n");
end

------------------

mf_coutInfo = { 
  type      = 'cout',   -- # type could be cout, cerr, archive, dds, or file.
  threshold = 'INFO',   -- # React to INFO, WARNING, and ERROR 
                        -- # message severities; ignore LogDebug messages. 
 categories = {
   ArtReport =          -- # ArtReport is a category of INFO messages that
                        -- # the framework will generate to tell, for example, 
                        -- # when a next event is started. 
   {
     reportEvery = 1,    -- # start with every one
     limit       = 1,    -- # start exponential backoff right away
     timespan    = 300,  -- # report every 5min too, as asymmtotic behavior
   } , 

   fileAction = {
     limit = -1
   } , 

   default =  {
     limit = 100
   } , 

     ArtSummary = {   -- # allow the path and modules summaries (TrigReport)
     limit = -1
   }, 

   RANDOM            = { limit = 0 } ,
   FastCloning       = { limit = 0 } ,
   TransientBranch   = { limit = 0 } ,
   path              = { limit = 0 } ,
   MF_INIT_OK        = { limit = 0 } ,
   DeactivatedPath   = { limit = 0 } ,
   PathConfiguration = { limit = 0 } ,
   GEOM_MINRANGECUT  = { limit = 0 } ,
   GEOM_PARTICLECUT  = { limit = 0 } ,
   Configuration     = { limit = 0 } ,
   HITS              = { limit = 0 } ,
 } -- # end categories
} -- # end mf_coutInfo

--------------------------------------

mf_interactive = {
  destinations =   {
    log        =  mf_coutInfo ,                       -- # a destination which will react to 
    statistics =  { stats = mf_coutInfoStats }
  }
}

default_message = mf_interactive

automaticSeeds = {
    policy            = "autoIncrement",
    baseSeed          = nil,
    maxUniqueEngines  = nil,
}

Services = {
                             -- # define services for specific tasks: these are components needed for
                             -- # a complete job
  Core	    = {
    message		    = Table:create(default_message) ,
    GeometryService	    = { 
	inputFile           = "Mu2eG4/geom/geom_common.txt" ,
	simulatedDetector   = { tool_type = "Mu2e" },
    } ,
    ConditionsService	    = { conditionsfile = "Mu2eG4/test/conditions_01.txt"      } ,
    GlobalConstantsService  = { inputFile      = "Mu2eG4/test/globalConstants_01.txt" } ,
    DbService               = DbEmpty                                                   ,
    ProditionsService       = Proditions                                                ,
  },

  SimOnly   = {
      RandomNumberGenerator = { defaultEngineKind = "MixMaxRng" } ,
      SeedService	    = { automaticSeeds                    ,
	  baseSeed          =  8                                  ,
	  maxUniqueEngines  =  100                                ,
      } ,
      G4Helper              = {},
  }
}


services = Table:create(Services.SimOnly)
    
--[[
    RandomNumberGenerator = {Services.SimOnly.RandomNumberGenerator} ,
    G4Helper              = Services.SimOnly.G4Helper,
    SeedService = Services.SimOnly.SeedService}
   --]]


print('services.SeedService.baseSeed = ', services.SeedService.baseSeed)

print(services)

services.print()
