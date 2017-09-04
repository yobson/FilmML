#import "Headers/Film.h"
#import "Headers/User.h"
#import "Headers/CommonTypes.h"
#import "Headers/ElasticSearch.h"
#import "C/Common.m"
#import "C/BinaryTree.m"
#import <ObjFW/OFObject.h>
#import <ObjFW/OFAutoreleasePool.h>
#import <ObjFW/OFArray.h>
#import <ObjFW/OFString.h>
#import <ObjFW/OFNull.h>
#import <stdio.h>
//#import <string.h>

#define EXPORT __declspec(dllexport)

EXPORT int __stdcall initFilmML(); // Initialisation function of DLL
EXPORT void __stdcall onExit(); // Function to call at exit to clean up memory (not really needed, the heap is emptied on exit anyway)
EXPORT int __stdcall addFilm(const char *filmName, FilmType defaultFilmType, int alreadyInES); // Adds a film to the DLL
EXPORT int __stdcall addUser(); // Adds user to DLL
EXPORT void __stdcall cleanUpUsers(); // Deletes all users older than the life span of a user;
EXPORT int __stdcall dllTest(); // Just a test function
EXPORT int __stdcall setFilmLearningMomentum(float f); // This sets the learning momentum - a value between 1 and 0 that determins how the last change influences the curernt change
EXPORT int __stdcall setUserLearningMomentum(float f); // ditto
EXPORT int __stdcall setFilmLearningRate(float f); // the amount that the film "learns"
EXPORT int __stdcall setUserLearningRate(float f); // ditto
EXPORT void __stdcall setUserLife(unsigned int l); // The number of days that a user is alive for
EXPORT void __stdcall setNumberOfFilmSuggestions(unsigned int s); // number of suggestions each user gets.
EXPORT void __stdcall registerFilmView(unsigned int userID, unsigned int filmID); // Forms connection between film and user
EXPORT void __stdcall triggerfullSystemML(); // Does the learning for all connected users and films
EXPORT int __stdcall elasticSearchUpdate(); // Updates the elastic seach index with the ML data
EXPORT int __stdcall elasticSearchClean(); // Cleans out dead users
EXPORT int __stdcall elasticSearchSetup(char *esURL, char *esIndex); // Connects to ES and if an index doesn't exist, makes one
EXPORT int __stdcall addFilmsToElasticSearch(); // Syncs the list of films in the DLL with elastic search;
EXPORT int __stdcall addUsersToElasticSearch(); //   "    "   "    "  users "  "   "    "     "       "

unsigned int nextFilmID;  //Number of films in the DLL / ID of next film
unsigned int nextUserID; // Number of users in the DLL / ID of next user
OFMutableArray *films;  //  This is an array that holds all of the films 
OFMutableArray *users; //   This is an array that holds all of the users
ElasticSearch *ES;    //    This is object that deals with elastic search operations
OFAutoreleasePool *pool; // This is an objective c thing that (I think) makes unused objects free their memory (using reference counting)
SEL sel_getObject; // See ThingsTooLongForTheComments.md
IMP imp_getObject; // This is to optimise the commonly used [OF(Mutable)Array objectAtIndex] call
unsigned int ESFilmTracker; // This is used to track how many films have been added to ES
unsigned int ESUserTracker; // Same but for Users

EXPORT int initFilmML() {
    if (!initialised) { // Check to see if initalised (variable found in commonTypes.h)
        printf("Init DLL\n");
        // Instanciate objects and set default variables (in the scope of main.m)
        pool = [[OFAutoreleasePool alloc] init];
        ES = [[ElasticSearch alloc] init];
        films = [[OFMutableArray alloc] init];
        users = [[OFMutableArray alloc] init];
        nextFilmID = 0;
        nextUserID = 0;
        // Set up SEL IMP optimisation
        sel_getObject = @selector(objectAtIndex:);
        imp_getObject = [films methodForSelector:sel_getObject];
        initialised = 1; // Make sure the function can only be called once.
        ESFilmTracker = 0;
        ESUserTracker = 0;
        printf("Size of uint is %llu bits\n", sizeof(unsigned int) * 8);
    }
    return 0;
}

EXPORT void onExit() {
    [pool drain]; // Free any objects still around
}

