/* map.h - Data structures to describe Quake maps */

#ifndef MAP_H_
#define MAP_H_

struct Map_ivec3
{
    int xyz[3];
};

struct Map_kvPair
{
    char *key;
    unsigned int keySz;
    char *value;
    unsigned int valueSz;
};

struct Map_texData
{
    float offset[2];
    float rotation;
    float scale[2];
    char *texName;
    unsigned int texNameSz;
};

struct Map_face
{
    struct Map_ivec3 plane[3];
    struct Map_texData texData;
};

struct Map_brush
{
    struct Map_face *faces;
    unsigned int faceCount;
};

struct Map_entity
{
    struct Map_kvPair *kvList;
    unsigned int pairCount;
    struct Map_brush *brushes;
    unsigned int brushCount;
};

struct Map_map
{
    struct Map_entity *entities;
    unsigned int entCount;
};

/* Create a map read from the given file name. */
struct Map_map const *Map_create(const char *fileName);

/* Clean-up a mao struct. */
void Map_destroy(struct Map_map const *map);

#endif
