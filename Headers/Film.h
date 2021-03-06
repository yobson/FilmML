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
}

-(id) init;
-(id) initWithDefaultFilmType:(FilmType) t;
-(id) initWithFilmName:(OFString*) name;
-(id) initWithFilmName:(OFString*) name andDefaultFilmType:(FilmType) t;

-(void) setCustomID:(unsigned int) i;
-(void) setDefaultType:(FilmType) t;
-(void) setTasteScoreOf:(FilmType) t to:(float) f;
-(int) getDeafultType;
-(float) getTasteScoreFor:(FilmType) t;
-(MLType*) getMLType;

-(void) registerViewFromUser:(User*) u;
-(void) removeUserView:(User*) u;
-(void) runML;
-(void) reset;

-(oneway void) release;

@end