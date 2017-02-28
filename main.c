#include <stdio.h>
#include <stdlib.h>
#include "map.h"

int main(int argc, char *argv[])
{
    if (argc != 2) {
        puts("Provide a map file for argument");
        return EXIT_FAILURE;
    }
    struct Map_map const *map = Map_create(argv[1]);
    if (map == NULL)
        return EXIT_FAILURE;
    Map_destroy(map);
    return EXIT_SUCCESS;
}
