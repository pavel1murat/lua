-- 
require 'lib/new'
require 'lib/print_table'

stntuple = {
   producers = {
      StntupleMaker1 = {
         module_type = "StntupleMaker" ;
         makeTracks   = 1;
         makeHelices  = 1;
      } ;
      StntupleMaker2 = { module_type = "StntupleMaker" } ;
      StntupleMaker3 = { module_type = "StntupleMaker" } ;
   } ;

   filters = {
      StntupleFilter1 = { module_type = "FFFFFF_1" };
      StntupleFilter2 = { module_type = "FFFFFF_2" };
   };
};

print("---------------- <lua>: after stntuple")

production = {
   producers = {
      ProductionMaker1 = {
         module_type = "SSSS1" ;
         minP = 10.1 ;
      } ;
      ProductionMaker2 = { module_type = "SSSS2" } ;
      ProductionMaker3 = { module_type = "SSSS2" } ;
   } ;

   filters = {
      ProductionFilter1 = { module_type = "FFFFFF_1" };
      ProductionFilter2 = { module_type = "FFFFFF_2" };
   };
};

print("---------------- <lua>: after production")

physics = {

   producers = new {
      ma = {
         module_type = "MA" ;
         maxTime     = 10.5 ;
      };
      stntuple.producers ;
      production.producers ;
   };

   filters =  new {
      stntuple.filters ;
      production.filters
   };

   trigger_paths = { "path1", "ph2", "path3" } ;
   end_paths     = { "e1", "out" } ;
}

stub = "mu2e.pbar2m.bmum1s61b0.001201_00000000"
outputs = new {
   out1 = { 
      fileName1 = "dig." .. stub .. ".art" ;
      fileName2 = "nts." .. stub .. ".nts" ;
   }
};

print("---------------- <lua>: done initializing, print \'physics\' table")
print_table(physics)

-- physics = physics1;

