#ifndef _biblioteca_
#define _biblioteca_

typedef struct ent{
	char* palavra;
	char* significado;
	char* traducao;
	int nr_sinonimos;
	char** sinonimos;
} Entrada;

Entrada* criaEntrada(const char* pal, const char* sig, const char* trad, int nr_sin, char** sinonimos);
void insereEntrada(THash t, Entrada* ent);
char* getPalavra( Entrada ent);
char* getSignificado(Entrada ent);
char* getTraducao(Entrada ent);
char** getSinonimos(Entrada ent);
void printDic(THash t);
#endif
