#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

int main(int argc, char **argv) {

    // For timing
    struct timespec tstart, tend;
    clock_gettime(CLOCK_MONOTONIC, &tstart);

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
    int foundPrimes[number+1];

    // Populating array with naturals numbers
    for(i = 2; i<=number; i++) {
        primes[i] = i;
    }

    // Find our primes using the Sieve
    i = 2;
    while ((i*i) <= number) {
        if (primes[i] != 0) {
            for(j=2; j<number; j++) {
                if (primes[i]*j > number) {
                    break;
                }
                else {
                    // Instead of deleteing, making elemnets 0
                    primes[primes[i]*j]=0;
                }
            }
        }
        i++;
    }
    
    // Find the last prime & display all found primes (if asked for)
    int cnt = 0;
    for(i = 2; i<=number; i++) {
        //If number is not 0 then it is prime
        if (primes[i]!=0) {
            if (display) {
                printf("%4d,",primes[i]);
            }
            // Save the actual primes to our foundPrimes array
            // cnt - 1 will give use the last element
            foundPrimes[cnt] = i;
            cnt++;
        }
    }

    if (display) {
        printf("\n");
    }
    
    // Stop timing
    clock_gettime(CLOCK_MONOTONIC, &tend);

    // Time of run in nanoseconds - output to STDOUT
    printf("[%6d] ", foundPrimes[cnt - 1]);
    printf("%12llu\n",
           ((unsigned long long)1.0e9*tend.tv_sec + tend.tv_nsec) - 
           ((unsigned long long)1.0e9*tstart.tv_sec + tstart.tv_nsec));

    return 0;
}