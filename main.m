#import "Headers/Film.h"
#import "Headers/User.h"
#import "Headers/CommonTypes.h"
#import <ObjFW/OFObject.h>
#import <ObjFW/OFAutoreleasePool.h>
#import <ObjFW/OFArray.h>
#import <ObjFW/OFString.h>

#define EXPORT __declspec(dllexport)

EXPORT int __stdcall initFilmML();
EXPORT int __stdcall addFilm(const char *filmName, FilmType defaultFilmType);
EXPORT int __stdcall addUser();
EXPORT void __stdcall cleanUpUsers();

int nextFilmID;
int nextUserID;
int userLife;
OFMutableArray *films;
OFMutableArray *users;

EXPORT int initFilmML() {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];

    films = [[OFMutableArray alloc] init];
    users = [[OFMutableArray alloc] init];
    nextFilmID = 0;
    nextUserID = 0;
    userLife = 3;
    [pool drain];
    return 0;
}

EXPORT int addFilm(const char *filmName, FilmType defaultFilmType) {
    [films addObject:[[Film alloc] initWithFilmName:[OFString stringWithUTF8String:filmName] andDefaultFilmType:defaultFilmType]];
    [[films lastObject] setCustomID:nextFilmID];
    nextFilmID++;
    return nextFilmID-1;
}

EXPORT int addUser() {
    [users addObject:[[User alloc] initWithCustomID:nextUserID]];
    nextUserID++;
    return nextUserID -1;
}

EXPORT void cleanUpUsers() {
    User *temp = [[User alloc] init];
    IMP imp_getObject = [users methodForSelector:@selector(objectAtIndex:)];
    IMP imp_getDays = [temp methodForSelector:@selector(daysSinceInit)];
    [temp release];
    for (int i = 0; i < nextUserID; i++) {
        temp = imp_getObject(users, @selector(objectAtIndex:), i);
        if ((int)imp_getDays(temp, @selector(daysSinceInit)) > userLife) {
            [users removeObjectAtIndex:i];
        }
    }
}