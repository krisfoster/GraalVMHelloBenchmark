#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main(int argc, char **argv)
{
    int number,i,j;
    bool display = false;
    number = atoi(argv[1]);
    if (argc >= 3) {
        display = true;
    }

    int primes[number+1];

    // Populating array with naturals numbers
    for(i = 2; i<=number; i++) {
        primes[i] = i;
    }

    i = 2;
    while ((i*i) <= number)
    {
        if (primes[i] != 0)
        {
            for(j=2; j<number; j++)
            {
                if (primes[i]*j > number)
                    break;
                else
                    // Instead of deleteing, making elemnets 0
                    primes[primes[i]*j]=0;
            }
        }
        i++;
    }
    
    int last = 0;
    for(i = 2; i<=number; i++)
    {
        //If number is not 0 then it is prime
        if (primes[i]!=0) {
            if (display) {
                printf("%4d,",primes[i]);
            }
            last = i;
        }
    }

    if (display) {
        printf("\n");
    }
    
    fprintf(stderr, "%6d\n", primes[last]);

    return 0;
}