#include <iostream>
#include <exception>
#include <stdexcept>
#include <dlfcn.h>

int main()
{
    int (*func_ptr)(int);

    void* lib_try_wrapper = dlopen("libexception.so", RTLD_NOW);
    if (!lib_try_wrapper)
    {
        std::cerr << "cannot load library: " << dlerror() << std::endl;
        return 1;
    }
    dlerror();


    func_ptr = (int(*)(int)) dlsym(lib_try_wrapper, "try_wrapper");

    const char* dlsym_error = dlerror();
    if (dlsym_error || !func_ptr)
    {
        std::cerr << "cannot load symbol SessionCreator: " << dlsym_error << std::endl;
        return 1;
    }


    (*func_ptr)(4);

    return 0;
}
