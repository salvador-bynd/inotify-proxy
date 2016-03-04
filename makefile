all: bin bin/changewatcher

bin:
	mkdir bin

bin/changewatcher:
	g++ -Wall -std=c++11 src/changewatcher.cpp -o bin/changewatcher

.PHONY: clean

clean:
	rm -r bin/*
