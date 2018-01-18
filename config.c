#include "config.h"

#include <stdio.h>
#include "util/reszarr.h"

enum Conf_state {
    CONF_STATE_READING_KEY,
    CONF_STATE_WAITING_KEY,
    CONF_STATE_READING_VALUE,
    CONF_STATE_WAITING_VALUE
};

int Conf_readConfig(char const *fileName, struct Conf_config *outConfig) {
    FILE *file = fopen(fileName, "r");
    
    if (file == (FILE *)0)
        return 0;

    enum Conf_state state = CONF_STATE_WAITING_KEY;
    int ch;
    struct ReszArr_Array *keyBuf = (void *)0;
    struct ReszArr_Array *valBuf = (void *)0;
    char *key = (char *)0;
    char *value = (char *)0;


    do {
        ch = getc(file);

        if (ch != EOF) {
            if (isspace(ch)) {
                switch (state) {
                    case CONF_STATE_READING_KEY:
                        state = CONF_STATE_WAITING_VALUE;
                        break;
                    case CONF_STATE_READING_VALUE:
                        key = calloc(ReszArr_count(keyBuf)+1, 1);
                        value = calloc(ReszArr_count(valBuf)+1, 1);
                        ReszArr_copy(keyBuf, key);
                        ReszArr_copy(valBuf, value);
                        ReszArr_destroy(keyBuf);
                        keyBuf = (void *)0;
                        ReszArr_destroy(valBuf);
                        valBuf = (void *)0;
                        state = CONF_STATE_WAITING_KEY;
                        break;
                    default:
                }
            }
            else {
                switch (state) {
                    case CONF_STATE_WAITING_KEY:
                        keyBuf = ReszArr_create(1);
                        ReszArr_append(keyBuf, &ch);
                        state = CONF_STATE_READING_KEY;
                        break;
                    case CONF_STATE_READING_KEY:
                        ReszArr_append(keyBuf, &ch);
                        break;
                    case CONF_STATE_WAITING_VALUE:
                        valBuf = ReszArr_create(1);
                        ReszArr_append(valBuf, &ch);
                        state = CONF_STATE_READING_VALUE;
                        break;
                    case CONF_STATE_READING_VALUE:
                        ReszArr_append(valBuf, &ch);
                }
            }
        }

        if (key != (char *)0 && value != (char *)0) {
            if (strcmp(key, "versioninfo.editorversion") == 0) {
                outConfig->versioninfo.editorversion = atoi(value);
            }
            else if (strcmp(key, "versioninfo.editorbuild") == 0) {
                outConfig->versioninfo.editorbuild = atoi(value);
            }
            else if (strcmp(key, "versioninfo.mapversion") == 0) {
                outConfig->versioninfo.mapversion = atoi(value);
            }
            else if (strcmp(key, "versioninfo.formatversion") == 0) {
                outConfig->versioninfo.formatversion = atoi(value);
            }
            else if (strcmp(key, "versioninfo.prefab") == 0) {
                outConfig->versioninfo.prefab = atoi(value);
            }
            else if (strcmp(key, "lightmap.scale") == 0) {
                outConfig->lightmap.scale = atoi(value);
            }

            free(key);
            key = (char *)0;
            free(value);
            value = (char *)0;
        }
        
    } while (ch != EOF);

    return 1;
}

int Conf_writeVersionInfo(struct Conf_versioninfo versioninfo, FILE *out) {
    fprintf(out, "versioninfo\n{\n");
    fprintf(out, "\t\"editorversion\" \"%d\"\n", versioninfo.editorversion);
    fprintf(out, "\t\"editorbuild\" \"%d\"\n", versioninfo.editorbuild);
    fprintf(out, "\t\"mapversion\" \"%d\"\n", versioninfo.mapbuild);
    fprintf(out, "\t\"formatversion\" \"%d\"\n", versioninfo.formatversion);
    fprintf(out, "\t\"prefab\" \"%d\"\n", versioninfo.prefab);
    fprintf(out, "}\n");
}
