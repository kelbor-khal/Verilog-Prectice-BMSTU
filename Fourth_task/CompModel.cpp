#include <iostream>

#define IN_VALUE 4

int main()
{
    int a = 2, b =3, output_val = 0;
    int input_arr [IN_VALUE] = {2, 3, 4, 5};

    std::cout << "Coefficient`s: a = 2, b = 3 \n"; 

    for ( int i = 0; i < IN_VALUE; i ++ )
    {
        std::cout << "input value: " << input_arr [i]
                  << ", delay value: " << output_val << '\n';
        output_val = output_val * a + input_arr [i] * b;
        std::cout << "***** output value: " << output_val
                  << " *****" <<'\n';          
    }
    return 0;
}