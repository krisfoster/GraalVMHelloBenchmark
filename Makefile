.PHONY: bench

.EXPORT_ALL_VARIABLES:

RUNS=100
UPPER=100000

build: build-c build-go build-java build-native

build-c:
	cd c/sieve && $(MAKE) clean
	cd c/sieve && $(MAKE)

build-go:
	cd go/sieve && go clean
	cd go/sieve && go build Sieve.go

build-java:
	cd java/sieve && mvn clean package

build-native:
	cd java/sieve && mvn -Pnative -DskipTests package

bench: bench-clean bench-c bench-go bench-native bench-java

bench-clean:
	@echo "Cleaning up old perf files, from previous runs"
	rm -f perf-*.dat

bench-c:
	@echo "Running C benchmark"
	rm -f perf-sieve-c*
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./c/sieve/prog $$UPPER  ; } 2>> perf-sieve-rss-c.dat 1>/dev/null ; done
	echo -n "C RSS " >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-rss-c.dat >> perf-sieve-rss-all.dat
	echo -n "C CLK " >> perf-sieve-rss-all.dat && awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-rss-c.dat >> perf-sieve-rss-all.dat
	echo -n "C CLK_AGGR " >> perf-sieve-rss-all.dat && \
		TIMEFORMAT='%3lR' && \
		(time for i in {1..100}; do { ./c/sieve/prog $$UPPER ; } 1>> perf-sieve-c-internal.dat; done) 2>> perf-sieve-rss-all.dat

bench-go:
	@echo "Running Go benchmark"
	rm -f perf-sieve-go*
	for i in {1..100}; do { /usr/bin/time -f "%M %e" ./go/sieve/Sieve -upper $$UPPER ; } 2>> perf-sieve-rss-go.dat 1>/dev/null; done
	echo -n "Go RSS " >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-rss-go.dat >> perf-sieve-rss-all.dat
	echo -n "Go CLK " >> perf-sieve-rss-all.dat && awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-rss-go.dat >> perf-sieve-rss-all.dat
	echo -n "Go CLK_AGGR " >> perf-sieve-rss-all.dat && \
		TIMEFORMAT='%3lR' && \
		(time for i in {1..100}; do { ./go/sieve/Sieve $$UPPER ; } 1>> perf-sieve-go-internal.dat; done) 2>> perf-sieve-rss-all.dat

bench-native:
	@echo "Running Native Image benchmark"
	rm -f perf-sieve-native*
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java/sieve/target/my-app $$UPPER ; } 2>> perf-sieve-rss-native.dat 1>/dev/null; done
	echo -n "Native Image RSS " >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-rss-native.dat >> perf-sieve-rss-all.dat
	echo -n "Native Image CLK " >> perf-sieve-rss-all.dat && awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-rss-native.dat >> perf-sieve-rss-all.dat
	echo -n "Native Image CLK_AGGR " >> perf-sieve-rss-all.dat && \
		TIMEFORMAT='%3lR' && \
		(time for i in {1..100}; do { java/sieve/target/my-app $$UPPER ; } 1>> perf-sieve-native-internal.dat; done) 2>> perf-sieve-rss-all.dat

bench-java:
	@echo "Running Java benchmark"
	@echo "Upper = $$UPPER"
	rm -f perf-sieve-java*
	for i in {1..100}; do { /usr/bin/time -f "%M %e" java -cp java/sieve/target/my-app-1.0-SNAPSHOT.jar com.example.app.App $$UPPER ; } 2>> perf-sieve-rss-java.dat 1>/dev/null; done
	echo -n "Java RSS " >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-rss-java.dat >> perf-sieve-rss-all.dat
	echo -n "Java CLK " >> perf-sieve-rss-all.dat && awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-rss-java.dat >> perf-sieve-rss-all.dat
	#/usr/bin/time -f "Java %M %e" ./tst-harness-java.sh $$UPPER 2>> perf-sieve-all.dat
	echo -n "Java CLK_AGGR " >> perf-sieve-rss-all.dat && \
		TIMEFORMAT='%3lR' && \
		time (for i in {1..100}; do { java -cp java/sieve/target/my-app-1.0-SNAPSHOT.jar com.example.app.App $$UPPER  ; } 1>> perf-sieve-java-internal.dat; done) 2>> perf-sieve-rss-all.dat

avg-rss:
	@echo "Generating RSS averages"
	rm -f perf-sieve-rss-all.dat
	echo "c," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-c.dat >> perf-sieve-rss-all.dat
	echo "go," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-go.dat >> perf-sieve-rss-all.dat
	echo "native," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-native.dat >> perf-sieve-rss-all.dat
	echo "java," >> perf-sieve-rss-all.dat && awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-java.dat >> perf-sieve-rss-all.dat

avg-clocktime:
	@echo "Generating clocktime averages"
	rm -f perf-sieve-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-c.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-go.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-native.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$2; count++ } END { print total/count }' perf-sieve-java.dat >> perf-sieve-clock-all.dat
	# internal timings
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-c-internal.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-go-internal.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-native-internal.dat >> perf-sieve-clock-all.dat
	awk '{ total += $$1; count++ } END { print total/count }' perf-sieve-java-internal.dat >> perf-sieve-clock-all.dat
