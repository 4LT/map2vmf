.PHONY: all

all: map2vmf

map.tab.h: map.y map.h
	bison -d map.y

lex.yy.c: map.l map.h map.tab.h
	flex map.l

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

map2vmf: lex.yy.o
	gcc -o map2vmf lex.yy.o -lfl
