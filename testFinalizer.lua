local ffi = require("ffi")

ffi.cdef [[
    void free (void* ptr);
    void* malloc (size_t size);
    void* realloc (void* ptr, size_t size);
]]

local mt = {

  __gc = function(self) 
      
      print("finalizer", self.p1, self.p2)             
      if self.p1 ~= NULL then
        ffi.C.free(self.p1)        
      end
      
      if self.p2 ~= NULL then
        ffi.C.free(self.p2)
      end
  end,
}

ffi.cdef [[
    typedef struct { 
        void * p1; 
        void * p2;   
    } finalizer_st;
]]

local finalizer = ffi.metatype("finalizer_st", mt)
local f = finalizer()
f.p1 = ffi.C.realloc(f.p1, 32)
f.p1 = ffi.C.realloc(f.p1, 64)

f.p2 = ffi.C.realloc(f.p2, 12)
f.p2 = ffi.C.realloc(f.p2, 32)

print("main loop", f.p1, f.p2)
