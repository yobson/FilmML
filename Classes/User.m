#import <stdlib.h>
#import <string.h>
#import "../Headers/User.h"
#import "../C/Common.m"

/*
    unsigned int userID;;
    OFDate *dateCreated;
    MLType mlData;
*/

@implementation User

-(id) init {
    self = [super init];
    if (self) {
        mlData.tasteScores = malloc(sizeof(float) * numberOfFilmTypes);
        mlData.momentums = calloc(numberOfFilmTypes, sizeof(float));
        mlData.lastChanges   = calloc(numberOfFilmTypes, sizeof(float));
        memset(mlData.tasteScores, 1 / numberOfFilmTypes, sizeof(float) * numberOfFilmTypes);
        dateCreated = [OFDate date];
    }
    return self;
}
-(id) initWithCustomID:(unsigned int) i {
    [self init];
    userID = i;
    return self;
}

-(unsigned int) getUserID { return userID; }
-(float) getTasteScoreFor:(FilmType) t { return mlData.tasteScores[t]; }
-(void) setTasteScoreFor:(FilmType) t to:(float) f { updateTaste(&f, t, &mlData.tasteScores); }
-(unsigned int) daysSinceInit {
    double interval = [dateCreated timeIntervalSinceNow];
    interval /= 60 * 60 * 24;
    return (unsigned int)interval;
}

-(void) prepairSync {
    for (int i = 0; i < numberOfFilmTypes; i++) {
        mlData.lastChanges[i] = mlData.tasteScores[i];
    }
}

-(void) reset {
    memset(mlData.tasteScores, 1 / numberOfFilmTypes, sizeof(float) * numberOfFilmTypes);
    memset(mlData.momentums  , 0, sizeof(float) * numberOfFilmTypes);
    memset(mlData.lastChanges, 0, sizeof(float) * numberOfFilmTypes);
}

-(oneway void) release {
    free(mlData.tasteScores);
    free(mlData.momentums);
    free(mlData.lastChanges);
    [super release];
}

@end