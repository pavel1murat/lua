--
require 'new'

Services = new {
-- # define services for specific tasks: these are components needed for
-- # a complete job
  Core            = new {
    message                 = default_message ;
    GeometryService         = new {
        inputFile           = "Offline/Mu2eG4/geom/geom_common.txt";
        bFieldFile          = "Offline/Mu2eG4/geom/bfgeom_v01.txt";
        simulatedDetector   = { tool_type = "Mu2e" };
    };
    ConditionsService       = new { conditionsfile = "Offline/ConditionsService/data/conditions_01.txt"      };
    GlobalConstantsService  = new { inputFile      = "Offline/GlobalConstantsService/data/globalConstants_01.txt" };
--    DbService               = DbEmpty ;
--    ProditionsService       = Proditions;
  };

  SimOnly   = new {
    RandomNumberGenerator   = new { defaultEngineKind= "MixMaxRng" };
    SeedService             = "automaticSeeds";
    Mu2eG4Helper            = nil;
  };

  -- #RecoOnly = {
  -- #}
}
-- # aggregate to make complete sets that can be used to fully configure common jobs
Services.Sim  = new {
  Services.Core ;
  Services.SimOnly ;
}

