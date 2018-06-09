compiler: parser lexer hash biblioteca 
	cc -o sttc y.tab.o lex.yy.o hash.o biblioteca.o

parser:	parser.y
	yacc -d parser.y
	cc -c y.tab.c

lexer: lexer.l y.tab.h
	lex lexer.l
	cc -c lex.yy.c

hash: hash.h hash.c
	cc -c hash.c

biblioteca: biblioteca.h biblioteca.c
	cc -c biblioteca.c

clean:
	rm -f y.tab.* lex.yy.* *.o
