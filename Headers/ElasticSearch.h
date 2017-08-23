#import <ObjFW/OFObject.h>
#import <ObjFW/OFString.h>
#import <ObjFW/OFURL.h>
#import <ObjFW/OFHTTPClient.h>
#import <ObjFW/OFHTTPRequest.h>

@interface ElasticSearch : OFObject {
    OFHTTPRequest *request;
    OFString *baseURL;
    OFString *indexName;
}

-(id) initWithUrl:(OFString*) url;
-(id) initWithUrl:(OFString*) url andIndexName:(OFString*) index;

-(void) setServerUrl:(OFString*) s;
-(void) setIndexName:(OFString*) s;

@end