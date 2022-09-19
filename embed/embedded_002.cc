// -- window.lua
// window = {
//     width = 640,
//     height = 480,
//     title = "Test window"
// }

#include <iostream>
#include <string>
 
extern "C" {
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}

int Debug = 0;

//-----------------------------------------------------------------------------
int parse_table(lua_State* L) {

  if (Debug) printf(" >>> parse_table ENTER\n");

  int nloops = 20, nl(0);

  lua_pushnil(L);                 // first key 
  
  if (Debug) printf(" >>> parse_table: after pushnil\n");

  while (lua_next(L,-2) != 0) {
//------------------------------------------------------------------------------
// figure out types of the key and teh value
//-----------------------------------------------------------------------------
    if (Debug) printf(" >>> parse_table:         top of the loop\n");
  
    std::string key_type, val_type;

    key_type = lua_typename(L,lua_type(L,-2));
    val_type = lua_typename(L,lua_type(L,-1));
      
    if (Debug) printf("element: key:%s , val:%s\n",key_type.data(),val_type.data());
//-----------------------------------------------------------------------------
    char msg[200], msg2[200];

    int ikey(-1), ival(-1);
    
    if      (lua_isnumber(L,-2))  {float       i   = lua_tonumber(L,-2); sprintf(msg,"key:number: %.0f",i       ); ikey = 0;}
    else if (lua_isstring(L,-2))  {std::string key = lua_tostring(L,-2); sprintf(msg,"key:text  : %-15s",key.data()); ikey = 1;}

    if      (lua_isnumber  (L,-1)) {float       val = lua_tonumber(L,-1); sprintf(msg2,"val:number: %f",val); ; ival = 1;}
    else if (lua_isstring  (L,-1)) {std::string val = lua_tostring(L,-1); sprintf(msg2,"val:string: %-15s",val.data()); ival = 2;}
    else if (lua_isfunction(L,-1)) {std::string val = lua_tostring(L,-1); sprintf(msg2,"val:string: %-15s",val.data()); ival = 2;}
    else if (lua_istable   (L,-1)) {
      printf("-------------------- val:table, parse table <%s>\n",msg);
      lua_pushvalue(L,-1);              // push table to stack and parse
      parse_table(L);
      ival = 3;
   }

    if (ival != 3) printf("%s %s\n",msg,msg2);

    lua_pop(L, 1);
    nl++;
    if (nl >= nloops) break;
  }

  lua_pop(L, 1);
  if (Debug) printf(" ------------ parse_table EXIT, nl = %i \n",nl);
  return 0;
}

//-----------------------------------------------------------------------------
// ./bin/embedded_002 physics_001.lua stntuple
//-----------------------------------------------------------------------------
int main( int argc, char *argv[] ) {

  if (argc != 3) {
    printf("wrong number of arguments, EXIT    :%i\n",argc);
    return -1;
  }

  std::string fn         = argv[1];
  std::string table_name = argv[2];

  printf("0010: fn = %s table_name = %s\n",fn.data(),table_name.data());

  lua_State* L = luaL_newstate();
  luaL_openlibs(L);
 
  int rc(0);

  printf("00101 before luaL_loadfile\n");

  rc = luaL_loadfile(L, fn.data());

  printf("00102 before lua_pcall\n");
  rc = lua_pcall(L, 0, 0, 0);

  // printf("00201 before print_table\n");

  //  rc = luaL_dostring(L, "print_table(physics)\n");  printf("0022 rc = %i \n",rc);

  printf("00202 before getglobal\n");

  rc = lua_getglobal(L,table_name.data());

  printf("00203 after getglobal rc = %i\n",rc);

  printf(" -------------- parse table: <%s>\n",table_name.data());
  
  rc = parse_table(L);
  
  lua_close(L);

  return rc;
}
