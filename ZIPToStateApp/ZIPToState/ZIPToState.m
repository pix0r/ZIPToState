//
//  ZIPToState.m
//  ZIPToStateApp
//
//  Created by Mike Matz on 4/11/11.
//  Copyright 2011 Flying Yeti. All rights reserved.
//

#import "ZIPToState.h"

@interface ZIPToState (private)
- (BOOL)open;
- (BOOL)close;
@end

@implementation ZIPToState

#pragma mark -
#pragma mark Custom Initializer

- (id)initWithPath:(NSString *)inPath {
    if ((self = [super init])) {
        _dbPath = [inPath retain];
        _db = NULL;
    }
    return self;
}

#pragma mark -
#pragma mark NSObject

- (id)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:ZIPTOSTATE_DEFAULT_DB_NAME ofType:ZIPTOSTATE_DEFAULT_DB_EXTENSION];
    NSLog(@"Path: %@", path);
    return [self initWithPath:path];
}

- (void)dealloc {
    [_dbPath release];
    [self close];
    return [super dealloc];
}

#pragma mark -
#pragma mark ZIPToState (private)

- (BOOL)open {
    if (_db) {
        return YES;
    }
    
    int err = sqlite3_open([_dbPath fileSystemRepresentation], &_db);
    if (err != SQLITE_OK) {
        NSLog(@"Error opening database: %d", err);
        return NO;
    }
    
    return YES;
}

- (BOOL)close {
    if (_db) {
        sqlite3_close(_db);
        _db = NULL;
    }
    return YES;
}

/*
 const char *sql = "select coffeeID, coffeeName from coffee";
 sqlite3_stmt *selectstmt;
 if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
 
 while(sqlite3_step(selectstmt) == SQLITE_ROW) {
 
 NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
 Coffee *coffeeObj = [[Coffee alloc] initWithPrimaryKey:primaryKey];
 coffeeObj.coffeeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
 
 coffeeObj.isDirty = NO;
 
 [appDelegate.coffeeArray addObject:coffeeObj];
 [coffeeObj release];
 }
 }
*/

#pragma -
#pragma mark ZIPToState (public)

- (NSDictionary *)infoForZIP:(NSString *)zip {
    if (![self open]) {
        // Error!
        return nil;
    }
    
    NSDictionary *info = nil;
    
    char sql[500];
    int intZip = [zip intValue];
    int err;
    sqlite3_stmt *st;
    sprintf(sql, "SELECT state, code FROM zipranges WHERE start <= '%d' AND end >= '%d'", intZip, intZip);
    if ((err = sqlite3_prepare_v2(_db, sql, -1, &st, NULL)) == SQLITE_OK) {
        if (sqlite3_step(st) == SQLITE_ROW) {
            const char *sState = (const char *)sqlite3_column_text(st, 0);
            const char *sCode = (const char *)sqlite3_column_text(st, 1);
            if (sState != NULL && sCode != NULL) {
                info = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSString stringWithCString:sState encoding:NSUTF8StringEncoding],
                        @"state",
                        [NSString stringWithCString:sCode encoding:NSUTF8StringEncoding],
                        @"code",
                        nil];
            }
            NSLog(@"Created dictionary: %@", info);
        }
    } else {
        NSLog(@"SQLite error code %d", err);
    }
    
    return info;
}

- (NSString *)stateCodeForZIP:(NSString *)zip {
    NSDictionary *info = [self infoForZIP:zip];
    return [info objectForKey:@"code"];
}

@end
