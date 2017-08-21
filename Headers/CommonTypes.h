typedef enum {horror, crime, love, romCom} FilmType;
const unsigned int numberOfFilmTypes = 4;
float filmLearningRate = 0.1;
float userLearningRate = 0.3;
float filmLearningMomentum = 0.2;
float userLearningMomentum = 0.2;

typedef struct {
    float *tasteScores;
    float *lastChanges;
} MLType;