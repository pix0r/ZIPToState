//
//  ZIPToState.h
//  ZIPToStateApp
//
//  Created by Mike Matz on 4/11/11.
//  Copyright 2011 Flying Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define ZIPTOSTATE_DEFAULT_DB_EXTENSION @"sqlite"
#define ZIPTOSTATE_DEFAULT_DB_NAME @"zipranges"

@interface ZIPToState : NSObject {
    NSString *_dbPath;
    sqlite3 *_db;
}

- (id)initWithPath:(NSString *)inPath;
- (NSDictionary *)infoForZIP:(NSString *)zip;
- (NSString *)stateCodeForZIP:(NSString *)zip;

@end
