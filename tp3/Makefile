compiler: parser lexer hash biblioteca sttc 
	cc -o sttc sttc.o y.tab.o lex.yy.o hash.o biblioteca.o

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
sttc: sttc.h sttc.c
	cc -c sttc.c
clean:
	rm -f y.tab.* lex.yy.* *.o site/*.html site/found.txt
