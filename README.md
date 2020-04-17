# upx-coredump-demo
The sample code of reproduce upx-ed so lib coredump.

## enviroment:
`CentOS Linux release 7.5.1804 (Core)`
`uname: Linux cppdev 3.10.0-862.14.4.el7.x86_64 #1 SMP Wed Sep 26 15:12:11 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux`

## reproduce the coredump
`make clean`
`make all`
`make upx_lib`
`make run`
`make revert_upx_lib`
`make run`

## some tips:
if change Makefile line 21 and line 23(which means that make 4k.o at last.)
it would be OK.

