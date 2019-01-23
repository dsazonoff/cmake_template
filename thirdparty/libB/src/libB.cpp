#include "libB/libB.h"

#include <iostream>

void libB::foo()
{
    std::cout << __FUNCTION__ << std::endl;
}
