package com.example.hello;

import java.util.Arrays;

/**
 * Command line driver - takes a single parameter which is a number that is the
 * upper limit of to search for primes below
 *
 */
public class App 
{


    public static void main( String[] args )
    {
        final long startTime = System.nanoTime();
        //System.out.println( "Hello World!" );
        final long endTime = System.nanoTime();
        System.out.println(endTime - startTime);
    }
}
