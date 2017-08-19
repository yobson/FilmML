#import <ObjFW/OFObject.h>
#import "CommonTypes.h"

@interface Film : OFObject {
    unsigned int filmID;
    OFString *filmName;
    FilmType defaultType;
    float *tasteArray;
}

-(id) init;
-(id) initWithDefaultFimlType:(FilmType) t;
-(id) initWithFilmName(OFString*) name;
-(id) initWithFilmName(OFString*) name andDefaultFilmType:(FilmType) t;

-(void) setCustomID;
-(void) setDefaultType:(FilmType) t;
-(void) setPreferenceOf:(FilmType) t to:(float) f;
-(void) applyMultipleOf:(float) f to:(FilmType) t;
-(float) getDeafultType;
-(float) getTastePreferenceFor(FilmType t);

-(oneway void) release;

@end