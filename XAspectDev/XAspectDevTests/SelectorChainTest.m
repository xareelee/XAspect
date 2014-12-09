//
//  SelectorChainTest.m
//  XAspectDev
//
//  Created by Xaree on 11/28/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FunctionForTesting.h"
#import <XAspect/XAspect.h>

#import "Tier1.h"
#import "Tier2.h"
#import "Tier3.h"
#import "Tier4.h"
#import "Tier5.h"


@interface Tier1 (SelectorChainTest)
+ (NSArray *)selectorChainTest;
@end

@implementation Tier1 (SelectorChainTest)
+ (NSArray *)selectorChainTest;{ return @[]; }
@end


// -----------------------------------------------------------------------------
#define AtAspect SelectorChainTestA

#define AtAspectOfClass Tier1
@classPatchField(Tier1)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@1];
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier2
@classPatchField(Tier2)
@synthesizeNucleusPatch(SuperCaller, +, NSArray *, selectorChainTest);
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@2];
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier3
@classPatchField(Tier3)
@synthesizeNucleusPatch(SuperCaller, +, NSArray *, selectorChainTest);
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@3];
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier4
@classPatchField(Tier4)
@synthesizeNucleusPatch(SuperCaller, +, NSArray *, selectorChainTest);
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@4];
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier5
@classPatchField(Tier5)
@synthesizeNucleusPatch(SuperCaller, +, NSArray *, selectorChainTest);
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@5];
}
@end
#undef AtAspectOfClass
#undef AtAspect
// -----------------------------------------------------------------------------
#define AtAspect SelectorChainTestB
#define AtAspectOfClass Tier1
@classPatchField(Tier1)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@1];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier2
@classPatchField(Tier2)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@2];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier3
@classPatchField(Tier3)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@3];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier4
@classPatchField(Tier4)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@4];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier5
@classPatchField(Tier5)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@5];
}
@end
#undef AtAspectOfClass
#undef AtAspect
// -----------------------------------------------------------------------------
#define AtAspect SelectorChainTestC
#define AtAspectOfClass Tier1
@classPatchField(Tier1)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@1];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier2
@classPatchField(Tier2)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@2];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier3
@classPatchField(Tier3)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@3];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier4
@classPatchField(Tier4)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@4];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier5
@classPatchField(Tier5)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@5];
}
@end
#undef AtAspectOfClass
#undef AtAspect
// -----------------------------------------------------------------------------
#define AtAspect SelectorChainTestD
#define AtAspectOfClass Tier1
@classPatchField(Tier1)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@1];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier2
@classPatchField(Tier2)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@2];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier3
@classPatchField(Tier3)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@3];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier4
@classPatchField(Tier4)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@4];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier5
@classPatchField(Tier5)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@5];
}
@end
#undef AtAspectOfClass
#undef AtAspect
// -----------------------------------------------------------------------------
#define AtAspect SelectorChainTestE
#define AtAspectOfClass Tier1
@classPatchField(Tier1)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@1];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier2
@classPatchField(Tier2)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@2];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier3
@classPatchField(Tier3)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@3];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier4
@classPatchField(Tier4)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@4];
}
@end
#undef AtAspectOfClass
#define AtAspectOfClass Tier5
@classPatchField(Tier5)
AspectPatch(+, NSArray *, selectorChainTest) {
	return [XAMessageForward(selectorChainTest) arrayByAddingObject:@5];
}
@end
#undef AtAspectOfClass
#undef AtAspect
// -----------------------------------------------------------------------------




@interface SelectorChainTest : XCTestCase

@end

@implementation SelectorChainTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSelectorChain
{
	XCTAssertEqual([[Tier1 selectorChainTest] count], 5,
				   @"The selector chain should be chained up.") ;
	XCTAssertEqual([[Tier2 selectorChainTest] count], 10,
				   @"The selector chain should be chained up.") ;
	XCTAssertEqual([[Tier3 selectorChainTest] count], 15,
				   @"The selector chain should be chained up.") ;
	XCTAssertEqual([[Tier4 selectorChainTest] count], 20,
				   @"The selector chain should be chained up.") ;
	XCTAssertEqual([[Tier5 selectorChainTest] count], 25,
				   @"The selector chain should be chained up.") ;
	
	NSArray *testArray = [Tier5 selectorChainTest];
	XCTAssertEqualObjects(testArray[0], @1);
	XCTAssertEqualObjects(testArray[1], @1);
	XCTAssertEqualObjects(testArray[2], @1);
	XCTAssertEqualObjects(testArray[3], @1);
	XCTAssertEqualObjects(testArray[4], @1);
	XCTAssertEqualObjects(testArray[5], @2);
	XCTAssertEqualObjects(testArray[6], @2);
	XCTAssertEqualObjects(testArray[7], @2);
	XCTAssertEqualObjects(testArray[8], @2);
	XCTAssertEqualObjects(testArray[9], @2);
	XCTAssertEqualObjects(testArray[10], @3);
	XCTAssertEqualObjects(testArray[11], @3);
	XCTAssertEqualObjects(testArray[12], @3);
	XCTAssertEqualObjects(testArray[13], @3);
	XCTAssertEqualObjects(testArray[14], @3);
	XCTAssertEqualObjects(testArray[15], @4);
	XCTAssertEqualObjects(testArray[16], @4);
	XCTAssertEqualObjects(testArray[17], @4);
	XCTAssertEqualObjects(testArray[18], @4);
	XCTAssertEqualObjects(testArray[19], @4);
	XCTAssertEqualObjects(testArray[20], @5);
	XCTAssertEqualObjects(testArray[21], @5);
	XCTAssertEqualObjects(testArray[22], @5);
	XCTAssertEqualObjects(testArray[23], @5);
	XCTAssertEqualObjects(testArray[24], @5);
}


@end
