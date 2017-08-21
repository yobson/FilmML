#import "../Headers/Film.h"
#import "../C/Common.m"
#import <stdlib.h>

/*
    unsigned int filmID;
    OFString *filmName;
    FilmType defaultType;
    float *tasteArray;
*/

@implementation Film

-(id) init {
    self = [super init];
    if (self) {
        tasteArray = malloc(sizeof(float) * numberOfFilmTypes);
        filmName = [[OFString alloc] init];
    }
    return self;
}

-(id) initWithDefaultFilmType:(FilmType) t {
    [self init];
    defaultType = t;
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
-(float) getLevelOf:(FilmType) t { return tasteArray[t]; }
-(float) getTasteScoreFor:(FilmType) t { return tasteArray[t]; }

-(void) setTasteScoreOf:(FilmType) t to:(float) f { updateTaste(&f, t, &tasteArray); }

-(oneway void) release {
    free(tasteArray);
    [super release];
}

@end