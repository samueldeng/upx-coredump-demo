#include "exception_fun.hpp"

void func_throw_exception()
{
    std::cout << "func_throw_exception(): called" << std::endl;
    throw std::logic_error("foo");
}

