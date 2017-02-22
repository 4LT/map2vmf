%{
#define YYYPARSE_PARAM scanner
#define YYLEX_PARAM    scanner
%}

%locations
%pure_parser

%union {
    int ival;
    double dval;
    char *sval;
}

%token <ival> INT
%token <dval> DECIMAL
%token <sval> STRING
%token <sval> UQTEXT
%token <sval> ERR

%%

map:
    entities entity
    ;

entities:
    entities entity
    |
    ;

entity:
    '{' pairs shapes '}'
    ;

pairs:
    pairs pair
    | 
    ;

pair:
    STRING STRING
    ;

shapes:
    shapes
    | '{' shape '}'
    ;

shape:
    faces
    | UQTEXT '{' faces '}'
    | UQTEXT '{' patch '}'
    ;

faces:
    faces face
    | 
    ;

face:
    plane texdata opts
    ;

plane:
    ipoint ipoint ipoint
    ;

ipoint:
    '(' INT INT INT ')'
    ;

texdata:
    UQTEXT number number number number number
    ;


fvec:
    '(' number number number ')'
    ;

opts:
    INT INT INT
    | 
    ;

number:
    INT
    | DECIMAL
    ;
