// -- window.lua
// window = {
//     width = 640,
//     height = 480,
//     title = "Test window"
// }

#include <iostream>
#include <string>
 
extern "C" {
# include "lua.h"
# include "lauxlib.h"
# include "lualib.h"
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
int parse_table(lua_State* L) {

  printf(" ------------ parse_table ENTER\n");

  int nloops = 20, nl(0);
  
  while (lua_next(L,-2)) {
//------------------------------------------------------------------------------
// figure out types of the key and teh value
//-----------------------------------------------------------------------------
    std::string key_type, val_type;

    key_type = lua_typename(L,lua_type(L,-2));
    val_type = lua_typename(L,lua_type(L,-1));
      
    printf("element: key:%s , val:%s\n",key_type.data(),val_type.data());
//-----------------------------------------------------------------------------    
    if (lua_isnumber(L,-2)) {
      //      int i = (int) lua_tonumber(L,-2);
      float i = lua_tonumber(L,-2);
      printf("number key: %.0f \n",i);
    }
    else if (lua_isstring(L,-2)) {
      std::string key = lua_tostring(L,-2);
      printf("text key: %s \n",key.data());
    }
    
    if (lua_isnumber(L,-1)) {
      float val = lua_tonumber( L,-1);
      printf("number val: %f \n",val);
    }
    else if (lua_isstring(L,-1)) {
      std::string val = lua_tostring(L,-1);
      printf("text val: %s \n",val.data());
    }
    else if (lua_istable(L,-1)) {
      lua_pushvalue(L,-1);
      lua_pushnil(L);                 // first key 
      parse_table(L);
    }

    lua_pop(L, 1);
    nl++;
    if (nl >= nloops) break;
  }

  lua_pop(L, 1);
  printf(" ------------ parse_table EXIT, nl = %i \n",nl);
  return 0;
}

//-----------------------------------------------------------------------------
int main( int argc, char *argv[] ) {

  if (argc != 2) {
    printf("wrong number of arguments, EXIT    :%i\n",argc);
    return -1;
  }
  std::string fn = argv[1];

  //  printf("0010\n");
  lua_State* L = luaL_newstate(); 
 
  //  printf("0020\n");
  int rc(0);

  //  rc = luaL_dostring(L, "require \'new\'");
  // rc = luaL_dofile(L, fn.data());

  rc = luaL_loadfile(L, fn.data());

  printf("0020 rc = %i \n",rc);

  rc = lua_pcall(L, 0, 0, 0);

  std::string msg = lua_tostring(L,0);
  printf("0021 rc = %i msg=%s\n",rc,msg.data());


  rc = lua_getglobal(L, "physics");

  printf("0030 rc=%i\n",rc);

  

  lua_pushnil(L);                 // first key 

  //  printf("0030\n");

  rc = parse_table(L);
  
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

