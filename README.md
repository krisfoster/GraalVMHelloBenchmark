# GraalVM Runtime Performance Against Other Languages / Runtimes Benchmark

A simple benchmarking suite to compare the performance of GraalVM with other languages / runtimes. We will take a fairly simple task, finding primes below some threshold, and use this to create similar implementations in C, Go, and Java. Then we will benchmark the performance of these, looking at total running time and max memory usage (RSS).

For Java we are going to look, in particular, at the performance of OpenJDK and Oracle GraalVM Native Image.

Let's get started.

## Results of Benchmarking - Sneak Preview

We will shortly go into the detail of the what and the how, but it might be nice to show the results here, first. The benchmark was run on an Oracle Cloud Infrastructure (OCI) linux Virtual Machine, with 1 core and 16 GB of RAM (VM.Standard.E4.Flex), running Oracle Linux 7. 

![Comparing Platforms - Running Time in milliseconds](sieve-platform-perf-running-time.svg "Comparing Platforms - Running Time in milliseconds")

![Comparing Platforms - RSS in MBs](sieve-platform-perf-rss.svg "Comparing Platforms - RSS in MBs")

As you can see from these, for our relatively simple benchmark GraalVM Native Image enables Java programs to approach C-like performance in startup time and big reductions in memory usage.


## Sieve of Eratosthenes

A long, long time ago a Greek guy called Eratosthenes, who was actually born in what is modern day Libya around 276 BCE, came up with an efficient way of calculating the primes, those numbers only divisible by themselves and also by the number 1. 

He was also the first person to calculate the circumference of the Earth. Amazingly it turns out he was accurate to within 2.4% and +0.8% of the measurements we have for the circumference of the Earth today (the difference in the accuracies is down to uncertainty around exactly how long the Greek unit of measurement, the _Stadion_, was)!

### How to actually calculate the Primes less than N

We are going to use the algorithm laid out by Eratosthenes as our example workload.  They key to the utility of this algorithm is that it is easier to count and multiply than to calculate the divisors of a number. The algorithm is explained, far better than I ever could, on [Wikipedia](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).

The following is the pseudo code for the algorithm that we are going to use - again this is taken from [Wikipedia](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes):

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

## The Languages/Runtimes We Will Benchmark

For the purposes of this benchmark we are going to use languages and runtimes that are known for their efficiency and compare these to Java, and in particular to GraalVM Native Image. (For those that don't already know, GraalVM Native Image takes a Java application and generates a fast, efficient native executable from it.)

So the languages/runtimes used are:

1. C
2. Go
3. Java 17 (Open JDK)
4. Oracle GraalVM Native Image, for JDK 17

## What We Will Benchmark

What we are interested in are:

1. Total running time of the application
2. Resident Set Size (the portion of memory occupied by a process that is held in main memory)

Our benchmark, for each language/runtime, will be run against the same maximum upper number (100,000 was chosen for this, rather arbitrarily) 100 times.

## Building the Code

You will need:
* a recent version of gcc 
* Go
* OpenJDK 17
* Oracle GraalVM for JDK17

### Note on the Need to Switch Between Java Versions

I'm using Oracle linux 7, so I have used the package manager to install GraalVM EE & OpenJDK 17. In my build scripts you can see a hack that lets me switch between these alternatives when I need to do the build for OpenJDK. Please remember that you may need to switch back, so check what version of Java you are left with as a your default.

## Running the Benchmark

Build everything first:

```bash
$ make build
```

Run the benchmarks:

```bash
$ make bench
```

You can find the results in a file named _perf-sieve-rss-all.dat_. I've included the contents of a recent run on my machine below, so that you can see what this looks like:

```
C RSS 2183.24
C CLK 0
C CLK_AGGR 0m0.200s
Go RSS 1849.36
Go CLK 0
Go CLK_AGGR 0m0.762s
Native Image RSS 8316.14
Native Image CLK 0
Native Image CLK_AGGR 0m0.273s
Java RSS 72197.8
Java CLK 0.337933
Java CLK_AGGR 0m10.826s
```

To explain the format of the rows:

* `C RSS` : this is the average RSS of the C implementation
* `C CLK_AGGR` : The aggregate time for 100 runs of the C code. Divide by 100 to get the run time
* `Go RSS` : this is the average RSS of the Go implementation
* `Go CLK_AGGR` : The aggregate time for 100 runs of the Go code. Divide by 100 to get the run time
* `Native Image RSS` : this is the average RSS of the Native Image implementation
* `Native Image CLK_AGGR` : The aggregate time for 100 runs of the Native Image code. Divide by 100 to get the run time
* `Java RSS` : this is the average RSS of the Java implementation
* `Java CLK_AGGR` : The aggregate time for 100 runs of the Java code. Divide by 100 to get the run time

Note: We need to do 100 runs and do the timing in aggregate as for the C, Go, and Native Image code the run times are very small and can not be accurately measured with `time`. There is timing code within the implementations, but these may not allow for the time that any code that runs prior to the main method uses (say, in the Go / Native Image executables).