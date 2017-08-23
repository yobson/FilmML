#import "../Headers/ElasticSearch.h"
#import <ObjFW/OFMutableString.h>

/*
    OFHTTPRequest *request;
    OFString *baseURL;
    OFString *indexName;
*/

@implementation ElasticSearch

-(id) init {
    self = [super init];
    if (self) {
        client = [[OFHTTPClient alloc] init];
    }
    return self;
}

-(id) initWithUrl:(OFString*) url {
    [self init];
    baseURL = [OFString stringWithFormat:@"%@%s", url,([url hasSuffix:@"/"] ? "" : "/")];
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

-(OFHTTPResponse*) doRequest:(OFString*) query; {
    request = [[OFHTTPRequest alloc] initWithUrl:[OFURL URLWithString:query]];
    [client performRequestL:request];
}

-(int) checkForIndex {
    OFMutableString *query = [[OFMutableString alloc] init];
    [query appendString:[OFString stringWithFormat:"%@%@", baseURL, indexName]];
    OFHTTPResponse *r = [self doRequest:query];
    if ([r statusCode == 200]) { return 0; }
    return 1;
}

@end