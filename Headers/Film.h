#import <ObjFW/OFObject.h>
#import <ObjFW/OFString.h>
#import <ObjFW/OFMutableArray.h>
#import "CommonTypes.h"
#import "User.h"

@interface Film : OFObject {
    unsigned int filmID;
    OFString *filmName;
    FilmType defaultType;
    MLType mlData;
    OFMutableArray *usersSigWatched;
    unsigned int numberOfUsers;
}

-(id) init;
-(id) initWithDefaultFilmType:(FilmType) t;
-(id) initWithFilmName:(OFString*) name;
-(id) initWithFilmName:(OFString*) name andDefaultFilmType:(FilmType) t;

-(void) setCustomID:(unsigned int) i;
-(void) setDefaultType:(FilmType) t;
-(void) setTasteScoreOf:(FilmType) t to:(float) f;
-(float) getDeafultType;
-(float) getTasteScoreFor:(FilmType) t;

-(void) registerVieweFromUser:(User*) u;
-(void) runML;
-(void) reset;

-(oneway void) release;

@end