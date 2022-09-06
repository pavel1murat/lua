-- #
-- # Standage destinations for the message service --
-- # for use by messageService.fcl, which defines standard configurations for
-- # the message service.
-- #
-- #
-- # Normally, users will use messageService.fcl which includes this file,
-- # rather than dealing with this file directly.
-- #
-- # Usage - in a fcl configuration file
-- #
-- # 1 - Place the following near the start, among the PROLOGs:
-- #     #include "Offline/fcl/standardMessageDestinations.fcl"
-- #
-- # 2 - In a destinations entry in a block that will be part of the message
-- #     service block, choose the selected standard destination configuration
-- #     among:
-- #     destinations : @local::mf_error
-- #     destinations : @local::mf_warning
-- #     destinations : @local::mf_coutInfo
-- #     destinations : @local::mf_debug
-- #
-- # 3 - If message statistics will also be desired, also insert the corresponding
-- #     standard statistics, from among:
-- #     destinations : @local::mf_errorStats
-- #     destinations : @local::mf_warningStats
-- #     destinations : @local::mf_coutInfoStats
-- #     destinations : @local::mf_debugStats
-- #
-- # 3 - Customizations to configurations using these standard destinations
-- #     are straightforward to make; see customizingMessageFacilityFcl.txt
-- #     for simple examples.


-- BEGIN_PROLOG

-- Four standardized (but customizable) destinations, with different thresholds

require 'new'

mf_null = new { type = "file"; filename =  "/dev/null" }

mf_error = new {
   type      = "file"     ; -- Record the messages in a file.
   filename  = "error.log"; -- Name of the file in which to place the messages;
                          -- quoted, because if contains a dot.
   threshold = "ERROR" ;    -- Threshold of what level of messages to react to.
   append    =  true   ;    -- Will append messages to named file if it exists
                         -- A place to list named categories, if you want to
                         -- specify the behavior for specific categories of
                         -- messages.
                         -- For example, in LigInfo("suspiciousParticle") << p;
                         -- the category of the message would be
                         -- "suspiciousParticle."
   categories = new {
      default = new {             -- # Limits for any category not explicitly mentioned.
         limit    = 100 ;          -- # Output first 100 instances of messages in each
                                 -- # category, then go to exponential backoff.
         timespan = 300 ;          -- # If this many seconds elapse between messages of
                            -- # one category being issued, reset the counting
                            -- # toward the limit (in this case, output the next
                            -- # 100 instances, even if limit had been exceeded).
      }
   }
}

mf_errorStats = new {
   type     = "file" ;
   filename = mf_error.filename ;        -- # Because the filename matches that
                                         -- # of a destination (if used with
                                         -- # errorMsg), the statistics will be
                                         -- # placed at the end of the output
                                         -- # to that destination.
}

mf_warning = new {
   type      =  "file" ; 
   filename  =  "warning.log" ;
   threshold =  "WARNING"     ; -- # React to WARNING and ERROR message severities;
                                -- # ignore messages issued via iLogInfo and LogDebug.
   categories =  new {
      default = new {
         limit    = 100 ;
         timespan = 300 ;
      }
   }
}

mf_warningStats = new {
   type     = "file" ;
   filename = mf_warning.filename ;
}

mf_coutInfo = new {
   type      =  "cout"   ;    -- # type could be cout, cerr, archive, dds, or file.
   threshold =  "INFO"   ;    -- # React to INFO, WARNING, and ERROR
                            -- # message severities; ignore LogDebug messages.
   categories = new {
      ArtReport = new {            -- # ArtReport is a category of INFO messages that
                            -- # the framework will generate to tell, for example,
                            -- # when a next event is started.
         reportEvery = 1  ;  -- # start with every one
         limit       = 1  ;  -- # start exponential backoff right away
         timespan    = 300;  -- # report every 5min too, as asymmtotic behavior
      } ;
      
      fileAction        = new { limit =  -1 } ;
      default           = new { limit = 100 } ;
      
      ArtSummary        = new { limit = -1  } ; -- # allow the path and modules summaries (TrigReport)
      RANDOM            = new { limit = 0 };
      FastCloning       = new { limit = 0 };
      TransientBranch   = new { limit = 0 };
      path              = new { limit = 0 };
      MF_INIT_OK        = new { limit = 0 };
      DeactivatedPath   = new { limit = 0 };
      PathConfiguration = new { limit = 0 };
      GEOM_MINRANGECUT  = new { limit = 0 };
      GEOM_PARTICLECUT  = new { limit = 0 };
      Configuration     = new { limit = 0 };
      HITS              = new { limit = 0 };
      COSMIC_STEPPOINTS = new { limit = 0 };
      Summary           = new { limit = 0 };
      INFO              = new { limit = 0 };
   } 
} 

mf_debug = new {
   type      = "file"   ;
   filename  = "debug.log" ;
   append    = false  ;
   threshold = "DEBUG" ;    -- # No messages will be ignored due to this threshold.
                          -- # However, unless debugModules in service.message
                          -- # includes "*", messages from a module which is
                          -- # not among the debug modules listed will still
                          -- # be suppressed.
   categories = new {
      default = new { limit = -1 }
   } ;
}

mf_debugStats = new {
   type     = "file"             ;
   filename = mf_debug.filename  ;
}

-- END_PROLOG
