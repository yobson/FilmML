typedef enum {horror, crime, love, romCom} FilmType;
const unsigned int numberOfFilmTypes = 4;
const float filmLearningRate = 0.1;
const float userLearningRate = 0.3;

typedef struct {
    float *tasteScores;
    float *momentums;
    float *lastChanges;
} MLType;