EXPORT int addFilm(const char *filmName, FilmType defaultFilmType, int alreadyInES) {
    printf("Adding Film of id %d and name %s\n", nextFilmID, filmName);
    [films addObject:[[Film alloc] initWithFilmName:[OFString stringWithUTF8String:filmName] andDefaultFilmType:defaultFilmType]];
    [[films lastObject] setCustomID:nextFilmID];
    nextFilmID++;
    if (alreadyInES) {
        ESFilmTracker++;
    }
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
    SEL sel_daysSince = @selector(daysSinceInit); // Optimising for loop - [User daysSinceInit]
    IMP imp_getDays = [User methodForSelector:sel_daysSince];
    //[temp release];
    for (int i = 0; i < nextUserID; i++) { // Look at all users
        temp = imp_getObject(users, sel_getObject, i);
        if ((id)temp != [OFNull null]){
            if ((int)imp_getDays(temp, sel_daysSince) > userLife) { // If they are older than the required number of days
                for (int j = 0; j < nextFilmID; j++) {
                    [(Film*)imp_getObject(films, sel_getObject, j) removeUserView: temp]; // Remove the connections they have with films
                }
                [users replaceObjectAtIndex:i withObject:[OFNull null]]; // Remove object from array without disrupting ID Index relationship
                [temp release]; // memory managment
            }
        }
        
    }
}

EXPORT int dllTest() {
    printf("DLL import test\n");
    return 0;
}

/////////////////////////////////////////////////////////////////
//                          SETTERS                           ///
/////////////////////////////////////////////////////////////////
EXPORT int setFilmLearningMomentum(float f) {
    if (f > 1) { return 1; }
    filmLearningMomentum = f;
    return 0;
}

EXPORT int setUserLearningMomentum(float f) {
    if (f > 1) { return 1; }
    userLearningMomentum = f;
    return 0;
}

EXPORT int setFilmLearningRate(float f) {
    if (f > 1) { return 1; }
    filmLearningRate = f;
    return 0;
}
EXPORT int setUserLearningRate(float f) {
    if (f > 1) { return 1; }
    userLearningRate = f;
    return 0;
}

EXPORT void setNumberOfFilmSuggestions(unsigned int s) {
    numberOfFilmSuggestions = s;
}

EXPORT void setUserLife(unsigned int l) {
    userLife = l;
}

EXPORT void registerFilmView(unsigned int userID, unsigned int filmID) {
    if (filmID >= nextFilmID || userID >= nextUserID) {
        printf("ERROR - Cannot register a view for a film or user that doesn't exist!!!\n");
        return;
    }
    Film *film = (Film*) imp_getObject(films, sel_getObject, filmID); // [films objectAtIndex:filmID];
    User *user = (User*) imp_getObject(users, sel_getObject, userID); // [users objectAtIndex:userID];
    [film registerViewFromUser:user];
    [user addFilmToWatched:film];
}

