#import <ObjFW/OFObject.h>
#import <ObjFW/OFString.h>
#import "CommonTypes.h"

@interface Film : OFObject {
    unsigned int filmID;
    OFString *filmName;
    FilmType defaultType;
    MLType mlData;
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

-(void) prepairSync;
-(void) reset;

-(oneway void) release;

@end