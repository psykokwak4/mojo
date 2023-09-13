struct UniquePointer:
    var ptr: Int
    
    fn __init__(inout self, ptr: Int):
        self.ptr = ptr

    fn __moveinit__(inout self, owned existing: Self):
        self.ptr = existing.ptr

    fn __del__(owned self):
        self.ptr = 0