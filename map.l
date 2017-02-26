%option stack
%option bison-bridge bison-locations

%{
#include "map.h"
#include "map.tab.h"
%}

COMMENT     "//".*
INT         "-"?[[:digit:]]+
DECIMAL     {INT}?"."[[:digit:]]+

%x  string
%x  unquoted

%%
{COMMENT}       ;
"("|")"|"{"|"}" return yytext[0];
"\""            BEGIN(string);
{INT}           yylval->ival = atol(yytext); return INT;
{DECIMAL}       yylval->fval = (float)atof(yytext); return DECIMAL;
[^[:space:]\"]  BEGIN(unquoted); yymore();
<<EOF>>         /* TODO? */;
(.|[[:space:]]) ;

<string>[^"\n]* yylval->sval = strdup(yytext); return STRING;
<string>"\n"    BEGIN(INITIAL); yylval->sval = "Unclosed string"; return ERR;
<string>"\""    BEGIN(INITIAL);

<unquoted>[^[:space:]\"]* yylval->sval = yytext; return UQTEXT;
<unquoted>"\""          BEGIN(INITIAL); unput('\"'); 
<unquoted>[[:space:]]   BEGIN(INITIAL);

%%
