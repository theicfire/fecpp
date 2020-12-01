
CC=clang++ -std=c++11 -stdlib=libc++
WARNINGS= -Wall -Wextra
OPTFLAGS=-O2 -march=nehalem
DEBUGFLAGS=-g

CFLAGS=$(OPTFLAGS) $(DEBUGFLAGS) $(WARNINGS)

PROGS = benchmark zfec test_recovery gen_test_vec

all: $(PROGS)

libfecpp.a: fecpp.o
	ar crs $@ $<

fecpp.o: fecpp.cpp fecpp.h
	$(CC) $(CFLAGS) -I. -c $< -o $@

test/%.o: test/%.cpp fecpp.h
	$(CC) $(CFLAGS) -I. -c $< -o $@

zfec: test/zfec.o libfecpp.a
	$(CC) $(CFLAGS) $<  -L. -lfecpp -o $@

benchmark: test/benchmark.o libfecpp.a
	$(CC) $(CFLAGS) $<  -L. -lfecpp -o $@

test_fec: test/test_fec.o libfecpp.a
	$(CC) $(CFLAGS) $<  -L. -lfecpp -o $@

test_recovery: test/test_recovery.o libfecpp.a
	$(CC) $(CFLAGS) $< -L. -lfecpp -o $@

gen_test_vec: test/gen_test_vec.o libfecpp.a
	$(CC) $(CFLAGS) $< -L. -lfecpp -o $@

clean:
	rm -f fecpp.so *.a *.o test/*.o
	rm -f $(PROGS)
