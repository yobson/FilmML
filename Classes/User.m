#import "../Headers/User.h"
#import <stdlib.h>
#import "../C/Common.m"

/*
    unsigned int userID;
    float *tasteArray;
    OFDate *dateCreated;
*/

@implementation User

-(id) init {
    self = [super init];
    if (self) {
        tasteArray = malloc(sizeof(float) * numberOfFilmTypes);
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
-(float) getTasteScoreFor:(FilmType) t { return tasteArray[t]; }
-(void) setTasteScoreFor:(FilmType) t to:(float) f { updateTaste(&f, t, &tasteArray); }
-(unsigned int) daysSinceInit {
    double interval = [dateCreated timeIntervalSinceNow];
    interval /= 60 * 60 * 24;
    return (unsigned int)interval;
}

-(oneway void) release {
    free(tasteArray);
    [super release];
}

@end