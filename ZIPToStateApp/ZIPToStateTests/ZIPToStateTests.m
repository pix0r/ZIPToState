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

- (void)assertZIP:(NSString *)zip returnsStateCode:(NSString *)code {
    NSString *outCode = [zipToState stateCodeForZIP:zip];
    STAssertEqualObjects(code, outCode, @"ZIP %@ expected to match code %@, instead got %@", zip, code, outCode);
}

- (void)testDanaPoint {
    [self assertZIP:@"92629" returnsStateCode:@"CA"];
}

- (void)testAlaska {
    // Alaska is the last state
    [self assertZIP:@"99801" returnsStateCode:@"AK"];
}

- (void)testNewHampshire {
    // New Hampshire is the first state (in the US)
    [self assertZIP:@"03242" returnsStateCode:@"NH"];
}

@end
