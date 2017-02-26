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

struct Map_entity *Map_newEntityFromFile(const char *fileName);

void Map_freeEntity(struct Map_entity *entity);
