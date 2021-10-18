package com.example.app;

import static org.junit.Assert.assertTrue;
import org.junit.Assert;
import org.junit.Test;

/**
 * Unit test for simple App.
 */
public class AppTest 
{
    private static final int[] knownPrimes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43,
                                                47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97};
    /**
     * Rigorous Test :-)
     */
    @Test
    public void findPrimesBelow100()
    {
        Assert.assertArrayEquals(knownPrimes, App.findPrimes(100));
    }
}
