# GraalVMHelloBenchmark

Simple Benchmarking Suite to Compare the performance of GraalVM with other languages / runtimes. We will take a fairly simple task, finding primes below some threshold, and use this to create matching implemntations in C, Go & Java. We will then use these to benchamrk the runtime performance. For Java we are going to look, in particular, at the performance of OpenJDK and GraalVM CE Native Image.

## Results of Benchmarking - Sneak Preview

We go into the detail of the what and how we carry out this benchmark, but it might be nice to show the results here, first. The benhmark was run on an Oracle Cloud Infrastructure (OCI) linux Virtual Machine, with 1 core and 16 GB of RAM (VM.Standard.E4.Flex), running Oracle Linux 7. 

TODO Insert graphs here

As you can see from these, for our relatively simple benchmark GraalVM Native Image allows Java programs to approach C-like performance in startup time.

TODO - Say something about the memory consumption


## Seive of Eratosthenes

A long, long time ago a Greek guy called Eratosthenes, who was actually born in what is Modern day Libya around 276 BCE, came up with an efficient way of calculating the primes, those numbers only divisible by themselves and also by the number 1. He was also the first person to calculate the circumfrence of the Earth (amazingly it turns out he was accurate to within 2.4% and +0.8% of the measurements we have today fo this [the difference in the accuracies is down to uncertainty around exaxctly how long the Greek unit of measurement, the Satdia, was]).

## How to actually calculate the Primes less than N

We are going to use the algorith laid out by Eratosthenes as our example workload. And why not? They key to the utility of this algorithm is that it is easier to count & mutiply than to calculate the divisors of a number. The algorithm is explained, far better than I ever could, on [Here - Wikipedia](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).

The following is the pseudo code for the algorithm that we will use - again this is taken from [Here - Wikipedia](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) 

```
algorithm Sieve of Eratosthenes is
    input: an integer n > 1.
    output: all prime numbers from 2 through n.

    let A be an array of Boolean values, indexed by integers 2 to n,
    initially all set to true.
    
    for i = 2, 3, 4, ..., not exceeding √n do
        if A[i] is true
            for j = i2, i2+i, i2+2i, i2+3i, ..., not exceeding n do
                A[j] := false

    return all i such that A[i] is true.
```

## The Languages / Runtimes We Will Benchmark

We are going to benchmark the following suite of 

## What We Will Benchmark

## Building the Code

## Running the Benchmark

