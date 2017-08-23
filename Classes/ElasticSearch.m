#import "../Headers/ElasticSearch.h"
#import <ObjFW/OFHTTPResponse.h>

/*
    OFHTTPRequest *request;
    OFString *baseURL;
    OFString *indexName;
*/

@implementation ElasticSearch

-(id) initWithUrl:(OFString*) url {
    self = [super init];
    if (self) {
        baseURL = [OFString stringWithString:url];
    }
    return self;
}

-(id) initWithUrl:(OFString*) url andIndexName:(OFString*) index {
    [self initWithUrl:url];
    indexName = [OFString stringWithString:index];
    return self;
}


-(void) setServerUrl:(OFString*) s {
    baseURL = [OFString stringWithString:s];
}

-(void) setIndexName:(OFString*) s {
    indexName = [OFString stringWithString:s];
}

@end