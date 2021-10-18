.PHONY: bench

.EXPORT_ALL_VARIABLES:

UPPER=10000000

build:
	cd c/sieve && $(MAKE) clean
	cd c/sieve && $(MAKE)
	cd java/sieve && mvn clean package
	cd java/sieve && mvn -Pnative -DskipTests package
	cd go/sieve && go clean
	cd go/sieve && go build Sieve.go

bench:
	@echo "Benchmarking"
	@echo "Cleaning up old perf files, from previous runs"
	rm perf-*.dat
	@echo "Running Go benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./go/sieve/Sieve -upper $$UPPER ; } 2>> perf-go.dat; done
	@echo "Running Java benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java -cp java/sieve/target/my-app-1.0-SNAPSHOT.jar com.example.app.App $$UPPER ; } 2>> perf-java.dat; done
	@echo "Running Native Image benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java/sieve/target/my-app $$UPPER ; } 2>> perf-native.dat; done
	@echo "Running C benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./c/sieve/prog $$UPPER  ; } 2>> perf-c.dat; done

avg:
	@echo "Generating averages"
	rm perf-all.dat
	awk '{ total += $2; count++ } END { print total/count }' perf-c.dat
