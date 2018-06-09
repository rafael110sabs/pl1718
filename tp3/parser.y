%{
#include<stdio.h>
#include<stdlib.h>
#include"hash.h"
#include"biblioteca.h"
extern int yylex();
extern FILE *yyin;

THash table;
char* pal;
char* sig;
char* trad;
int nr_sin = 0;
char* sino[20];
char* fn;

%}

%union{
	char* string;
}

%token <string> ENTRADA SIGNIFICADO TRADUCAO PALAVRA SINONIMOS
%type <string> campos campo linha valor lista

%%

campos	: campo '\n'					{insereEntrada(table, criaEntrada(pal,sig,trad,nr_sin,sino)); nr_sin = 0;}
	| campos campo '\n'				{insereEntrada(table, criaEntrada(pal,sig,trad,nr_sin,sino)); nr_sin = 0;}
	; 

campo	: linha
	| campo linha
	;

linha	: ENTRADA ':' valor '\n' 			{pal = strdup($3);}
	| SIGNIFICADO ':' valor '\n'			{sig = strdup($3); free(fn);}
	| TRADUCAO ':' valor '\n'			{trad = strdup($3);}
	| SINONIMOS ':' lista ';' '\n'			{;}
	;

valor	: PALAVRA					{$$ = strdup($1);}
	| valor PALAVRA					{fn = malloc(128*sizeof(char)); strcpy(fn,$1); $$ = strcat(fn,$2);}
	;

lista	: PALAVRA					{sino[nr_sin++] = strdup($1);}
	| lista ',' PALAVRA				{sino[nr_sin++] = strdup($3);}
	;
%%

int yyerror(char *s){
	fprintf(stderr,"%s\n", s);
	return 0;
}

int main(int argc, char** argv){
	FILE *dic;
	if(argc == 1)
		printf("Por favor, introduza um ficheiro de dicionario.");
	else
		yyin = fopen(argv[1],"r");
	
	table = initHash(50);
	return yyparse();
}
