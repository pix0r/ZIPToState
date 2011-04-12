//
//  ZIPToState.m
//  ZIPToStateApp
//
//  Created by Mike Matz on 4/11/11.
//  Copyright 2011 Flying Yeti. All rights reserved.
//

#import "ZIPToState.h"

@implementation ZIPToState

#pragma mark -
#pragma mark Custom Initializer

- (id)initWithPath:(NSString *)inPath {
    if ((self = [super init])) {
        _zips = [[NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:inPath]] retain];
        if (_zips == nil) {
            NSLog(@"Error opening ZIPS plist %@", inPath);
        }
    }
    return self;
}

#pragma mark -
#pragma mark NSObject

- (id)init {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:ZIPTOSTATE_DEFAULT_PLIST_NAME ofType:@"plist"];
    NSLog(@"Path: %@", path);
    return [self initWithPath:path];
}

- (void)dealloc {
    [_zips release];
    return [super dealloc];
}

#pragma mark -
#pragma mark ZIPToState (private)

#pragma -
#pragma mark ZIPToState (public)

- (NSDictionary *)infoForZIP:(NSString *)zip {
    if (_zips == nil) {
        // Error!
        return nil;
    }
    
    NSDictionary *info = nil;
    int zipValue = [zip intValue];
    
    for (NSDictionary *zipInfo in _zips) {
        int currZip = [[zipInfo objectForKey:@"zip"] intValue];
        if (currZip > zipValue) {
            break;
        }
        info = zipInfo;
    }
    
    return info;
}

- (NSString *)stateCodeForZIP:(NSString *)zip {
    NSDictionary *info = [self infoForZIP:zip];
    return [info objectForKey:@"code"];
}

@end
