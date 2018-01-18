#ifndef CONFIG_H_
#define CONFIG_H_

#include <stdlib.h>
#include <stdio.h>

struct Conf_VersionInfo {
    int editorversion;
    int editorbuild;
    int mapversion;
    int formatversion;
    int prefab;
};

struct Conf_Lightmap {
    int scale;
};

struct Conf_Config {
    struct Conf_VersionInfo versioninfo;
    struct Conf_Lightmap lightmap;
};

int Conf_readConfig(char const *fileName, struct Conf_Config *outConfig);

int Conf_writeVersionInfo(struct Conf_VersionInfo versioninfo, FILE *outFile);

#endif
