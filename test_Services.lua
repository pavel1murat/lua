Services = {
-- # define services for specific tasks: these are components needed for
-- # a complete job
  Core            = {
    message                    = default_message ;
    GeometryService            = {
        inputFile           = "Offline/Mu2eG4/geom/geom_common.txt";
        bFieldFile          = "Offline/Mu2eG4/geom/bfgeom_v01.txt";
        simulatedDetector   = { tool_type= "Mu2e" };
    };
    ConditionsService       = { conditionsfile = "Offline/ConditionsService/data/conditions_01.txt"      };
    GlobalConstantsService  = { inputFile      = "Offline/GlobalConstantsService/data/globalConstants_01.txt" };
--    DbService               = DbEmpty ;
--    ProditionsService       = Proditions;
  };

  SimOnly   = {
    RandomNumberGenerator   = { defaultEngineKind= "MixMaxRng" };
    SeedService             = "automaticSeeds";
    Mu2eG4Helper            = nil;
  };

  -- #RecoOnly = {
  -- #}

  -- need to include into a table another table
  Sim     {
     Core = Services.Core;
     SimOn
}
-- # aggregate to make complete sets that can be used to fully configure common jobs
Services.Sim  = {
  Core    = Services.Core ;
  SimOnly = Services.SimOnly ;
}
