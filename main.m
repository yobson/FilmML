#import "Headers/Film.h"
#import <ObjFW/OFObject.h>
#import <ObjFW/OFAutoreleasePool.h>
#import <ObjFW/OFArray.h>

#define EXPORT __declspec(dllexport)

EXPORT int __stdcall initFilmML();

int nextFilmID;
int nextUserID;
OFMutableArray *films;
OFMutableArray *users;

EXPORT int initFilmML() {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];

    films = [[OFMutableArray alloc] init];
    users = [[OFMutableArray alloc] init];
    nextFilmID = 0;
    nextUserID = 0;

    [pool drain];
    return 0;
}