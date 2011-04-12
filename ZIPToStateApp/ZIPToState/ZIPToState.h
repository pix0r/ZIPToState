//
//  ZIPToState.h
//  ZIPToStateApp
//
//  Created by Mike Matz on 4/11/11.
//  Copyright 2011 Flying Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define ZIPTOSTATE_DEFAULT_PLIST_NAME @"zipranges"

@interface ZIPToState : NSObject {
    NSArray *_zips;
}

- (id)initWithPath:(NSString *)inPath;
- (NSDictionary *)infoForZIP:(NSString *)zip;
- (NSString *)stateCodeForZIP:(NSString *)zip;

@end
