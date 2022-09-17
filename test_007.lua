-- # Read the test file made by MakeTestProduct and
-- # modified by ModifyTestProduct
-- #

require 'Offline/fcl/minimalMessageService'

process_name  = "modifyTrackSPM" ;

source = new {
  module_type  = "RootInput" ;
  fileNames    = new { "testG4S4pionSimDOE_01.art"};
};

services = new {
  message = default_message ; 
};

physics = new {

  producers = new {
    deuteronMixer = new {
      module_type  = "ModifyTrackSPM" ;
      productTag   = "deuteronMixer:tracker" ;
    };
    ootMixer      = new {
      module_type  = "ModifyTrackSPM" ;
      productTag   = "ootMixer:tracker" ;
    };
    flashMixer    = new {
      module_type  = "ModifyTrackSPM" ;
      productTag   = "flashMixer:tracker" ;
    };
    photonMixer   = new {
      module_type  = "ModifyTrackSPM" ;
      productTag   = "photonMixer:tracker" ;
    };
    neutronMixer  = new {
      module_type  = "ModifyTrackSPM" ;
      productTag   = "neutronMixer:tracker" ;
    };
    dioMixer      = new {
      module_type  = "ModifyTrackSPM" ;
      productTag   = "dioMixer:tracker" ;
    };
    protonMixer   = new {
      module_type  = "ModifyTrackSPM" ;
      productTag   = "protonMixer:tracker" ;
    };
  };

 t1  = new { "deuteronMixer", "ootMixer", "flashMixer", "photonMixer", "neutronMixer", "dioMixer", "protonMixer"};
 e1  = new { "out1"};

 trigger_paths  = new { "t1"};
 end_paths      = new { "e1"};

};

outputs = new {
  out1 = new {
    module_type  = "RootOutput" ;
    fileName     = "sim.owner.DNBtrackerTestDM.version.sequencer.art" ;
    outputCommands  = new { "keep *_*_*_*",
                        "drop *_deuteronMixer_tracker_MixPBI",
                        "drop *_ootMixer_tracker_MixPBI",
                        "drop *_flashMixer_tracker_MixPBI",
                        "drop *_photonMixer_tracker_MixPBI",
                        "drop *_neutronMixer_tracker_MixPBI",
                        "drop *_dioMixer_tracker_MixPBI",
                        "drop *_protonMixer_tracker_MixPBI",
                        "drop *_TriggerResults_*_modifyTrackSPM" ;
                      };

  };
};
