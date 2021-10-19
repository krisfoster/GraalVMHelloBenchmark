.PHONY: bench

.EXPORT_ALL_VARIABLES:

UPPER_0=2000000
UPPER=10

build: build-c build-go build-java build-native

build-c:
	cd c/sieve && $(MAKE) clean
	cd c/sieve && $(MAKE)
	cd c/hello && $(MAKE) clean
	cd c/hello && $(MAKE)

build-go:
	cd go/sieve && go clean
	cd go/sieve && go build Sieve.go
	cd go/hello && go clean
	cd go/hello && go build hello.go

build-java:
	cd java/sieve && mvn clean package
	cd java/hello && mvn clean package

build-native:
	cd java/sieve && mvn -Pnative -DskipTests package
	cd java/hello && mvn -Pnative -DskipTests package

bench: bench-clean bench-c bench-go bench-native bench-java

bench-clean:
	@echo "Cleaning up old perf files, from previous runs"
	rm -f perf-*.dat

bench-c:
	@echo "Running C benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./c/sieve/prog $$UPPER  ; } 2>> perf-sieve-c.dat 1>>perf-sieve-c-internal.dat; done
	# for i in {1..100}; do { /usr/bin/time -f "%M %e" ./c/hello/prog $$UPPER  ; } 2>> perf-hello-c.dat 1>>perf-hello-c-internal.dat; done

bench-go:
	@echo "Running Go benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./go/sieve/Sieve -upper $$UPPER ; } 2>> perf-sieve-go.dat 1>>perf-sieve-go-internal.dat; done
	# for i in {1..100}; do { /usr/bin/time -f "%M %e" ./go/hello/hello -upper $$UPPER ; } 2>> perf-hello-go.dat 1>>perf-hello-go-internal.dat; done

bench-native:
	@echo "Running Native Image benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java/sieve/target/my-app $$UPPER ; } 2>> perf-sieve-native.dat 1>>perf-sieve-native-internal.dat; done
	# for i in {1..100}; do { /usr/bin/time -f "%M %e" java/hello/target/hello $$UPPER ; } 2>> perf-hello-native.dat 1>>perf-hello-native-internal.dat; done

bench-java:
	@echo "Running Java benchmark"
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java -cp java/sieve/target/my-app-1.0-SNAPSHOT.jar com.example.app.App $$UPPER ; } 2>> perf-sieve-java.dat 1>>perf-sieve-java-internal.dat; done
	# for i in {1..100}; do { /usr/bin/time -f "%M %e" java -cp java/hello/target/hello-1.0-SNAPSHOT.jar com.example.hello.App $$UPPER ; } 2>> perf-hello-java.dat 1>>perf-hello-java-internal.dat; done

avg-rss:
	@echo "Generating RSS averages"
	rm -f perf-rss-all.dat
	echo "c," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-c.dat >> perf-sieve-rss-all.dat
	echo "go," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-go.dat >> perf-sieve-rss-all.dat
	echo "native," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-native.dat >> perf-sieve-rss-all.dat
	echo "java," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-java.dat >> perf-sieve-rss-all.dat

avg-clocktime:
	@echo "Generating clocktime averages"
	rm -f perf-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-c.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-go.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-native.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-java.dat >> perf-sieve-clock-all.dat
	# internal timings
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-c-internal.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-go-internal.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-native-internal.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-java-internal.dat >> perf-sieve-clock-all.dat
