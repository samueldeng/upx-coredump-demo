# upx-coredump-demo
The sample code of reproduce upx-ed so lib coredump.

## enviroment:
OS: `CentOS Linux release 7.5.1804 (Core)`

Kernel: `uname: Linux cppdev 3.10.0-862.14.4.el7.x86_64 #1 SMP Wed Sep 26 15:12:11 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux`

GCC(Lib): `Default C++ Package in Yum Repo`


## how to reproduce this issue
`make clean` clean all temp files

`make all` compile libexception.so and main

`make upx_lib` use upx to compress libexception.so

`make run` run the main(libexception is compressed.), **it coredumped!!**.

> Note that: It seems that the C++ exception cannot be catched by `extern "C" int try_wrapper(int a)` in `call_exception_fun.cpp`

`make revert_upx_lib` upx -d libexception.so to un-compress

`make run`
> Note that: It seems that C++ exception was catched again by `extern "C" int try_wrapper(int a)` in `call_exception_fun.cpp`

## Online Docker to produce this issue.
[GitHub Action](https://github.com/samueldeng/upx-coredump-demo/actions)

The Coredump line:
https://github.com/samueldeng/upx-coredump-demo/runs/594821663?check_suite_focus=true#step:8:19

## More Weird Tips:
if change `Makefile` **line 21** and **line 23**(which means that make **make_lib_more_than_4k.o** at last.)
the UPX works fine.

Orginal Makefile:
```
libexception.so: mkdir make_lib_more_than_4k.o call_exception_func.o exception_fun.o
	g++ -o $(DIR)/libexception.so \
	-Wl,-h -Wl,libexception.so -shared \
	-Wl,--start-group \
	$(DIR)/exception_lib/make_lib_more_than_4k.o \
	$(DIR)/exception_lib/call_exception_func.o \
	$(DIR)/exception_lib/exception_fun.o  \
	-Wl,-Bstatic  -Wl,-Bdynamic \
	-Wl,--end-group -g -fPIC
```

After Modificatoin:
```
libexception.so: mkdir make_lib_more_than_4k.o call_exception_func.o exception_fun.o
	g++ -o $(DIR)/libexception.so \
	-Wl,-h -Wl,libexception.so -shared \
	-Wl,--start-group \
	$(DIR)/exception_lib/call_exception_func.o \
	$(DIR)/exception_lib/exception_fun.o  \
    $(DIR)/exception_lib/make_lib_more_than_4k.o \
	-Wl,-Bstatic  -Wl,-Bdynamic \
	-Wl,--end-group -g -fPIC
```

> Note that the make_lib_more_than_4k.o is a useless object file. So it would be OK whatever UPX truncated this file. 

> But If put the try/exception object file in the last the DLL truncated by UPX would not works.