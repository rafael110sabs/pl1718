%option noyywrap
%{
#include"y.tab.h"

%}

%%

[Ee]ntrada			{return ENTRADA;}
[Ss]ignificado			{return SIGNIFICADO;}
[Tt]raducao			{return TRADUCAO;}
[Ss]inonimos			{return SINONIMOS;}
[,;:\n]				{return yytext[0];}
[a-zA-Z-]+[ .!]?		{yylval.string = yytext; return PALAVRA;}
.				{;}

%%

