.PHONY: all subdirs clean

all: subdirs map2vmf

subdirs:
	$(MAKE) -C util

map.tab.h map.tab.c: map.y map.h util/reszarr.h
	bison -d map.y

lex.yy.c: map.l map.h map.tab.h
	flex map.l

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

map.tab.o: map.tab.c
	gcc -c map.tab.c

map2vmf: lex.yy.o map.tab.o
	gcc -o map2vmf lex.yy.o map.tab.o util/reszarr.o -lfl

clean:
	rm -f map2vmf
	rm -f *.o
	rm -f lex.yy.c
	rm -f map.tab.c
	rm -f map.tab.h
	$(MAKE) -C util clean
