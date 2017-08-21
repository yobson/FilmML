#import "../Headers/Film.h"
#import "../C/Common.m"
#import <stdlib.h>
#import <string.h>

/*
    unsigned int filmID;
    OFString *filmName;
    FilmType defaultType;
    MLType mlData
*/

@implementation Film

-(id) init {
    self = [super init];
    if (self) {
        mlData.tasteScores = calloc(numberOfFilmTypes, sizeof(float));
        mlData.lastChanges   = calloc(numberOfFilmTypes, sizeof(float));
        filmName = [[OFString alloc] init];
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

-(void) prepairSync {
    for (int i = 0; i < numberOfFilmTypes; i++) {
        mlData.lastChanges[i] = mlData.tasteScores[i];
    }
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