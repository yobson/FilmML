#import <ObjFW/OFObject.h>
#import <ObjFW/OFDate.h>
#import "CommonTypes.h"

@interface User : OFObject {
    unsigned int userID;
    float *tasteArray;
    OFDate *dateCreated;
}

-(id) init;
-(id) initWithCustomID:(unsigned int) i;

-(void) setTasteScoreFor:(FilmType) t to:(float) f;
-(unsigned int) getUserID;
-(float) getTasteScoreFor:(FilmType) t;
-(unsigned int) daysSinceInit;

-(oneway void) release;

@end