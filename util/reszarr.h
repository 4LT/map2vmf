struct ReszArr_array;

struct ReszArr_array *ReszArr_create(unsigned int typeSize);

struct ReszArr_array *ReszArr_append(struct ReszArr_array *arr, void *datum);

size_t ReszArr_getCount(struct ReszArr_array *arr);

void ReszArr_copy(struct ReszArr_array *arr, void *dest);

void ReszArr_destroy(struct ReszArr_array *arr);
