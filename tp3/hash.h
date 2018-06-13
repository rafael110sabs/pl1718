#ifndef _HASH_
#define _HASH_

typedef struct sNodo {
	char* chave;
	void* info;
	struct sNodo* seg;
} Nodo;

typedef struct sHash {
	int size;
	int nelems;
	Nodo** tabela;
} THash;

THash initHash(int size);
int hash(THash t, const char* key);
int insert(THash t, const char* key, void* info);
void* get(THash t, const char* key);

#endif
