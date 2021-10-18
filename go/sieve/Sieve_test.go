package main

import (
	"testing"
)

func TestSieveFirstUnderHundredPrimes(t *testing.T) {
	primes := [25]int{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43,
		47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97}
	myPrimes := sieve(100)
	if len(primes) != len(myPrimes) {
		t.Fatalf(`sieve(100) = only returns %d`, len(primes))
	}
	for i := 0; i < len(primes); i++ {
		if primes[i] != myPrimes[i] {
			t.Fatalf(`prime[%d] != myprimes[%d]`, i, i)
		}
	}
}
