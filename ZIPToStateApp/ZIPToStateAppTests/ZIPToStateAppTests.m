//
//  ZIPToStateAppTests.m
//  ZIPToStateAppTests
//
//  Created by Mike Matz on 4/11/11.
//  Copyright 2011 Flying Yeti. All rights reserved.
//

#import "ZIPToStateAppTests.h"
#import "ZIPToState.h"


@implementation ZIPToStateAppTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testDanaPoint
{
    ZIPToState *z = [[ZIPToState alloc] init];
    NSString *result = [z stateCodeForZIP:@"92629"];
    STAssertEquals(result, @"CA", @"Dana Point is in California");
}

@end
