#include <stdio.h>
#include <stdlib.h>
#include "map.h"

void indent(int level)
{
    for (int i = 0; i < level; i++)
        printf("   ");
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fputs("Provide a map file argument.\n", stderr);
        return EXIT_FAILURE;
    }
    struct Map_map const *map = Map_create(argv[1]);
    if (map == NULL) {
        fputs("Failed to parse map.\n", stderr);
        return EXIT_FAILURE;
    }

    for (int i = 0; i < map->entCount; i++) {
        printf("Entity %d\n", i);
        struct Map_entity ent = map->entities[i];
        for (int j = 0; j < ent.pairCount; j++) {
            indent(1);
            printf("%s %s\n", ent.kvList[j].key, ent.kvList[j].value);
        }
        for (int j = 0; j < ent.brushCount; j++) {
            indent(1);
            printf("Brush %d\n", j);
            struct Map_brush brush = ent.brushes[j];
            for (int k = 0; k < brush.faceCount; k++) {
                indent(2);
                printf("Face %d\n", k);
                struct Map_face face = brush.faces[k];
                for (int l = 0; l < 3; l++) {
                    indent(3);
                    printf("(%d %d %d)\n", 
                            face.plane[l].xyz[0],
                            face.plane[l].xyz[1],
                            face.plane[l].xyz[2]);
                }
                struct Map_texData texData = face.texData;
                indent(3);
                printf("%s\n", texData.texName);
                indent(3);
                printf("Offset %f, %f\n", texData.offset[0], texData.offset[1]);
                indent(3);
                printf("Rotation %f\n", texData.rotation);
                indent(3);
                printf("Scale %f, %f\n", texData.scale[0], texData.scale[1]);
            }
        }
    }

    Map_destroy(map);
    return EXIT_SUCCESS;
}
