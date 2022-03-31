#include <iostream>
#include <stdio.h>

# define AMOUT_COEFF 3
# define AMOUT_MEMBR 6

int main()
{
    int result, postion_membr = 0;
    int coeff [AMOUT_COEFF] = { 1, 2, 3 };
    int in_membr [AMOUT_MEMBR] = { 1, 2, 3, 4, 5, 6};

    std::cout << '\n' << "Coefficient's: " << coeff [0] << " "
                                           << coeff [1] << " " 
                                           << coeff [2] << '\n';

    for ( int i = postion_membr ; i < AMOUT_MEMBR; i ++ )
    {
        result = 0;
        if ( postion_membr == AMOUT_MEMBR - 2 )
            break;
        else
        {   
            for ( int j = 0 ; j < AMOUT_COEFF ; j ++ )
            {
                int buff;

                buff = coeff [j] * in_membr [postion_membr + AMOUT_COEFF - 1 - j];
                std::cout << in_membr [postion_membr + AMOUT_COEFF - 1 - j] << " "; 
                result = result + buff;
            }

            std::cout << '\n' << " Output result: " << result << '\n';
            postion_membr ++;
        }
    }

    return 0;
}