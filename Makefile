CLFAGS_COMMON=-Wall -pedantic
CFLAGS_DEBUG=$(CFLAGS_COMMON) -ggdb
CFLAGS_RELEASE=$(CFLAGS_COMMON) -O2
LDFLAGS=-lfl
OBJECTS_WD=lex.yy.o map.tab.o
OBJECTS_UTIL=util/reszarr.o
OBJECTS=$(OBJECTS_WD) $(OBJECTS_UTIL)

.PHONY: all release debug clean clean-util

all: debug

release: map2vmf
	$(MAKE) CFLAGS=$(CFLAGS_RELEASE)

debug: map2vmf
	$(MAKE) CFLAGS=$(CFLAGS_DEBUG)

# Working directory

map.tab.h map.tab.c: map.y map.h util/reszarr.h
	bison -d map.y

lex.yy.c: map.l map.h map.tab.h
	flex map.l

lex.yy.o: lex.yy.c
	gcc $(CFLAGS) -c lex.yy.c

map.tab.o: map.tab.c
	gcc $(CFLAGS) -c map.tab.c

map2vmf: $(OBJECTS)
	gcc $(LDFLAGS) -o map2vmf $(OBJECTS)

clean: clean-util
	rm -f map2vmf
	rm -f *.o
	rm -f lex.yy.c
	rm -f map.tab.c
	rm -f map.tab.h

# Util

util/reszarr.o: util/reszarr.c util/reszarr.h
	gcc $(CFLAGS) -c util/reszarr.c

clean-util:
	rm -f util/*.o
