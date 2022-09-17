-- -*- mode:lua -*-

-- require 'new'

-- main table
aaaa  =  {dd = "EEE"; rr = "TTT" } ;

physics = new {
   x = 1.55;
   
   y = "ssss";

   d = { r = "ewrwtqqq"; } ;
   
   new { x1 = 115.5; x2 = 15 ; x3 = 33 } ;

   producers = new {
      MergeHelices   = new {
         module_type = "MergeHelices" ;
         debugLevel  = 0;
         deltanh     =  5;      -- #  if the
         scaleXY     =  1.1;    -- #  scale the weight for having chi2XY/ndof distribution peaking at 1
         scaleZPhi   =  0.75  ; -- #  scale the weight for having chi2ZPhi/ndof distribution peaking at 1
      };
   };

   aaaa ;
   
   filters       = { f = "AAA" };
   analyzers     = { a = "FFFF" };
   
   trigger_paths = { "path_a","path_b"} ;
   end_paths     = { "end_path_a","end_path_b"} ;
}
