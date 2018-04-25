/**If the start condition is inclusive (%s), then rules with no
  *start conditions at all will also be active.
  *If it is exclusive (%x), then only rules qualified with the start
  *condition will be active.
  **/

%option noyywrap
%{
#include <stdio.h>
#include <string.h>

void printHeader(char*);
int trimNumber(char*);

int ol_count = 0;
int ident_count = 0;
char title[256];
%}

%x QUOTE PAR
%s OLIST ULIST
%%

<INITIAL>\\[a-zA-Z0-9 @#]*?           {strcpy(title, yytext); printHeader(title);}
<INITIAL>\\\"[^\"]*\"                 {fprintf(yyout, "<img src=%s>", yytext+1);}
<<EOF>>                               {fprintf(yyout, "\t</body>\n</html>");yyterminate();}
.                                     ECHO;

<INITIAL,PAR>"``"                     {fprintf(yyout, "\"");BEGIN QUOTE;}
<QUOTE,PAR>{
  "''"                                {fprintf(yyout, "\"");BEGIN INITIAL;}
}

\\\+                                  {fprintf(yyout, "<p>");BEGIN PAR;}
<PAR>{
  .                                   ECHO;
  \n                                  {fprintf(yyout, "</p>\n"); BEGIN INITIAL;}
}

<INITIAL,PAR,ULIST,OLIST>"\\-"        {fprintf(yyout,"<b>");}
<INITIAL,PAR,ULIST,OLIST>"-\\"        {fprintf(yyout,"</b>");}

<INITIAL,PAR,ULIST,OLIST>"\\~"        {fprintf(yyout,"<i>");}
<INITIAL,PAR,ULIST,OLIST>"~\\"        {fprintf(yyout,"</i>");}

<INITIAL,PAR,ULIST,OLIST>"\\_"        {fprintf(yyout,"<u>");}
<INITIAL,PAR,ULIST,OLIST>"_\\"        {fprintf(yyout,"</u>");}

\\[0-9]-                              {fprintf(yyout,"<h%d>", yytext[1] - '0');}
-[0-9]\\                              {fprintf(yyout,"</h%d>", yytext[1] - '0');}


\\:\n?                                {if(ol_count == 0){ fprintf(yyout,"<ol>\n");BEGIN OLIST;}
                                        else if(ol_count == 1) fprintf(yyout,"\t<ol type=\"a\">\n");
                                        else if(ol_count == 2) fprintf(yyout,"\t\t<ol type=\"i\">\n");
                                        ol_count++;
                                        ident_count++;
                                      }
\\;\n?                                {fprintf(yyout,"<ul>\n");BEGIN ULIST; ident_count++;}
;\\\n?                                {fprintf(yyout,"</ul>\n"); BEGIN INITIAL; ident_count--;}
:\\\n?                                {fprintf(yyout,"</ol>\n"); if(ol_count == 1) BEGIN INITIAL;
                                        ol_count--; ident_count--;}

<ULIST,OLIST>{
  "->"                                {for(int i = 0; i < ident_count; i++)
                                          fprintf(yyout,"\t");
                                        fprintf(yyout,"<li>");}
  \n                                  {fprintf(yyout,"</li>\n");}
}

%%

void printHeader(char* title){
  fprintf(yyout, "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<meta charset=\"utf-8\">\n\t\t<title>%s</title>\n\t</head>\n<body>\n", title+1);
}

int trimNumber(char* token){
  return token[1]-'0';
}

int main( int argc, char** argv){
  yyin = fopen(argv[1],"r");
  yyout = fopen(argv[2],"w");
  yylex();
}
