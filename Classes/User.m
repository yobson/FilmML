#import <stdlib.h>
#import <string.h>
#import "../Headers/User.h"
#import "../C/Common.m"

/*
    unsigned int userID;;
    OFDate *dateCreated;
    MLType mlData;
    OFMutableArray *watchedFilms;
    unsigned int totalWatchedFilms;
    unsinged int *sugestedFilms;
*/

@implementation User

-(id) init {
    self = [super init];
    if (self) {
        mlData.tasteScores = malloc(sizeof(float) * numberOfFilmTypes);
        mlData.lastChanges   = calloc(numberOfFilmTypes, sizeof(float));
        dateCreated = [OFDate date];
        watchedFilms = [[OFMutableArray alloc] init];
        sugestedFilms = NULL;
        totalWatchedFilms = 0;
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
-(void) setFilmSuggestions:(unsigned int*) i { sugestedFilms = i; }
-(unsigned int*) getFilmSuggestions { return sugestedFilms; }
-(unsigned int) daysSinceInit {
    double interval = [dateCreated timeIntervalSinceNow];
    interval /= 60 * 60 * 24;
    return (unsigned int)interval;
}

-(MLType*) getMLType {
    return &mlData;
}

-(void) addFilmToWatched:(Film*) f {
    if ([watchedFilms containsObject:f]) { return; }
    [watchedFilms addObject:f];
    totalWatchedFilms++;
}

-(void) reset {
    memset(mlData.tasteScores, 1 / numberOfFilmTypes, sizeof(float) * numberOfFilmTypes);
    memset(mlData.lastChanges, 0, sizeof(float) * numberOfFilmTypes);
}

-(oneway void) release {
    free(mlData.tasteScores);
    free(mlData.lastChanges);
    if (sugestedFilms != NULL) { free(sugestedFilms); }
    [super release];
}

@end