%option noyywrap stack
%{
#include"y.tab.h"
#include"hash.h"
#include"biblioteca.h"
#include"sttc.h"

void printHeader(){
  	fprintf(yyout, "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<meta charset=\"utf-8\">\n\t\t<title>%s</title>\n\t</head>\n<body align=\"center\"><h3>%s</h3>\n", files[at_file-1], files[at_file-1]);
}

%}

%x DIC CINE


%%
	if(at_file == 0){
		yy_push_state(DIC);
	} else{
		yy_push_state(CINE);
		printHeader();
	}
	Entrada *entrada;


<DIC>{
[Ee]ntrada			{return ENTRADA;}
[Ss]ignificado			{return SIGNIFICADO;}
[Tt]raducao			{return TRADUCAO;}
[Ss]inonimos			{return SINONIMOS;}
[|;:\n]				{return yytext[0];}
[a-zA-Z()'-]+[ .!,]?		{yylval.string = yytext; return PALAVRA;}
.				{;}
}
<CINE>{
[a-zA-Z]+			{if((entrada = (Entrada*) get(table, yytext)) != NULL){
					fprintf(yyout, "<u>%s</u><sub>%s</sub>",yytext,entrada->traducao);
					setFound(entrada);
				}else{
					ECHO;
				};}
\n				{fprintf(yyout, "<br />");}
.				{ECHO;}
}

<CINE><<EOF>>			{fprintf(yyout, "\t</body>\n</html>");
                                 yyterminate();
                  }



%%
