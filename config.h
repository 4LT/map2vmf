#ifndef CONFIG_H_
#define CONFIG_H_

#include <stdlib.h>

struct Conf_versioninfo {
    int editorversion;
    int editorbuild;
    int mapversion;
    int formatversion;
    int prefab;
};

struct Conf_lightmap {
    int scale;
};

struct Conf_config {
    struct Conf_versioninfo versioninfo;
    struct Conf_lightmap lightmap;
};

struct Conf_config Conf_readConfig(char const *fileName);

void Conf_writeVersionInfo(struct Conf_versioninfo versioninfo,
        char *outString, size_t outSize);

#endif
