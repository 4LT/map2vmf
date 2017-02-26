#define INIT_SZ 16
#define RESIZE 2

struct ReszArr_Array
{
    size_t capacity;
    size_t count;
    unsigned int typeSize;
    void *data;
};

struct ReszArr_Array *ReszArr_create(unsigned int typeSize)
{
    struct ReszArr_Array *arr = malloc(sizeof(struct ReszArr_Array));
    arr->capacity = INIT_SZ;
    arr->count = 0;
    arr->typeSize = typeSize;
    arr->data = malloc(typeSize * INIT_SZ);
    return arr;
}

void ReszArr_append(struct ReszArr_Array *arr, void *datum)
{
    if (arr->count >= arr->capacity) {
        arr->capacity*= RESIZE;
        arr->data = realloc(arr->data, typeSize * arr->capacity);
    }
    char *data = (char *)(arr->data);
    memcpy(data + arr->count * arr->typeSize, datum, arr->typeSize);
    arr->count++;
}

size_t ReszArr_getCount(struct ReszArr_Array *arr)
{
    return arr->count;
}

void ReszArr_copy(struct ReszArr_Array *arr, void *dest)
{
    memcpy(dest, arr->data, arr->typeSize);
}

void ReszArr_destroy(struct ReszArr_Array *arr)
{
    free(arr->data);
    free(arr);
}
