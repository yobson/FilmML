#import "../Headers/CommonTypes.h"
#import <stdlib.h>
#import <string.h>

/*
This file is where common static tasks (sometimes interclass) can implemented. It is also a place for
high performace tasks becuase it is in c and not objc. Only c types can be passed in.
*/

void updateTaste(float *f, FilmType t, float **array) {
    if (*f > 1) { return; }
    float delta = *f - *array[t];
    delta /= numberOfFilmTypes - 1;
    for (int i = 0; i < numberOfFilmTypes; i++) {
        *array[i] -= delta;
    }
    *array[t] = *f;
}

void syncTastePreferences(float ***uTaste, float **fTaste, unsigned int userCount) {
    float *uArray, *deltas = malloc(sizeof(float) * numberOfFilmTypes);
    memset(deltas, 0, sizeof(float) * numberOfFilmTypes);
    for (unsigned int i = 0; i < userCount; i++) {
        uArray = *(*uTaste + i);
        for (int j = 0; j < numberOfFilmTypes; j++) {
            deltas[j] += (uArray[j] - *fTaste[j]) / userCount;
        }
    }
    for (int i = 0; i < numberOfFilmTypes; i++) {
        *fTaste[i] += deltas[i] * userTastePower;
    }
    for (unsigned int i = 0; i < userCount; i++) {
        uArray = *(*uTaste + i);
        for (int j = 0; j < numberOfFilmTypes; j++) {
            uArray[i] += deltas[i] *=filmTastePower;
        }
    }
    free(deltals);
}