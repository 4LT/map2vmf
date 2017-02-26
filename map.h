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
    float scale[2];
    float offset[2];
    float rotation;
    char *texName;
    unsigned int texNameSz;
};

struct Map_face
{
    struct Map_ivec3 plane[3];
    struct Map_texData;
};

struct Map_brush
{
    struct Map_face *faces;
    unsigned int faceCount;
}

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

struct Map_entity *Map_create(const char *fileName);

void Map_destroy(struct Map_map *map);
