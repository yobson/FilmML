#import "../Headers/ElasticSearch.h"
#import <ObjFW/OFMutableString.h>
#import <ObjFW/OFDictionary.h>

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

-(int) checkForIndex {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_HEAD];
    OFHTTPResponse *r = [client performRequest:request];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

-(int) setupIndex {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_PUT];
    [request setBodyFromString:@"{ \"settings\" : { \"index\" : { \"number_of_shards\" : 1, \"number_of_replicas\" : 1 }}}"];
    OFDictionary OF_GENERIC(OFString *, OFString *) *headers = [[OFDictionary alloc] initWithObject:@"application/json" forKey:@"Content-Type"];
    [request setHeaders:headers];
    OFHTTPResponse *r = [client performRequest:request];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

@end