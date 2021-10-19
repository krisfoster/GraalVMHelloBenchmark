#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <sys/time.h>

int main(int argc, char **argv)
{
    // For timing
    //double time_spent = 0.0;
    //clock_t begin = clock();
    //struct timeval startTick, endTick;
    struct timeval start, end;
    gettimeofday(&start, NULL);

    // vars
    int number,i,j;
    bool display = false;
    // get upper limit from command line args
    number = atoi(argv[1]);
    // if a second arg is present, then switch on display of all found prime values
    if (argc >= 3) {
        display = true;
    }

    int primes[number+1];

    // Populating array with naturals numbers
    for(i = 2; i<=number; i++) {
        primes[i] = i;
    }

    // Find our primes using the Sieve
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
    
    // Find the last prime & display all found primes (if asked for)
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
    
    printf("%6d ", primes[last]);

    // Get end time
    //clock_t endTick = clock();
    //time_spent += (double)(endTick - beginTick) / CLOCKS_PER_SEC;
    //printf("Running Time: %f", time_spent);
    gettimeofday(&end, NULL);

    long seconds = (end.tv_sec - start.tv_sec);
    long micros = ((seconds * 1000000) + end.tv_usec) - (start.tv_usec);
 
    printf("%ld %ld\n", seconds, micros);

    return 0;
}