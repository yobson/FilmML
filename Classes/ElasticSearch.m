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
    [self setServerUrl:url];
    return self;
}

-(id) initWithUrl:(OFString*) url andIndexName:(OFString*) index {
    [self initWithUrl:url];
    indexName = [OFString stringWithString:index];
    return self;
}


-(void) setServerUrl:(OFString*) url { baseURL = [OFString stringWithFormat:@"%s%@%s",([url hasPrefix:@"http://"] ? "" : "http://"), url,([url hasSuffix:@"/"] ? "" : "/")]; }
-(void) setIndexName:(OFString*) s { indexName = [OFString stringWithString:s]; }
-(OFString*) getIndexName { return indexName; }
-(OFString*) getServerUrl { return baseURL; }

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
    printf("Setting up elasticsearch index: ");
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

-(int) wipeAllUsers {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    [q appendString:@"/user"];
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
    [q appendString:[OFString stringWithFormat:@"/film/%d", id]];
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
    [q appendString:[OFString stringWithFormat:@"/user/%d", id]];
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

-(int) updateUserOfID:(unsigned int) id filmSuggestionsTo:(unsigned int*) array ofLength:(unsigned int) s {
    OFMutableString *q = [[OFMutableString alloc] initWithString:baseURL];
    [q appendString:indexName];
    [q appendString:[OFString stringWithFormat:@"/user/%d/_update",id]];
    request = [[OFHTTPRequest alloc] initWithURL:[OFURL URLWithString:q]];
    [request setMethod:OF_HTTP_REQUEST_METHOD_POST];
    [request setBodyFromString:[OFString stringWithFormat:@"{\"doc\": {\"SugestedFilms\" : %@}}", [ElasticSearch jsonFromFilmIDArray:array ofSize:s]]];
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


+(OFString*) jsonFromFilmIDArray:(unsigned int*) array ofSize:(unsigned int) s {
    OFMutableString *out = [[OFMutableString alloc] init];
    SEL sel_append = @selector(appendString:);
    IMP imp_append = [out methodForSelector:sel_append];

    imp_append(out, sel_append, @"[ ");
    for (int i = 0; i < s-1; i++) {
        imp_append(out, sel_append, [OFString stringWithFormat:@"%d, ", array[i]]);
    }
    imp_append(out, sel_append, [OFString stringWithFormat:@"%d ]", array[s]]);
    return out;
}

@end