#import "../Headers/CommonTypes.h"

void updateTaste(float *f, FilmType t, float **array) {
    if (*f > 1) { return; }
    float delta = *f - *array[t];
    delta /= numberOfFilmTypes - 1;
    for (int i = 0; i < numberOfFilmTypes; i++) {
        *array[i] -= delta;
    }
    *array[t] = *f;
}