%{
    #include <stdio.h>
    #include <string.h>
    #include "util/reszarr.h"
    #include "map.y.h"
    #include "map.h"

/*
    #define YYYPARSE_PARAM scanner
    #define YYLEX_PARAM    scanner
*/

%}

%locations
%pure-parser

%union {
    int ival;
    float fval;
    char *sval;
    struct Map_ivec3 ivec3;
    struct Map_kvPair kvPair;
    struct Map_texData texData;
    struct plane plane;
    struct Map_face face;
    struct Map_brush brush;
    struct Map_entity entity;
    struct Map_map map;
    struct ReszArr_Array *arr;
}

%token <ival> TOK_INT
%token <fval> TOK_DECIMAL
%token <sval> TOK_STRING
%token <sval> TOK_UQTEXT
%token <sval> TOK_ERR
%token TOK_EOF

%type <ivec3> ipoint
%type <kvPair> pair
%type <texData> texdata
%type <plane> plane
%type <face> face
%type <brush> brush
%type <entity> entity
%type <fval> number
%type <map> map
%type <arr> pairs
%type <arr> faces
%type <arr> brushes
%type <arr> entities

%{
    static struct Map_map out_map;

    extern int yylex(YYSTYPE *yylval_param, YYLTYPE *yylloc_param);

    static void yyerror (char const *s);

    static struct Map_kvPair makePair(char *key, char *value);

    static struct Map_entity makeEntity(
            struct ReszArr_Array *kvArr, struct ReszArr_Array *brushArr);

    static struct Map_texData makeTexData(
            float offX, float offY,
            float rot,
            float scaleX, float scaleY,
            char *name);

    static struct Map_brush makeBrush(struct ReszArr_Array *faceArr);

    static struct Map_map makeMap(struct ReszArr_Array *entArr);
%}

%%

map:
    entities entity TOK_EOF {
                        ReszArr_append($1, &$2);
                        out_map = makeMap($1);
                        ReszArr_destroy($1);
                        YYACCEPT;
                    }
    ;

entities:
    entities entity { ReszArr_append($1, &$2); $$ = $1; }
    |               { $$ = ReszArr_create(sizeof(struct Map_entity)); }
    ;

entity:
    '{' pairs brushes '}'   {
                                $$ = makeEntity($2, $3);
                                ReszArr_destroy($2);
                                ReszArr_destroy($3);
                            }
    ;

pairs:
    pairs pair  { ReszArr_append($1, &$2); $$ = $1; }
    |           { $$ = ReszArr_create(sizeof(struct Map_kvPair)); }
    ;

pair:
    TOK_STRING TOK_STRING   { $$ = makePair($1, $2); }
    ;

brushes:
    brushes brush   { ReszArr_append($1, &$2); $$ = $1; }
    |               { $$ = ReszArr_create(sizeof(struct Map_brush)); }
    ;

brush:
    '{' faces face '}'  {
                            ReszArr_append($2, &$3);
                            $$ = makeBrush($2);
                            ReszArr_destroy($2);
                        }
    ;

faces:
    faces face  { ReszArr_append($1, &$2); $$ = $1; }
    |           { $$ = ReszArr_create(sizeof(struct Map_face)); }
    ;

face:
    plane texdata   {
                        memcpy(&$$.plane, &$1, sizeof($1));
                        $$.texData = $2;
                    }
    ;

plane:
    ipoint ipoint ipoint    { $$ = (struct plane) {{ $1, $2, $3 }}; }
    ;

ipoint:
    '(' TOK_INT TOK_INT TOK_INT ')'
        { $$ = (struct Map_ivec3) {{ $2, $3, $4 }}; }
    ;

texdata:
    TOK_UQTEXT number number number number number
        { $$ = makeTexData($2, $3, $4, $5, $6, $1); }
    ;

number:
    TOK_INT         { $$ = (float) $1; }
    | TOK_DECIMAL   { $$ = $1; }
    ;

%%

void yyerror (char const *s)
{
    fprintf (stderr, "%s\n", s);
}

struct Map_kvPair makePair(char *key, char *value)
{
    unsigned int keySz = strlen(key) + 1;
    unsigned int valSz = strlen(value) + 1;
    struct Map_kvPair pair;
    pair.key = malloc(keySz);
    pair.value = malloc(valSz);
    pair.keySz = keySz;
    pair.valueSz = valSz;
    memcpy(pair.key,   key,   keySz);
    memcpy(pair.value, value, valSz);
    free(key);
    free(value);
    return pair;
}

struct Map_entity makeEntity(
        struct ReszArr_Array *kvArr, struct ReszArr_Array *brushArr)
{
    unsigned int pairCount = (unsigned int)ReszArr_getCount(kvArr);
    unsigned int brushCount = (unsigned int)ReszArr_getCount(brushArr);
    struct Map_kvPair *kvList = malloc(sizeof(struct Map_kvPair) * pairCount);
    struct Map_brush *brushes = malloc(sizeof(struct Map_brush) * brushCount);
    ReszArr_copy(kvArr, kvList);
    ReszArr_copy(brushArr, brushes);
    return (struct Map_entity) { kvList, pairCount, brushes, brushCount };
}

struct Map_texData makeTexData(
        float offX, float offY,
        float rot,
        float scaleX, float scaleY,
        char *name)
{
    char *nameCpy = malloc(strlen(name) + 1);
    strcpy(nameCpy, name);
    free(name);
    return (struct Map_texData) {
            { offX, offY }, rot, { scaleX, scaleY }, nameCpy };
}

struct Map_brush makeBrush(struct ReszArr_Array *faceArr)
{
    unsigned int faceCount = (unsigned int)ReszArr_getCount(faceArr);
    struct Map_face *faces = malloc(sizeof(struct Map_face) * faceCount);
    ReszArr_copy(faceArr, faces);
    return (struct Map_brush) { faces, faceCount };
}

struct Map_map makeMap(struct ReszArr_Array *entArr)
{
    unsigned int entCount = (unsigned int)ReszArr_getCount(entArr);
    struct Map_entity *entities = malloc(sizeof(struct Map_entity) * entCount);
    ReszArr_copy(entArr, entities);
    return (struct Map_map) { entities, entCount };
}

struct Map_map const *Map_create(const char *fileName)
{
    FILE *file = fopen(fileName, "r");
    init_map(file);
    if (yyparse() == 0)
        return &out_map;
    else
        return NULL;
}

void Map_destroy(struct Map_map const *map)
{
    for (unsigned int i = 0; i < map->entCount; i++) {
        struct Map_entity entity = map->entities[i];
        for (unsigned int j = 0; j < entity.pairCount; j++) {
            free(entity.kvList[j].key);
            free(entity.kvList[j].value);
        }
        free(entity.kvList);
        for (unsigned int j = 0; j < entity.brushCount; j++) {
            struct Map_brush brush = entity.brushes[j];
            for (unsigned int k = 0; k < brush.faceCount; k++) {
                free(brush.faces[k].texData.texName);
            }
            free(brush.faces);
        }
        free(entity.brushes);
    }
    free(map->entities);
}
