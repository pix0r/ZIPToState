//
//  ZIPToStateTests.m
//  ZIPToStateTests
//
//  Created by Mike Matz on 4/11/11.
//  Copyright 2011 Flying Yeti. All rights reserved.
//

#import "ZIPToStateTests.h"


@implementation ZIPToStateTests

- (void)setUp
{
    [super setUp];
    
    zipToState = [[ZIPToState alloc] init];
}

- (void)tearDown
{
    [zipToState release];
    
    [super tearDown];
}

- (void)testDanaPoint {
    NSString *inZip = @"92629";
    NSString *outState = [zipToState stateCodeForZIP:inZip];
    NSString *expected = @"CA";
    STAssertEquals(outState, expected, @"Dana Point is in California");
}

@end
