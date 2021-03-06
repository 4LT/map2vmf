#ifndef RESZARR_H_
#define RESZARR_H_

#include <stdlib.h>

struct ReszArr_Array;

struct ReszArr_Array *ReszArr_create(unsigned int typeSize);

void ReszArr_append(struct ReszArr_Array *arr, void *datum);

size_t ReszArr_getCount(struct ReszArr_Array *arr);

void ReszArr_copy(struct ReszArr_Array *arr, void *dest);

void ReszArr_destroy(struct ReszArr_Array *arr);

#endif
