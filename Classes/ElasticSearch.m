#import "../Headers/ElasticSearch.h"

/*
    OFString serverUrl;
    OFString indexName;
*/

@implementation ElasticSearch

-(id) initWithUrl:(OFString*) url {
    self = [super init];
    if (self) {
        serverUrl = [OFURL URLWithString:url];
    }
    return self;
}

-(id) initWithUrl:(OFString*) url andIndexName:(OFString*) index {
    [self initWithUrl:url];
    indexName = [OFString stringWithString:index];
    return self;
}


-(void) setServerUrl:(OFString*) s {
    serverUrl = [OFURL URLWithString:s];
}

-(void) setIndexName:(OFString*) s {
    indexName = [OFString stringWithString:s];
}

@end