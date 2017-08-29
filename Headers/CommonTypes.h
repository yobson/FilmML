typedef enum {horror, crime, love, romCom} FilmType;
const unsigned int numberOfFilmTypes = 4;
float filmLearningRate = 0.1;
float userLearningRate = 0.3;
float filmLearningMomentum = 0.2;
float userLearningMomentum = 0.2;
unsigned int numberOfFilmSuggestions = 10;
unsigned int userLife = 5;

typedef union {
    unsigned int *suggestedFilms;
    unsigned int filmViews;
} Specific;

typedef struct {
    float *tasteScores;
    float *lastChanges;
    Specific specific;
} MLType;