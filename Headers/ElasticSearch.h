#import <ObjFW/OFObject.h>
#import <ObjFW/OFString.h>
#import <ObjFW/OFURL.h>
#import <ObjFW/OFHTTPClient.h>
#import <ObjFW/OFHTTPRequest.h>
#import <ObjFW/OFHTTPResponse.h>

@interface ElasticSearch : OFObject {
    OFHTTPRequest *request;
    OFString *baseURL;
    OFString *indexName;
    OFHTTPClient *client;
}

-(id) init;
-(id) initWithUrl:(OFString*) url;
-(id) initWithUrl:(OFString*) url andIndexName:(OFString*) index;

-(void) setServerUrl:(OFString*) s;
-(void) setIndexName:(OFString*) s;
-(int) checkForIndex;
-(int) setupIndex;
-(int) deleteIndex;

@end