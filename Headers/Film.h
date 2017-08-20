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
-(void) setPreferenceOf:(FilmType) t to:(float) f;
-(void) applyMultipleOf:(float) f to:(FilmType) t;
-(float) getDeafultType;
-(float) getTastePreferenceFor:(FilmType) t;

-(oneway void) release;

@end