#import "../Headers/Film.h"
#import "../C/Common.m"
#import <stdlib.h>
#import <string.h>

/*
    unsigned int filmID;
    OFString *filmName;
    FilmType defaultType;
    MLType mlData;
    OFMutableArray *usersSigWatched;
    unsigned int numberOfUsers;
*/

@implementation Film

-(id) init {
    self = [super init];
    if (self) {
        mlData.tasteScores = calloc(numberOfFilmTypes, sizeof(float));
        mlData.lastChanges   = calloc(numberOfFilmTypes, sizeof(float));
        filmName = [[OFString alloc] init];
        usersSigWatched = [[OFMutableArray alloc] init];
        numberOfUsers = 0;
    }
    return self;
}

-(id) initWithDefaultFilmType:(FilmType) t {
    [self init];
    defaultType = t;
    mlData.tasteScores[t] = 1;
    return self;
}

-(id) initWithFilmName:(OFString*) name {
    [self init];
    filmName = [[OFString alloc] initWithString:name];
    return self;
}

-(id) initWithFilmName:(OFString*) name andDefaultFilmType:(FilmType) t {
    [self initWithFilmName:name];
    defaultType = t;
    return self;
}

-(void) setCustomID:(unsigned int) i { filmID = i; }
-(void)  setDefaultType:(FilmType) t { defaultType = t; }
-(float) getDeafultType { return defaultType; }
-(float) getLevelOf:(FilmType) t { return mlData.tasteScores[t]; }
-(float) getTasteScoreFor:(FilmType) t { return mlData.tasteScores[t]; }
-(void) setTasteScoreOf:(FilmType) t to:(float) f { updateTaste(&f, t, &mlData.tasteScores); }

-(void) registerVieweFromUser:(User*) u {
    if ([usersSigWatched containsObject:u]) { return; }
    [usersSigWatched addObject:u];
    numberOfUsers++;
}

-(void) runML {
    MLType **users = malloc(sizeof(MLType*) * numberOfUsers);
    IMP imp_getObject = [usersSigWatched methodForSelector:@selector(objectAtIndex:)];
    for (int i = 0; i < numberOfUsers; i++) {
        users[i] = [(User*) imp_getObject(usersSigWatched, @selector(objectAtIndex:), i) getMLType];
    } 
    syncTastePreferences(users, &mlData, numberOfUsers);
    free(users);
}

-(void) reset {
    memset(mlData.tasteScores, 0, sizeof(float) * numberOfFilmTypes);
    memset(mlData.lastChanges, 0, sizeof(float) * numberOfFilmTypes);
    mlData.tasteScores[defaultType] = 1;
}

-(oneway void) release {
    free(mlData.tasteScores);
    free(mlData.lastChanges);
    [super release];
}

@end