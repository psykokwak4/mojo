from pkg import MyPair, UniquePointer

fn take_ptr(owned p: UniquePointer):
    print("take_ptr")
    print("p.ptr")

fn use_ptr(borrowed p: UniquePointer):
    print("use_ptr")
    print(p.ptr)

fn work_with_unique_ptrs():
    let p = UniquePointer(100)
    use_ptr(p)
    take_ptr(p^)

fn main():
    let p = MyPair(1,2)
    p.dump()

    work_with_unique_ptrs()