%option stack
%option bison-bridge
%option noyywrap
%option never-interactive

%{
#include "map.h"
#include "map.y.h"
#include "map.tab.h"

/* get deep copy of a string, returning malloc'd pointer */
static char *copyString(char const *inStr)
{
    char *outStr = (char *)malloc(strlen(inStr) + 1);
    strcpy(outStr, inStr);
    return outStr;
}
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
{INT}           yylval->ival = atol(yytext); return TOK_INT;
{DECIMAL}       yylval->fval = (float)atof(yytext); return TOK_DECIMAL;
[^[:space:]\"]  BEGIN(unquoted); yymore();
<<EOF>>         return TOK_EOF;
(.|[[:space:]]) ;

<string>[^"\n]* yylval->sval = copyString(yytext); return TOK_STRING;
<string>"\n"    { BEGIN(INITIAL); yylval->sval = "Unclosed string";
                    return TOK_ERR; }
<string>"\""    BEGIN(INITIAL);

<unquoted>[^[:space:]\"]* yylval->sval = copyString(yytext); return TOK_UQTEXT;
<unquoted>"\""          BEGIN(INITIAL); unput('\"'); 
<unquoted>[[:space:]]   BEGIN(INITIAL);

%%

void init_map(FILE *file)
{
    yyin = file;
}
