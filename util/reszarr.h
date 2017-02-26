struct ReszArr;

struct ReszArr *ReszArr_new(unsigned int typeSize);

struct ReszArr *ReszArr_append(struct ReszArr *arr, void *datum);

size_t ReszArr_getCount(struct ReszArr *arr);

void ReszArr_copy(struct ReszArr *arr, void *dest);

void ReszArr_free(ReszArr *arr);
