.PHONY: all

all: map2vmf

map.tab.h map.tab.c: map.y map.h
	bison -d map.y

lex.yy.c: map.l map.h map.tab.h
	flex map.l

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

map.tab.o: map.tab.c
	gcc -c map.tab.c

map2vmf: lex.yy.o map.tab.o
	gcc -o map2vmf lex.yy.o map.tab.o -lfl
