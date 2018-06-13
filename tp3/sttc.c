#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include"hash.h"
#include"sttc.h"
#include"biblioteca.h"

extern FILE *yyin;
extern int yyparse();
extern int yylex();
extern FILE *yyout;

THash table;
char** files;
int file_count;
int at_file;

char* getNomeFicheiro(char* nome){
	int length = strlen(nome) + 6;
	char* res = (char*) calloc(length, sizeof(char));
	int i;
	for(i = 0; nome[i] != '.'; i++){
		res[i] = nome [i];
	}
	res[i]='\0';
	return res;
}

void printFoundPage(){
	FILE *f = fopen("site/found.txt","w");
	//fprint(f,"<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<meta charset=\"utf-8\">\n\t\t<title>Found Words</title>\n\t</head>\n<body align=\"center\">\n<h3>Found words from the dictionary</h3>");
	fprintf(f,"... Found Words\n\\3- Found words from the dictionary\n");
	Nodo *aux;
	int i;
	for(i=0;i<table.size;i++){
		for (aux = table.tabela[i]; aux; aux=aux->seg){
			Entrada* ent =(Entrada*) aux->info;
			if(ent->found > 0){
				fprintf(f,"; %s\n",ent->palavra);
				fprintf(f,": %s\n",ent->significado);
				fprintf(f,": Found %d times\n", ent->found);
				int j;
				fprintf(f,": Synonyms - ");
				for(j = 0; j < ent->nr_sinonimos; j++){
					fprintf(f,"%s, ",ent->sinonimos[j]);
				}
				fprintf(f,"<br />");
			}
		}
	}
	int pid;
	if((pid = fork()) == 0){
		execl("processador","proc","site/found.txt","site/found.html",NULL);
	}
	fclose(f);	
}

void printIndexPage(){
	FILE *f = fopen("site/index.html","w");
	fprintf(f,"<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<meta charset=\"utf-8\">\n\t\t<title>STTC</title>\n\t</head>\n<body align=\"center\">\n<h3>Sistema de tratamento de textos cinematográficos.</h3>");
	fprintf(f,"<a href=\"found.html\">Words found</a><br />");
	int i;
	fprintf(f,"<h5>Movie Script List</h5>");
	for(int i = 0; i < file_count; i++){
		fprintf(f,"<a href=\"%s.html\">%s</a><br/>", files[i], files[i]);
	}
	fprintf(f,"</body></html>");
	fclose(f);
	
}

char* removeNewLine(char* s){
	char* d = (char*) malloc(strlen(s));
	int i;
	for(i = 0; s[i] != '\n'; i++){
		d[i] = s[i];
	}
	s[i] = '\0';
	return d;
}

int main(int argc, char** argv){
	FILE *dic;
	files = (char**) calloc(20, sizeof(char*));
	file_count = 0;
	at_file = 0;
	int i;
	FILE *list = fopen("movie-list.txt","r");
	char buff[255];
	while((fgets(buff, 255, list)) != NULL){
		char *d = removeNewLine(buff);
		files[file_count++] = strdup(d);
	}
	
	fclose(list);	

	table = initHash(50);

	yyin = fopen("dicionario.txt","r");
	int wasParsed =  yyparse();
	if(wasParsed == 0){
		for(at_file = 1; (at_file-1) < file_count; at_file++){
			char* ficheiro = (char*) calloc(128, sizeof(char));
			strcat(ficheiro,files[at_file-1]);
			strcat(ficheiro, ".txt");
			char* directory = (char*) calloc(128, sizeof(char));
			strcat(directory, "site/");
			strcat(directory, files[at_file-1]);
			strcat(directory, ".html");
			yyin = fopen(ficheiro,"r");
			yyout = fopen(directory,"w");
			yylex();
			free(ficheiro);
			free(directory);
		}
	}	
	printFoundPage();
	printIndexPage();	
	return 0;
}



