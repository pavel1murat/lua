-- -*- mode:lua -*-
-- # This file defines some standard configurations for services
-- #

require 'minimalMessageService'
#include "Offline/DbService/fcl/prolog.fcl"
#include "Offline/ProditionsService/fcl/prolog.fcl"

-- BEGIN_PROLOG


automaticSeeds = {
    policy            = "autoIncrement" ;
    baseSeed          = nil ;
    maxUniqueEngines  = 100 ;
    -- # verbosity         = 2
    -- # endOfJobSummary   = true
}

preDefinedSeeds = {
     policy            = "preDefined" ;
     baseSeed          = nil;
     maxUniqueEngines  = nil;
                                  -- # An example that will work with g4test_03
                                  -- # It will create the same seeds as the automaticSeeds configuration.
     generate          = 0;
     g4run             = 1;
     makeSH            = 2;

     -- # verbosity         = 2
     -- # endOfJobSummary   = true
}

Services = {
-- # define services for specific tasks: these are components needed for
-- # a complete job
  Core            = {
    message                    = default_message ;
    GeometryService            = {
        inputFile           = "Offline/Mu2eG4/geom/geom_common.txt";
        bFieldFile          = "Offline/Mu2eG4/geom/bfgeom_v01.txt";
        simulatedDetector   = { tool_type= "Mu2e" };
    }
    ConditionsService       = { conditionsfile = "Offline/ConditionsService/data/conditions_01.txt"      };
    GlobalConstantsService  = { inputFile      = "Offline/GlobalConstantsService/data/globalConstants_01.txt" };
    DbService               = DbEmpty ;
    ProditionsService       = Proditions;
  }

  SimOnly   = {
    RandomNumberGenerator   = { defaultEngineKind= "MixMaxRng" };
    SeedService             = automaticSeeds;
    Mu2eG4Helper            = {};
  }

  -- #RecoOnly = {
  -- #}

}
-- # aggregate to make complete sets that can be used to fully configure common jobs
Services.Sim  = {
  Services.Core ;
  Services.SimOnly ;
}

Services.Reco            = {
  Services.Core ;
  -- #@table::Services.RecoOnly
}

Services.SimAndReco = {
  Services.Core ;
  Services.SimOnly ;
  -- #@table::Services.RecoOnly
}

-- END_PROLOG
