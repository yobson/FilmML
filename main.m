#import "Headers/Film.h"
#import "Headers/User.h"
#import "Headers/CommonTypes.h"
#import "Headers/ElasticSearch.h"
#import <ObjFW/OFObject.h>
#import <ObjFW/OFAutoreleasePool.h>
#import <ObjFW/OFArray.h>
#import <ObjFW/OFString.h>
#import <stdio.h>

#define EXPORT __declspec(dllexport)

EXPORT int __stdcall initFilmML();
EXPORT int __stdcall addFilm(const char *filmName, FilmType defaultFilmType);
EXPORT int __stdcall addUser();
EXPORT void __stdcall cleanUpUsers();
EXPORT int __stdcall dllTest();
EXPORT int __stdcall setFilmLearningMomentum(float f);
EXPORT int __stdcall setUserLearningMomentum(float f);
EXPORT int __stdcall setFilmLearningRate(float f);
EXPORT int __stdcall setUserLearningRate(float f);
EXPORT void __stdcall setNumberOfFilmSuggestions(unsigned int s);
EXPORT void __stdcall registerFilmView(unsigned int userID, unsigned int filmID);
EXPORT void __stdcall triggerfullSystemML();
EXPORT int __stdcall elasticSearchUpdate();
EXPORT int __stdcall elasticSearchClean();
EXPORT int __stdcall elasticSearchSetup(char *esURL, char *esIndex);

unsigned int nextFilmID;
unsigned int nextUserID;
unsigned int userLife;
OFMutableArray *films;
OFMutableArray *users;
ElasticSearch *ES;

EXPORT int initFilmML() {
    printf("Init DLL\n");
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];

    films = [[OFMutableArray alloc] init];
    users = [[OFMutableArray alloc] init];
    nextFilmID = 0;
    nextUserID = 0;
    userLife = 3;
    [pool drain];
    return 0;
}

EXPORT int addFilm(const char *filmName, FilmType defaultFilmType) {
    printf("Adding Film of id %d and name %s\n", nextFilmID, filmName);
    [films addObject:[[Film alloc] initWithFilmName:[OFString stringWithUTF8String:filmName] andDefaultFilmType:defaultFilmType]];
    [[films lastObject] setCustomID:nextFilmID];
    nextFilmID++;
    return nextFilmID-1;
}

EXPORT int addUser() {
    printf("Adding User of id %d\n", nextUserID);
    [users addObject:[[User alloc] initWithCustomID:nextUserID]];
    nextUserID++;
    return nextUserID -1;
}

EXPORT void cleanUpUsers() {
    printf("Cleaning up users\n");
    User *temp;// = [[User alloc] init];
    IMP imp_getObject = [User methodForSelector:@selector(objectAtIndex:)];
    IMP imp_getDays = [User methodForSelector:@selector(daysSinceInit)];
    //[temp release];
    for (int i = 0; i < nextUserID; i++) {
        temp = imp_getObject(users, @selector(objectAtIndex:), i);
        if ((int)imp_getDays(temp, @selector(daysSinceInit)) > userLife) {
            [users removeObjectAtIndex:i];
        }
    }
}

EXPORT int dllTest() {
    printf("DLL import test\n");
    return 0;
}

EXPORT int __stdcall setFilmLearningMomentum(float f) {
    if (f > 1) { return 1; }
    filmLearningMomentum = f;
    return 0;
}

EXPORT int __stdcall setUserLearningMomentum(float f) {
    if (f > 1) { return 1; }
    userLearningMomentum = f;
    return 0;
}

EXPORT int __stdcall setFilmLearningRate(float f) {
    if (f > 1) { return 1; }
    filmLearningRate = f;
    return 0;
}
EXPORT int __stdcall setUserLearningRate(float f) {
    if (f > 1) { return 1; }
    userLearningRate = f;
    return 0;
}

EXPORT void setNumberOfFilmSuggestions(unsigned int s) {
    numberOfFilmSuggestions = s;
}

EXPORT void registerFilmView(unsigned int userID, unsigned int filmID) {
    Film *film = [films objectAtIndex:filmID];
    User *user = [users objectAtIndex:userID];
    [film registerViewFromUser:user];
    [user addFilmToWatched:film];
}

EXPORT void __stdcall triggerfullSystemML() {
    SEL sel_getObject = @selector(objectAtIndex:);
    IMP imp_getObject = [OFMutableArray methodForSelector:sel_getObject];
    SEL sel_runML = @selector(runML);
    IMP imp_runML = [Film methodForSelector:sel_runML];
    for (int i = 0; i < nextFilmID; i++){
        imp_runML((Film*)imp_getObject(films, sel_getObject, i), sel_runML);
    }
    MLType *finalUserFilmArray;
    Film *filmToTest;
    User *currentUser;
    finalUserFilmArray = malloc(sizeof(unsigned int) * numberOfFilmSuggestions);

    typedef struct {
        float compatabilityScore;
        unsigned int ID;
    } MLID;

    MLID *tempArray;
    SEL sel_filmNumber = @selector(getNumberOfWatchedFilms);
    IMP imp_filmNUmber = [User methodForSelector:sel_filmNumber];
    SEL sel_films = @selector(getWatchedFilms);
    IMP imp_films = [User methodForSelector:sel_films];
    SEL sel_contains = @selector(containsObject:);
    IMP imp_contains = [OFArray methodForSelector:sel_contains];
    unsigned int numberOfUnseenFilms, tempArrayTracker = 0;
    for (unsigned int i = 0; i < nextUserID; i++) {
        currentUser = (User*)imp_getObject(users, sel_getObject, i);
        numberOfUnseenFilms = nextFilmID - (unsigned int)imp_filmNUmber(currentUser, sel_filmNumber);
        tempArray = malloc(sizeof(MLID) * numberOfUnseenFilms);
        for (unsigned int j = 0; j < nextFilmID; j++) {
                filmToTest = (Film*)imp_getObject(films, sel_getObject, j);
            if ((bool)imp_contains((OFMutableArray*)imp_films(currentUser, sel_films), sel_contains, filmToTest)) {
                (tempArray + tempArrayTracker)->compatabilityScore = compatabilityFunction((currentUser, filmToTest));
                (tempArray + tempArrayTracker)->ID = j;
            }
        }
        free (tempArray);
    }
}

EXPORT int __stdcall elasticSearchUpdate() {
    SEL sel_getUserFilmSuggestion = @selector(getFilmSelection);
    SEL sel_getObject = @selector(objectAtIndex:);
    IMP imp_getObject = [User methodForSelector:sel_getObject];
    IMP imp_getUserFilmSuggestion = [User methodForSelector:sel_getUserFilmSuggestion];
    for (int i = 0; i < nextUserID; i++) {
        [ES updateUserOfID:i filmSuggestionsTo:(unsigned int*)imp_getUserFilmSuggestion(
            (User*)imp_getObject(users, sel_getObject, i), sel_getUserFilmSuggestion) 
            ofLength:numberOfFilmSuggestions];
    }
    return 0;
}

EXPORT int __stdcall elasticSearchClean() {
    return 0;
}

EXPORT int __stdcall elasticSearchSetup(char *esURL, char *esIndex) {
    [ES setServerUrl:[OFString stringWithUTF8String:esURL]];
    [ES setIndexName:[OFString stringWithUTF8String:esIndex]];
    if ([ES checkForIndex]) { return 1; }
    if (![ES setupIndex]) { return 1; }
    return 0;
}
