#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"hash.h"
#include"biblioteca.h"

Entrada* criaEntrada(const char* pal, const char* sig, const char* trad, int nr_sin, char** sin){
	Entrada *aux;
	int i;
	aux = (Entrada*) malloc(sizeof(Entrada));
	aux->palavra = strdup(pal);
	aux->significado = strdup(sig);
	aux->traducao = strdup(trad);
	aux->found = 0;
	aux->nr_sinonimos = nr_sin;
	aux->sinonimos = calloc(nr_sin,sizeof(char*));
	for(i = 0; i < nr_sin ;i++){
		aux->sinonimos[i] = strdup(sin[i]);
	}
	return aux;
}
void insereEntrada(THash t, Entrada* ent){
	insert(t, ent->palavra, (void*) ent);
}
char* getPalavra( Entrada ent){
	return strdup(ent.palavra);
}
char* getSignificado(Entrada ent){
	return strdup(ent.significado);
}
char* getTraducao(Entrada ent){
	return strdup(ent.traducao);
}
char** getSinonimos(Entrada ent){
	int i;
	char** res = calloc(ent.nr_sinonimos, sizeof(char*));
	for(i = 0; i < ent.nr_sinonimos;i++){
		res[i] = strdup(ent.sinonimos[i]);
	}
	return res;
}
void setFound(Entrada* ent){
	ent->found++;

}
void printDic(THash t) {

    int i;
    for(i=0;i<t.size;i++) {
		Nodo *aux;
		for (aux = t.tabela[i]; aux; aux=aux->seg){
			Entrada* ent =(Entrada*) aux->info;
			printf("%s\n%s\n%s\n",ent->palavra, ent->significado, ent->traducao);
			int j;
			for(j = 0; j < ent->nr_sinonimos; j++){
				printf("%s, ",ent->sinonimos[j]);
			}
			printf("\n");
		}
    }
}
