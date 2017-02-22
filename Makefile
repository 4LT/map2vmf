.PHONY: all

all: map2vmf

lex.yy.c: map.l
	flex map.l

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

map2vmf: lex.yy.o
	gcc -o map2vmf lex.yy.o -lfl
