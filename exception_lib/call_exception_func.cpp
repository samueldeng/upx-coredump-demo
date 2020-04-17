#include "exception_fun.hpp"
#include <iostream>
#include <exception>
#include <stdexcept>

extern "C" int try_wrapper(int a)
{
    try
    {
        func_throw_exception();
    }
    catch (...)
    {
        std::cout << "main(): catched exception" << std::endl;
    }
    return 0;
}
