#import <ObjFW/OFObject.h>
#import <ObjFW/OFDate.h>
#import <ObjFW/OFMutableArray.h>
#import "CommonTypes.h"

@class Film;

@interface User : OFObject {
    unsigned int userID;
    OFDate *dateCreated;
    MLType mlData;
    OFMutableArray *watchedFilms;
    unsigned int totalWatchedFilms;
}

-(id) init;
-(id) initWithCustomID:(unsigned int) i;

-(void) setTasteScoreFor:(FilmType) t to:(float) f;
-(void) setFilmSuggestions:(unsigned int*) i;
-(unsigned int*) getFilmSuggestions;
-(unsigned int) getUserID;
-(float) getTasteScoreFor:(FilmType) t;
-(unsigned int) daysSinceInit;
-(MLType*) getMLType;

-(void) addFilmToWatched:(Film*) f;

-(oneway void) release;

@end