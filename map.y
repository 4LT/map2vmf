%{
#include "map.h"
#include "util/reszarr.h"

#define YYYPARSE_PARAM scanner
#define YYLEX_PARAM    scanner

struct plane { Map_ivec3 plane[3]; };

struct Map_kvPair makePair(char *qkey, char *qvalue)
{
    unsigned int keySz = strlen(qkey) - 1;
    unsigned int valSz = strlen(qvalue) - 1;
    char *key = malloc(keySz);
    char *value = malloc(valSz);
    memcpy(key, qkey+1, keySz);
    memcpy(value, qvalue+1, valSz);
    key[keySz - 1] = '\0';                   
    value[valSz - 1] = '\0';
    return (struct Map_kvPair) { key, keySz, value, valSz };
}

struct Map_entity makeEntity(struct ReszArr *kvArr, struct ReszArr *brushArr)
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
    return (struct Map_texData) {
            { offX, offY }, rot, { scaleX, scaleY }, nameCpy };
}

struct Map_brush makeBrush(struct ReszArr *faceArr)
{
    unsigned int faceCount = (unsigned int)ReszArr_getCount(faceArr);
    struct Map_face *faces = malloc(sizeof(struct Map_face) * faceCount);
    ReszArr_copy(faceArr, faces);
    return (struct Map_brush) { faces, faceCount };
}

struct Map_map makeMap(struct ReszArr *entArr)
{
    unsigned int entCount = (unsigned int)ReszArr_getCount(entArr);
    struct Map_face *entities = malloc(sizeof(struct Map_entity) * entCount);
    ReszArr_copy(entArr, entities);
    return (struct Map_map) { entities, entCount };
}

void Map_free(struct Map_map *map)
{
    for (unsigned int i = 0; i < map->entCount; i++) {
        struct Map_entity entity = map->entities[i];
        for (unsigned int j = 0; j < entity.pairCount; j++) {
            free(entity.kvList[j].key);
            free(entity.kvList[j].value);
        }
        free(entity.kvList);
        for (unsigned int j = 0; j < entity.faceCount; j++)
            free(entity.faces[j].texData.texName);
        free(entity.faces);
    }
    free(map->entities);
    free(map);
}

%}

%locations
%pure_parser

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

%token <ival> INT
%token <fval> DECIMAL
%token <sval> STRING
%token <sval> UQTEXT
%token <sval> ERR

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

%%

map:
    entities entity {
                        ReszArr_append($entities, &$entity);
                        $$ = makeMap($entities);
                        ReszArr_free($entities);
                    }
    ;

entities:
    entities entity { $$ = ReszArr_append($entities, &%entity); }
    |               { $$ = ReszArr_new(sizeof(struct Map_entity)); }
    ;

entity:
    '{' pairs brushes '}'   {
                                $$ = makeEntity($pairs, $brushes);
                                ReszArr_free($pairs);
                                ReszArr_free($brushes);
                            }
    ;

pairs:
    pairs pair  { $$ = ReszArr_append($pairs, &$pair); }
    |           { $$ = ReszArr_new(sizeof(struct Map_kvPair)); }
    ;

pair:
    STRING STRING   { $$ = makePair($1, $2); }
    ;

brushes:
    brushes brush   { $$ = ReszArr_append($brushes, &$brush); }
    |               { $$ = ReszArr_new(sizeof(struct Map_brush)); }
    ;

brush:
    '{' faces face '}'  {
                            ReszArr_append($faces, $face);
                            $$ = makeBrush($faces);
                            ReszArr_free($faces);
                        }
    ;

faces:
    faces face  { $$ = ReszArr_append($faces, &$face); }
    |           { $$ = ReszArr_new(sizeof(struct Map_face)); }
    ;

face:
    plane texdata   { $$ = (struct Map_face) { $plane, $texdata }; }
    ;

plane:
    ipoint ipoint ipoint    { $$ = (struct plane) {{ $1, $2, $3 }}; }
    ;

ipoint:
    '(' INT INT INT ')' { $$ = (struct Map_ivec3) {{ $2, $3, $4 }}; }
    ;

texdata:
    UQTEXT number number number number number
        { $$ = makeTexData($6, $1, $2, $3, $4, $5); }
    ;

number:
    INT         { $$ = (float) $1; }
    | DECIMAL   { $$ = $1; }
    ;
