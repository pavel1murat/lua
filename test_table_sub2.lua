--
-- require 'print_table'
require 'my_print_table'
require 'new'
----------------------------------

print('------------------------------------- initializing t0')
t0 = new {
   x = new {
      e1 = "t1_emoeb" ;
      e2 = "t2_emoea" ;
   };
  new {
     e3 = "e3_emoe";
     e4 = "e4_emoe";
  }
}

print('------------------------------------- printing t0')
print_table(t0)

print('------------------------------------- initializing t1')
t1 = new {
   path = "emoe";
   
   producers =  new {
      t1_b = "t1_emoeb" ;
      t1_a = "t1_emoea"
   };
};

print_table('t1',t1)
-- print_table('t1.producers',t1.producers)
-- 
-- print('------------------------------------- printing t2')
-- t2 = new {
--    producers =  new {
--       t2_b = "t2_emoeb" ;
--       t2_a = "t2_emoea" ;
--    }
-- }
-- 
-- print_table('t2.producers',t2.producers)
-- 
-- print('------------------------------------- initializing physics')
-- physics = new {
--    producers = new {
--       t1.producers,
--       t2.producers
--    }
-- }
-- 
-- print('------------------------------------- printing physics')
-- print_table('physics'     ,physics     )
