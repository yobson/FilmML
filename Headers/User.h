#import <ObjFW/OFObject.h>
#import "CommonTypes.h"

@interface User : OFObject {
    unsigned int userID;
    float *tasteArray;
}

-(id) init;
-(id) initWithCustomID:(unsigned int) i;

-(void) setTasteScoreFor:(FilmType) t to:(float) f;
-(unsigned int) getUserID;

-(float) getTasteScoreFor:(FilmType) t;

-(oneway void) release;

@end