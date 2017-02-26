struct ReszArr_Array;

struct ReszArr_Array *ReszArr_create(unsigned int typeSize);

struct ReszArr_Array *ReszArr_append(struct ReszArr_Array *arr, void *datum);

size_t ReszArr_getCount(struct ReszArr_Array *arr);

void ReszArr_copy(struct ReszArr_Array *arr, void *dest);

void ReszArr_destroy(struct ReszArr_Array *arr);
