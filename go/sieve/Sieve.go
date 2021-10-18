package main

/**
 * This implemenation is taken from:
 * https://www.socketloop.com/tutorials/golang-sieve-of-eratosthenes-algorithm
 */

import (
	"flag"
	"fmt"
	"os"
)

var (
	displayFlag *bool
	upper       *int
)

func displayPrime(primes []int, displayFlag bool) {
	for i := 0; i < len(primes); i++ {
		if displayFlag {
			fmt.Printf("%d ", primes[i])
		}
	}
	if displayFlag {
		fmt.Println()
	}
	fmt.Fprintf(os.Stderr, "Last Prime: %d\n", primes[len(primes)-1])
}

func sieve(num int) []int {

	// do not use
	// prime := [num+1]bool
	// will cause : non-constant array bound num + 1 error

	// an array of boolean - the idiomatic way
	primes := make([]bool, num+1)
	foundPrimes := make([]int, num)

	// initialize everything with false first(not crossed)
	for i := 0; i < num+1; i++ {
		primes[i] = true
	}

	for i := 2; i*i <= num; i++ {
		if primes[i] == true {
			for j := i * 2; j <= num; j += i {
				primes[j] = false // cross
			}
		}
	}

	cnt := 0
	for i := 2; i < len(primes); i++ {
		if primes[i] == true {
			foundPrimes[cnt] = i
			cnt++
		}
	}

	return foundPrimes[0:cnt]
}

func init() {
	displayFlag = flag.Bool("display", false, "Used to turn on displaying found primes")
	upper = flag.Int("upper", 1000000, "Upper limit to look for primes below")
}

func main() {
	flag.Parse()
	primes := sieve(*upper)
	displayPrime(primes, *displayFlag)
}
