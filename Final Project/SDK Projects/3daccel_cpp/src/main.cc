/*
 * Empty C++ Application
 */

//============================================================================
// Name        : 3Dproject_cpp.cpp
// Author      :
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>
#include "chu_init.h"

using namespace std;

char x = ('h');

int main()
{
	ready();
	set_frequency();
	set_baud_rate(9600);
	set_mode(0,0);
	disp(x);

	cout << "!!!Hello World!!!" << endl; // prints !!!Hello World!!!
	return 0;
}
