#include "libA/libA.h"

#include <iostream>

#include "libB/libB.h"

void libA::foo()
{
    std::cout << __FUNCTION__ << std::endl;
    libB::foo();
}
