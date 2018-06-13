#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "hash.h"


THash initHash(int size)
{
    THash res;
    int i;

	res.size = size;
	res.nelems = 0;
	res.tabela = (Nodo**) malloc(sizeof(Nodo*) * size);
	
	for(i = 0; i < size; i++) {
		res.tabela[i] = NULL;
	}
	
	return res;
}

int hash(THash t, const char* key) {
	int i, k = 0;
	
	for(i = 0; key[i]; i++) {
		k += key[i];
	}
	
	return k % t.size;
}


int rem(THash t, const char* key) {
	int i = hash(t, key);
	Nodo* ant = NULL;
	Nodo* a;
	for(a = t.tabela[i]; a && strcmp(a->chave, key); a = a->seg) {
		ant = a;
	}
	
	if(a) {
		if(!ant) {
			t.tabela[i] = a->seg;
		} else {
			ant->seg = a->seg;
		}
	}
    return 0;
}

int insert(THash t, const char* key, void* info)
{
    Nodo *aux = NULL;
    int i;
	rem(t, key);
	
    aux = (Nodo*) malloc(sizeof(struct sNodo));
    aux->info = info;
    aux->chave = strdup(key);
	
    i = hash(t, key);
	
    aux->seg=t.tabela[i];
    t.tabela[i]=aux;
	
	return i;
}

void* get(THash t, const char* key) {
	int i = hash(t, key);
	Nodo *aux;
	for(aux=t.tabela[i]; aux && strcmp(aux->chave, key); aux=aux->seg);
	
	if(aux) {
		return aux->info;
	}
	
	return NULL;
}


