%option stack
%option bison-bridge bison-locations

%{
#include "y.tab.h"

    enum map_symbol
    {
         MAP_OPAREN,
         MAP_CPAREN,
         MAP_OCURLY,
         MAP_CCURLY,
         MAP_INT,
         MAP_DECIMAL,
         MAP_STRING,
         MAP_UQTEXT,
         MAP_ERR,
         MAP_EOF
    };
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
{DECIMAL}       yylval->dval = strtod(yytext, NULL); return DECIMAL;
[^[:space:]\"]  BEGIN(unquoted); yymore();
<<EOF>>         /* TODO? */;
(.|[[:space:]]) ;

<string>[^"\n]* yylval->sval = strdup(yytext); return STRING;
<string>"\n"    BEGIN(INITIAL); yyval->sval = "Unclosed string"; return ERR;
<string>"\""    BEGIN(INITIAL);

<unquoted>[^[:space:]\"]* yyval->sval = yytext; return UQTEXT;
<unquoted>"\""          BEGIN(INITIAL); unput('\"'); 
<unquoted>[[:space:]]   BEGIN(INITIAL);

%%
int main(int argc, char *argv[])
{
    yyin = stdin;
    struct map_token token;
    do {
        token = yylex();
        print_token(token);
    } while (token.symbol != MAP_EOF);
    return 0;
}
