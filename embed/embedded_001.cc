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

int main() {
    lua_State* L = luaL_newstate(); 
                                        // load file, apparently interpret it and load the table
    luaL_loadfile(L, "window.lua");
    lua_pcall    (L, 0, 0, 0);
    lua_getglobal(L, "window");
 
    int width         = getIntField   (L, "width" );
    int height        = getIntField   (L, "height");
    std::string title = getStringField(L, "title" );
 
    std::cout << "Width = " << width << std::endl;
    std::cout << "Height = " << height << std::endl;
    std::cout << "Title = " << title << std::endl;
 
    lua_close(L);
}

