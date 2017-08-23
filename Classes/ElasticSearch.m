#import "../Headers/ElasticSearch.h"
#import <ObjFW/OFMutableString.h>
#import <ObjFW/OFDictionary.h>
#import <ObjFW/OFHTTPRequestFailedException.h>

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
    baseURL = baseURL = [OFString stringWithFormat:@"%s%@%s",([url hasPrefix:@"http://"] ? "" : "http://"), url,([url hasSuffix:@"/"] ? "" : "/")];
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
    OFHTTPResponse *r;
    @try {
        r = [client performRequest:request];
    }
    @catch (OFHTTPRequestFailedException *e) {
        r = [e response];
    }
    [request release];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

-(int) setupIndex {
    if (![self checkForIndex]) { return 1; }
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_PUT];
    [request setBodyFromString:@"{  \"settings\" : {\"number_of_shards\" : 1  },  \"mappings\" : {\"user\" : { \"properties\" : {  \"ID\" : { \"type\" : \"integer\" },  \"SugestedFilms\" : { \"type\": \"integer\" } }}, \"film\" : { \"properties\" : {  \"ID\" : { \"type\" : \"integer\" } }}  } }"];
    OFDictionary OF_GENERIC(OFString *, OFString *) *headers = [[OFDictionary alloc] initWithObject:@"application/json" forKey:@"Content-Type"];
    [request setHeaders:headers];
    OFHTTPResponse *r;
    @try {
        r = [client performRequest:request];
    }
    @catch (OFHTTPRequestFailedException *e) {
        r = [e response];
    }
    [request release];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

-(int) deleteIndex {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_DELETE];
    OFHTTPResponse *r;
    @try {
        r = [client performRequest:request];
    }
    @catch (OFHTTPRequestFailedException *e) {
        r = [e response];
    }
    [request release];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

-(int) addFilm:(unsigned int) id {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    [q appendString:@"/film"];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_POST];
    [request setBodyFromString:[OFString stringWithFormat:@"{ \"ID\" : %d }", id]];
    OFDictionary OF_GENERIC(OFString *, OFString *) *headers = [[OFDictionary alloc] initWithObject:@"application/json" forKey:@"Content-Type"];
    [request setHeaders:headers];
    OFHTTPResponse *r;
    @try {
        r = [client performRequest:request];
    }
    @catch (OFHTTPRequestFailedException *e) {
        r = [e response];
    }
    [request release];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

-(int) addUser:(unsigned int) id {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    [q appendString:@"/user"];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_POST];
    [request setBodyFromString:[OFString stringWithFormat:@"{ \"ID\" : %d }", id]];
    OFDictionary OF_GENERIC(OFString *, OFString *) *headers = [[OFDictionary alloc] initWithObject:@"application/json" forKey:@"Content-Type"];
    [request setHeaders:headers];
    OFHTTPResponse *r;
    @try {
        r = [client performRequest:request];
    }
    @catch (OFHTTPRequestFailedException *e) {
        r = [e response];
    }
    [request release];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

-(int) deleteFilm:(unsigned int) id {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    [q appendString:[OFString stringWithFormat:@"/film/_delete_by_query?q=ID=%d", id]];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_GET];
    OFHTTPResponse *r;
    @try {
        r = [client performRequest:request];
    }
    @catch (OFHTTPRequestFailedException *e) {
        r = [e response];
    }
    [request release];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

-(int) deleteUser:(unsigned int) id {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    [q appendString:[OFString stringWithFormat:@"/user/_delete_by_query?q=ID=%d", id]];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_GET];
    OFHTTPResponse *r;
    @try {
        r = [client performRequest:request];
    }
    @catch (OFHTTPRequestFailedException *e) {
        r = [e response];
    }
    [request release];
    if ([r statusCode] == 200) { return 0; }
    return 1;
}

@end