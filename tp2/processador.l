/**If the start condition is inclusive (%s), then rules with no
  *start conditions at all will also be active.
  *If it is exclusive (%x), then only rules qualified with the start
  *condition will be active.
  **/

%option noyywrap stack
%{
#include <stdio.h>
#include <string.h>

void printHeader(char*);
int trimNumber(char*);

int open_header = 0;
int ol_count = 0;
int ul_count = 0;
char title[256];
%}

%x QUOTE PAR HEADER OLIST ULIST
%%

<INITIAL>\\[a-zA-Z0-9 #@]*?           {strcpy(title, yytext); printHeader(title);}
<INITIAL>\\\"[^\"]*\"                 {fprintf(yyout, "<img src=%s>", yytext+1);}
<<EOF>>                               {fprintf(yyout, "\t</body>\n</html>");yyterminate();}
.                                     ECHO;
\n                                    ;

<INITIAL,PAR>"``"                     {fprintf(yyout, "\"");yy_push_state(QUOTE);}
<QUOTE,PAR>{
  "''"                                {fprintf(yyout, "\"");yy_pop_state();}
}

\\\+                                  {fprintf(yyout, "<p>");BEGIN PAR;}
<PAR>{
  \n                                  {fprintf(yyout, "</p>\n"); BEGIN INITIAL;}
}

\\[0-9]-                              { open_header = yytext[1] - '0';
                                        fprintf(yyout,"<h%d>", open_header);
                                        BEGIN HEADER;}
<HEADER>{
  \n                                  { fprintf(yyout, "</h%d>\n", open_header);
                                        open_header=0;
                                        BEGIN INITIAL;}
}

<INITIAL,PAR,ULIST,OLIST>"\\-"        {fprintf(yyout,"<b>");}
<INITIAL,PAR,ULIST,OLIST>"-\\"        {fprintf(yyout,"</b>");}

<INITIAL,PAR,ULIST,OLIST>"\\~"        {fprintf(yyout,"<i>");}
<INITIAL,PAR,ULIST,OLIST>"~\\"        {fprintf(yyout,"</i>");}

<INITIAL,PAR,ULIST,OLIST>"\\_"        {fprintf(yyout,"<u>");}
<INITIAL,PAR,ULIST,OLIST>"_\\"        {fprintf(yyout,"</u>");}

#\                                    {fprintf(yyout,"<ol>\n\t<li>");ol_count++; BEGIN OLIST;}
\*\                                    {fprintf(yyout,"<ul>\n\t<li>");BEGIN ULIST; ul_count++;}

<OLIST>{
  #\                                  {if(ol_count == 2)
                                          fprintf(yyout,"</ol>\n\t<li>\n");
                                        else
                                          fprintf(yyout, "\t<li>");
                                      }
  ##\                                 {if(ol_count == 1){
                                          fprintf(yyout,"\t<ol type=\"a\">\n\t\t<li>");
                                          ol_count++;
                                       }else if(ol_count == 3){
                                          fprintf(yyout, "\t\t</ol>\n\t\t<li>");
                                          ol_count--;
                                       }else
                                          fprintf(yyout, "\t\t<li1>");
                                      }
  ###\                                {if(ol_count == 2){
                                          fprintf(yyout,"\t\t<ol type=\"i\">\n\t\t\t<li>");
                                          ol_count++;
                                        }else
                                          fprintf(yyout, "\t\t\t<li>");
                                      }
  \n                               {fprintf(yyout, "</li>\n");}
  \n\n                             {fprintf(yyout,"</li>\n");
                                    for(int i = 0; i < ol_count; i++)
                                      fprintf(yyout,"</ol>\n");
                                    ol_count--; BEGIN INITIAL;}
}

<ULIST>{
  \*\                                { if(ul_count == 2){
                                          fprintf(yyout, "\t</ul>\n\t<li>");
                                          ul_count--;
                                       }else
                                          fprintf(yyout, "\t<li>");
                                    }
  \*\*\                               { if(ul_count == 1){
                                        fprintf(yyout, "\t<ul>\n\t\t<li>");
                                        ul_count++;
                                      }else if(ul_count == 3){
                                        fprintf(yyout, "\t\t</ul>\n\t\t<li>");
                                        ul_count--;
                                      }else
                                        fprintf(yyout, "\t\t<li>");
                                      }
  \*\*\*\                               { if(ul_count == 2){
                                            fprintf(yyout, "\t\t<ul>\n\t\t\t<li>");
                                            ul_count++;
                                          }else
                                            fprintf(yyout, "\t\t\t<li>");
                                        }
  \n                                    { fprintf(yyout, "</li>\n");}
  \n\n                              { fprintf(yyout, "</li>\n");
                                      for(int i = 0; i < ul_count; i++)
                                        fprintf(yyout, "</ul>\n");
                                      ul_count=0; BEGIN INITIAL;
                                    }
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
