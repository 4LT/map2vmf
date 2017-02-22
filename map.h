struct Map_ivec3
{
    int xyz[3];
};

struct Map_entity
{
    struct kvPair *kvList;
    unsigned int pairCount;
    struct face *faces;
    unsigned int faceCount;
};

struct Map_kvPair
{
    char *key;
    unsigned int keySz;
    char *value;
    unsigned int valueSz;
};

struct Map_face
{
    struct Map_ivec3 plane[3];
    struct Map_texData;
};

struct texData
{
    float scale[2];
    float offset[2];
    float rotation;
    char *texName;
    unsigned int texNameSz;
};
