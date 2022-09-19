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

//-----------------------------------------------------------------------------
int parse_table(lua_State* L) {

  printf(" ------------ parse_table ENTER\n");

  int nloops = 20, nl(0);

  lua_pushnil(L);                 // first key 
  
  printf(" >>> parse_table: after pushnil\n");

  while (lua_next(L,-2) != 0) {
//------------------------------------------------------------------------------
// figure out types of the key and teh value
//-----------------------------------------------------------------------------
    printf(" >>> parse_table:         top of the loop\n");
  
    std::string key_type, val_type;

    key_type = lua_typename(L,lua_type(L,-2));
    val_type = lua_typename(L,lua_type(L,-1));
      
    printf("element: key:%s , val:%s\n",key_type.data(),val_type.data());
//-----------------------------------------------------------------------------
    char msg[200], msg2[200];

    int ikey(-1), ival(-1);
    
    if (lua_isnumber(L,-2)) {
      float i = lua_tonumber(L,-2); sprintf(msg,"key:number: %.0f",i); ikey = 0;
    }
    else if (lua_isstring(L,-2)) {
      std::string key = lua_tostring(L,-2); sprintf(msg,"key:text  : %s",key.data()); ikey = 1;
    }
    
    if (lua_isnumber(L,-1)) {
      float val = lua_tonumber( L,-1); sprintf(msg2,"val:number: %f",val); ; ival = 1;
    }
    else if (lua_isstring(L,-1)) {
      std::string val = lua_tostring(L,-1); sprintf(msg2,"val:string: %s \n",val.data()); ival = 2;
    }
    else if (lua_istable(L,-1)) {
      printf("%s, val:table\n",msg);
      lua_pushvalue(L,-1);              // push table to stack
      parse_table(L);
      ival = 3;
   }

    if (ival != 3) printf("%s %s\n",msg,msg2);

    lua_pop(L, 1);
    nl++;
    if (nl >= nloops) break;
  }

  lua_pop(L, 1);
  printf(" ------------ parse_table EXIT, nl = %i \n",nl);
  return 0;
}

int getIntField(lua_State* L, const char* key) {
    lua_pushstring(L, key);
    lua_gettable(L, -2);  // get table[key]
 
    int result = (int)lua_tonumber(L, -1);
    lua_pop(L, 1);  // remove number from stack
    return result;
}


std::string getStringField(lua_State* L, const char* key) {
    lua_pushstring(L, key);
    lua_gettable(L, -2);  // get table[key]
 
    std::string result = lua_tostring(L, -1);
    lua_pop(L, 1);  // remove string from stack
    return result;
}

//-----------------------------------------------------------------------------
int main( int argc, char *argv[] ) {

  lua_State* L = luaL_newstate(); 
  luaL_openlibs(L);
  
  int rc(0);
                                        // push _ENV
  lua_pushglobaltable(L);

  if (! lua_istable(L,-1)) {
    printf(" not a table! RETURN\n");
  }
  else {
    rc = parse_table(L);
  }
  
  lua_close(L);

  return rc;
}

// int main() {
//     lua_State* L = luaL_newstate(); 
 
//     luaL_loadfile(L, "window.lua");
//     lua_pcall    (L, 0, 0, 0);
//     lua_getglobal(L, "window");
 
//     int width         = getIntField   (L, "width" );
//     int height        = getIntField   (L, "height");
//     std::string title = getStringField(L, "title" );
 
//     std::cout << "Width = " << width << std::endl;
//     std::cout << "Height = " << height << std::endl;
//     std::cout << "Title = " << title << std::endl;
 
// }

