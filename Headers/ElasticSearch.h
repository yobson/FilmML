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
-(OFString*) getIndexName;
-(OFString*) getServerUrl;

-(int) checkForIndex;
-(int) setupIndex;
-(int) deleteIndex;
-(int) wipeAllUsers;
-(int) addFilm:(unsigned int) id;
-(int) addUser:(unsigned int) id;
-(int) deleteFilm:(unsigned int) id;
-(int) deleteUser:(unsigned int) id;
-(int) updateUserOfID:(unsigned int) id filmSuggestionsTo:(unsigned int*) array ofLength:(unsigned int) s;

+(OFString*) jsonFromFilmIDArray:(unsigned int*) array ofSize:(unsigned int) s;

@end