.PHONY: bench

.EXPORT_ALL_VARIABLES:

UPPER=2000000

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
	rm -f perf-*.dat
	@echo "Running C benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./c/sieve/prog $$UPPER  ; } 2>> perf-c.dat 1>/dev/null; done
	@echo "Running Go benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./go/sieve/Sieve -upper $$UPPER ; } 2>> perf-go.dat 1>/dev/null; done
	@echo "Running Java benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java -cp java/sieve/target/my-app-1.0-SNAPSHOT.jar com.example.app.App $$UPPER ; } 2>> perf-java.dat 1>/dev/null; done
	@echo "Running Native Image benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java/sieve/target/my-app $$UPPER ; } 2>> perf-native.dat 1>/dev/null; done

avg-rss:
	@echo "Generating RSS averages"
	rm -f perf-rss-all.dat
	echo "c," >> perf-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-c.dat >> perf-rss-all.dat
	echo "go," >> perf-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-go.dat >> perf-rss-all.dat
	echo "native," >> perf-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-native.dat >> perf-rss-all.dat
	echo "java," >> perf-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-java.dat >> perf-rss-all.dat

avg-clocktime:
	@echo "Generating clocktime averages"
	rm -f perf-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-c.dat >> perf-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-go.dat >> perf-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-native.dat >> perf-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-java.dat >> perf-clock-all.dat
