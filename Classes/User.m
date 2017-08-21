#import "../Headers/User.h"
#import <stdlib.h>
#import "../C/Common.m"

/*
    unsigned int userID;
    float *tasteArray;
*/

@implementation User

-(id) init {
    self = [super init];
    if (self) {
        tasteArray = malloc(sizeof(float) * numberOfFilmTypes);
    }
    return self;
}
-(id) initWithCustomID:(unsigned int) i {
    [self init];
    userID = i;
    return self;
}

-(unsigned int) getUserID { return userID; }
-(float) getTasteScoreFor:(FilmType) t { return tasteArray[t]; }
-(void) setTasteScoreFor:(FilmType) t to:(float) f { updateTaste(&f, t, &tasteArray); }

-(oneway void) release {
    free(tasteArray);
    [super release];
}

@end