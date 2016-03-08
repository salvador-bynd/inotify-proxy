all: bin bin/inotify-proxy

bin:
	mkdir bin

bin/inotify-proxy:
	g++ -Wall -std=c++11 src/inotify-proxy.cpp -o bin/inotify-proxy

.PHONY: clean

clean:
	rm -r bin/*
