#ifndef MAP_Y_H_
#define MAP_Y_H_

#include "map.h"

struct plane { struct Map_ivec3 plane[3]; };
void init_map(FILE *file);

#endif 
