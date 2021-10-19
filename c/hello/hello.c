#include <stdio.h>
#include <time.h>
#include <sys/time.h>


int main() {
    // For timing
    //double time_spent = 0.0;
    //clock_t begin = clock();
    //struct timeval startTick, endTick;
    struct timeval start, end;
    gettimeofday(&start, NULL);

    // We don't need any other output, than the running time
    //printf("Hello World!\n");

    // Get end time
    //clock_t endTick = clock();
    //time_spent += (double)(endTick - beginTick) / CLOCKS_PER_SEC;
    //printf("Running Time: %f", time_spent);
    gettimeofday(&end, NULL);

    long seconds = (end.tv_sec - start.tv_sec);
    long micros = ((seconds * 1000000) + end.tv_usec) - (start.tv_usec);
 
    printf("%ld %ld\n", seconds, micros * 1000);
    return 0;
}