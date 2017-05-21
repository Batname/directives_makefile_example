#include "Human.hpp"

#include <iostream>

using namespace std;

Human::Human(int age) : Age(age) {}

void Human::PrintAge()
{
    cout << "Human age is: " << Age << endl;
}