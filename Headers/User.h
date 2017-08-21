#import <ObjFW/OFObject.h>
#import <ObjFW/OFDate.h>
#import "CommonTypes.h"

@interface User : OFObject {
    unsigned int userID;
    OFDate *dateCreated;
    MLType mlData;
}

-(id) init;
-(id) initWithCustomID:(unsigned int) i;

-(void) setTasteScoreFor:(FilmType) t to:(float) f;
-(unsigned int) getUserID;
-(float) getTasteScoreFor:(FilmType) t;
-(unsigned int) daysSinceInit;

-(void) prepairSync;

-(oneway void) release;

@end