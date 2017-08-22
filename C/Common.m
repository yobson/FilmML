#import "../Headers/CommonTypes.h"
#import <stdlib.h>

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

void syncTastePreferences(MLType **users, MLType *film, unsigned int userCount) {
    float change, *uArray, *deltas = calloc(numberOfFilmTypes, sizeof(float));
    for (unsigned int i = 0; i < userCount; i++) {
        uArray = users[i]->tasteScores;
        for (int j = 0; j < numberOfFilmTypes; j++) {
            deltas[j] += (uArray[j] - film->tasteScores[j]) / userCount;
        }
    }
    for (int i = 0; i < numberOfFilmTypes; i++) {
        change = deltas[i] * filmLearningRate * (1-filmLearningMomentum) + 
        filmLearningMomentum * film->lastChanges[i];
        film->tasteScores[i] += change;
        film->lastChanges[i] = change;
    }
    for (unsigned int i = 0; i < userCount; i++) {
        uArray = users[i]->tasteScores;
        for (int j = 0; j < numberOfFilmTypes; j++) {
            change = deltas[j] * userLearningRate * (1-userLearningMomentum) +
            userLearningMomentum * users[i]->lastChanges[j];
            uArray[j] += change;
            users[i]->lastChanges[j] = change;
        }
    }
    free(deltas);
}