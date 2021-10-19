package com.example.app;

import java.util.Arrays;

/**
 * Command line driver - takes a single parameter which is a number that is the
 * upper limit of to search for primes below
 *
 */
public class App 
{

    /**
     * Finds the primes - use the sieve of Eratosthenes>
     * https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
     *
     * Algorithm below:
     * ```
     *   algorithm Sieve of Eratosthenes is
     *       input: an integer n > 1.
     *       output: all prime numbers from 2 through n.
     *
     *       let A be an array of Boolean values, indexed by integers 2 to n,
     *       initially all set to true.
     *       
     *       for i = 2, 3, 4, ..., not exceeding √n do
     *           if A[i] is true
     *               for j = i2, i2+i, i2+2i, i2+3i, ..., not exceeding n do
     *                   A[j] := false
     *
     *       return all i such that A[i] is true.
     *   ```
     * @param upper The upper limit to search below
     */
    public static final int[] findPrimes(final int upper) {
        // This will hold a flag for each number, indicating whether or not it
        // is prime. True indicates prime, false does not
        boolean primes[] = new boolean[upper + 1];

        // Set all flags to true - we are going to assume everything is prime, till we find out 
        // that it isn't. All numbers are going to be either prime or compound (a mutiple of primes)
        for (int i=0; i<=upper; i++) {
            primes[i] = true;
        }

        // Loop through the numbers, starting at 2, upto sqrt(upper)
        for (int j=2; j*j <= upper; j++) {
            // Find all the mutiples of the current number and mark them as not prime
            // But we can skip any that arent prime, becasue any integer that isn't prime will have
            // prime factors
            if (primes[j] == true) {
                for (int k=j*j; k<upper; k+=j) {
                    primes[k] = false;
                }
            }
        }

        // Filter out all the false ones..... what we have left are primes
        final int[] foundU = new int[upper + 1];
        int cnt = 0;
        for (int i=2; i<upper; i++) {
            if (primes[i] == true){
                foundU[cnt] = i;
                cnt++;
            }
        }
        // resize the array
        int[] found = new int[cnt];

        for (int i=0; i<cnt; i++) {
            found[i] = foundU[i];
        }

        return found;
    }

    public static void display(final int[] primes) {
        for (int i=0; i< primes.length; i++) {
            System.out.print(primes[i]);
        }
        System.out.println(".");
    }

    public static void main(String[] args )
    {
        final long startTime = System.nanoTime();

        boolean display = args.length >= 2 ? Boolean.parseBoolean(args[1]) : false;
        int[] primes = findPrimes(Integer.parseInt(args[0]));
        int last = primes[primes.length - 1];
        // 
        //System.out.println("last prime " + last);
        if (display) {
            display(primes);
        }
        final long endTime = System.nanoTime();
        System.out.println(endTime - startTime);
    }
}