EXPORT void triggerfullSystemML() {
    printf("Staring full ML\n");
    Film *filmToTest = [[Film alloc] init];
    User *currentUser = [[User alloc] init];
    SEL sel_runML = @selector(runML);
    IMP imp_runML = [filmToTest methodForSelector:sel_runML];
    if ((nextFilmID & nextUserID) == 0) { return; }
    printf("Calculating delta vectors");
    for (int i = 0; i < nextFilmID; i++){
        // Does the maths to find all of the Delta functions apploy them with momentum (see README.md)
        imp_runML((Film*)imp_getObject(films, sel_getObject, i), sel_runML);
        printf(".");
    }
    printf(" Done\n");
    // Define variables used in loops
    unsigned int *finalUserFilmArray;
    unsigned int numberOfUnseenFilms;
    
    finalUserFilmArray = malloc(sizeof(unsigned int) * numberOfFilmSuggestions);

    // Setup loads of SEL IMP optimisations
    SEL sel_filmNumber = @selector(getNumberOfWatchedFilms);
    IMP imp_filmNUmber = [currentUser methodForSelector:sel_filmNumber];
    SEL sel_films = @selector(getWatchedFilmList);
    IMP imp_films = [currentUser methodForSelector:sel_films];
    SEL sel_contains = @selector(containsObject:);
    IMP imp_contains = [films methodForSelector:sel_contains];
    SEL sel_getMLData = @selector(getMLType);
    IMP imp_getMLDataFilm = [filmToTest methodForSelector:sel_getMLData];
    IMP imp_getMLDataUser = [currentUser methodForSelector:sel_getMLData];

    [filmToTest release];
    [currentUser release];
    printf("Applying compatibility function\n");
    for (unsigned int i = 0; i < nextUserID; i++) { // All explained in ThingsTooLongForTheComments.md
        currentUser = (User*)imp_getObject(users, sel_getObject, i);
        printf("Got user %d", i);
        if ((id)currentUser != [OFNull null]) {
            printf(" -> Is not null");
            numberOfUnseenFilms = nextFilmID - (unsigned int)imp_filmNUmber(currentUser, sel_filmNumber);
            BTree *tree = NULL;
            printf(" -> Extracting User Data");
            MLType* userData = (MLType*)imp_getMLDataUser(currentUser, sel_getMLData);
            MLType* filmData = (MLType*)imp_getMLDataFilm(filmToTest, sel_getMLData);
            printf(" -> Adding data to Binary Tree ");
            for (unsigned int j = 0; j < nextFilmID; j++) {
                    filmToTest = (Film*)imp_getObject(films, sel_getObject, j);
                if (!(bool)imp_contains((OFMutableArray*)imp_films(currentUser, sel_films), sel_contains, filmToTest)) {
                    addToTree(tree, compatabilityFunction(userData, filmData), j);
                }
            }
            printf(" -> Extracting top values");
            topN(numberOfFilmSuggestions, tree, &finalUserFilmArray); // BROKEN
            if (userData->specific.suggestedFilms == NULL) {
                userData->specific.suggestedFilms = malloc(sizeof(unsigned int) * numberOfFilmSuggestions);
            }
            printf(" -> Coppying data to new array");
            memcpy(userData->specific.suggestedFilms, finalUserFilmArray, sizeof(unsigned int) * numberOfFilmSuggestions);
            deleteTree(tree);
            printf(" -> DONE\n");
        }
    }
}

EXPORT int elasticSearchUpdate() {
    SEL sel_getUserFilmSuggestion = @selector(getFilmSelection); // This optimisation will be the equivalent of [User getFilmSelection]
    IMP imp_getUserFilmSuggestion = [User methodForSelector:sel_getUserFilmSuggestion];
    unsigned int *suggestedFilms;
    for (int i = 0; i < nextUserID; i++) {
        if (imp_getObject(users, sel_getObject, i) != [OFNull null]) {
            suggestedFilms = (unsigned int*)imp_getUserFilmSuggestion((User*)imp_getObject(users, sel_getObject, i), sel_getUserFilmSuggestion);
            if (suggestedFilms != NULL) {
                [ES updateUserOfID:i filmSuggestionsTo:suggestedFilms ofLength:numberOfFilmSuggestions];
            }
        }
    }
    return 0;
}

EXPORT int elasticSearchClean() {
    if ([ES wipeAllUsers]) { return 1; } // Removes all users if it can
    for (int i = 0; i < nextUserID; i++) {
        if (imp_getObject(users, sel_getObject, i) != [OFNull null]) { // Ignores "dead" users
            [ES addUser:i]; // Adds all other users to the elastic search instance
        }
    }
    return elasticSearchUpdate(); // Adds their suggested film arrays
} // Now all dead users are freed from elastic search

EXPORT int elasticSearchSetup(char *esURL, char *esIndex) {
    [ES setServerUrl:[OFString stringWithUTF8String:esURL]];
    [ES setIndexName:[OFString stringWithUTF8String:esIndex]];
    if (![ES checkForIndex]) { return 0; } // [ElasticSearch checkForIndex] returns 0 if 200 status code is recived (200 if it exists). This will exit if the index is already there
    if ([ES setupIndex]) { return 1; } // Adds index and types. This will be off loaded into the CS at some point
    printf("Done\n");
    return 0;
}

EXPORT int addFilmsToElasticSearch() {
    int ret = 0;
    for (unsigned int i = ESFilmTracker; i < nextFilmID; i++) {
        ret += [ES addFilm:i];
        ESFilmTracker++;
    }
    return ret;
}

EXPORT int addUsersToElasticSearch() {
    int ret = 0;
    for (unsigned int i = ESUserTracker; i < nextUserID; i++) {
        ret += [ES addUser:i];
        ESFilmTracker++;
    }
    return ret;
}