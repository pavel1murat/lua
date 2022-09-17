
require 'Offline/fcl/minimalMessageService'

process_name  = "BarTest" ;

source = new {
  module_type  = "EmptyEvent" ;
  maxEvents   = 5;
};

services = new {
  message      = default_message ; 
  Bug01Service = new { fileName = "foo" }
};
