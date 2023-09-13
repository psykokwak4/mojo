#### Issue
Mojo attempts to load struct from stale (?) mojopkg cache

#### Repro steps

1. Create a folder with name `package` which contains 2 structs with `from .<filename> import *` syntax
2. Create a `main.mojo` imports and uses struct from package `package`
3. Run `main.mojo`, outputs
```
mypair
use_ptr
100
take_ptr
p.ptr
```
4. Package `package` via `mojo package package -o package.mojopkg`
5. Run `mojo main.mojo` which outputs
```
mypair
use_ptr
100
take_ptr
p.ptr
```
6. Delete package.mojopkg, and rename folder `package` to folder `pkg`
7. Run `mojo main.mojo`, which errors as expected
```
main.mojo:1:6: error: unable to locate module 'package'
from package import MyPair, UniquePointer
     ^
mojo: error: failed to parse the provided Mojo
```
8. Fix the package name to `pkg` (then switch back to `package` back and forth a few times) and expect segfault that mojo attempts to find struct from cached (?) mojopkg
```
$ mojo main.mojo
Included from pkg/__init__.mojo:2:
pkg/s2.mojo:1:1: error: unable to locate module 'package'
struct UniquePointer:
^
@"$package"::@"$s2"::@UniquePointer
mojo: /__w/modular/modular/KGEN/lib/MojoParser/DeclResolver.h:160: M::KGEN::LIT::ASTDecl &M::KGEN::LIT::DeclResolver::getDeclForTypeSymbol(mlir::SymbolRefAttr) const: Assertion `it != declForTypeSymbol.end() && "Unknown decl symbol!"' failed.
[20279:20279:20230913,203250.691766:ERROR file_io_posix.cc:144] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)
[20279:20279:20230913,203250.691835:ERROR file_io_posix.cc:144] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq: No such file or directory (2)
Please submit a bug report to https://github.com/modularml/mojo/issues and include the crash backtrace along with all the relevant source codes.
Stack dump:
0.      Program arguments: mojo main.mojo
1.      Crash resolving decl body at loc("main.mojo":11:1)
    >> fn work_with_unique_ptrs():
       ^..........................
    >>     let p = UniquePointer(100)
       ..............................<
2.      Crash parsing statement at loc("main.mojo":12:5)
    >>     let p = UniquePointer(100)
           ^.........................<
 #0 0x000055c4e9206957 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x5bb957)
 #1 0x000055c4e920452e (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x5b952e)
 #2 0x000055c4e920702f (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x5bc02f)
 #3 0x00007f548da7e420 __restore_rt (/lib/x86_64-linux-gnu/libpthread.so.0+0x14420)
 #4 0x00007f548d50700b raise /build/glibc-SzIz7B/glibc-2.31/signal/../sysdeps/unix/sysv/linux/raise.c:51:1
 #5 0x00007f548d4e6859 abort /build/glibc-SzIz7B/glibc-2.31/stdlib/abort.c:81:7
 #6 0x00007f548d4e6729 get_sysdep_segment_value /build/glibc-SzIz7B/glibc-2.31/intl/loadmsgcat.c:509:8
 #7 0x00007f548d4e6729 _nl_load_domain /build/glibc-SzIz7B/glibc-2.31/intl/loadmsgcat.c:970:34
 #8 0x00007f548d4f7fd6 (/lib/x86_64-linux-gnu/libc.so.6+0x33fd6)
 #9 0x000055c4e95d11bd (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x9861bd)
#10 0x000055c4e95d1006 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x986006)
#11 0x000055c4e95d1357 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x986357)
#12 0x000055c4e95d1416 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x986416)
#13 0x000055c4e963e13b (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x9f313b)
#14 0x000055c4e9635d04 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x9ead04)
#15 0x000055c4e9635baf (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x9eabaf)
#16 0x000055c4e95e24e4 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x9974e4)
#17 0x000055c4e95da8ee (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x98f8ee)
#18 0x000055c4e95d8d19 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x98dd19)
#19 0x000055c4e962c929 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x9e1929)
#20 0x000055c4e962d2ab (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x9e22ab)
#21 0x000055c4e91d14ff (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x5864ff)
#22 0x000055c4e91b8a50 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x56da50)
#23 0x000055c4e91d0460 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x585460)
#24 0x000055c4e91b2b95 (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x567b95)
#25 0x00007f548d4e8083 __libc_start_main /build/glibc-SzIz7B/glibc-2.31/csu/../csu/libc-start.c:342:3
#26 0x000055c4e91b212e (/home/codespace/.modular/pkg/packages.modular.com_mojo/bin/mojo+0x56712e)
Aborted (core dumped)
```
