#import <ObjFW/OFObject.h>
#import <ObjFW/OFString.h>
#import "CommonTypes.h"

@interface Film : OFObject {
    unsigned int filmID;
    OFString *filmName;
    FilmType defaultType;
    float *tasteArray;
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

-(oneway void) release;

@end