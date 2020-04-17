DIR=build_dir

all: libexception.so main

mkdir:
	mkdir -p $(DIR)/exception_lib

make_lib_more_than_4k.o: mkdir
	g++ -O0 -fno-inline -Wall -g -fPIC -c -o $(DIR)/exception_lib/make_lib_more_than_4k.o exception_lib/make_lib_more_than_4k.cpp

call_exception_func.o: mkdir
	g++ -O0 -fno-inline -Wall -g -fPIC -c -o $(DIR)/exception_lib/call_exception_func.o exception_lib/call_exception_func.cpp

exception_fun.o: mkdir
	g++ -O0 -fno-inline -Wall -g -fPIC -c -o $(DIR)/exception_lib/exception_fun.o exception_lib/exception_fun.cpp

libexception.so: mkdir make_lib_more_than_4k.o call_exception_func.o exception_fun.o
	g++ -o $(DIR)/libexception.so \
	-Wl,-h -Wl,libexception.so -shared \
	-Wl,--start-group \
	$(DIR)/exception_lib/make_lib_more_than_4k.o \
	$(DIR)/exception_lib/call_exception_func.o \
	$(DIR)/exception_lib/exception_fun.o  \
	-Wl,-Bstatic  -Wl,-Bdynamic \
	-Wl,--end-group -g -fPIC

main_dlopen.o: mkdir main_dlopen.cpp
	g++ -O0 -fno-inline -Wall -g -fPIC -c -o "$(DIR)/main_dlopen.o" "main_dlopen.cpp"

main: mkdir main_dlopen.o 
	g++  -Wl,-rpath -Wl,"$(DIR)" -o "$(DIR)/main" -Wl,--start-group "$(DIR)/main_dlopen.o" -Wl,-Bstatic  -Wl,-Bdynamic -ldl -Wl,--end-group -g -fPIC

clean:
	rm -rf $(DIR)/

upx_lib:
	./upx-3.9.6 $(DIR)/libexception.so

revert_upx_lib:
	./upx-3.9.6 -d $(DIR)/libexception.so

run:
	env LD_LIBRARY_PATH=$PWD/$(DIR) $(DIR)/main;
