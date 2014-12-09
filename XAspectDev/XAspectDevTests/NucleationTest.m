//
//  NucleationTest.m
//  XAspectDev
//
//  Created by Xaree on 11/17/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "FunctionForTesting.h"

#import <XAspect/XAspect.h>

#import "Tier1.h"
#import "Tier2.h"
#import "Tier3.h"
#import "Tier4.h"
#import "Tier5.h"

/*
 XAspect weaving is like crystallization. It needs the nuclei (the original
 implementation) to attach the advices to (crystal growth).
 
 Nucleation is the first step of crystallization. XAspect checks whether the
 original implementation does exist before method swizzling. It's important that
 the class must have its own implementation before method swizzling. If the
 class does respond to the selector but the implementation exists in the
 superclass, in other words, the class doesn't have its own implementation for
 method swizzling, you must implement this method to call superclass'
 implementation.
 
 To ensure the class has its own implementation, you may
 
 1. Implement the method implementation in the source class.
 2. Implement the method implementation using Objective-C Category (not
	recommanded).
 3. Implement the method implementation using XAspect autosynthesize macros.
	XAspect autosynthesize macros will automatically inject the implementation
	if the class dosen't have its own implementation.
 */
// =============================================================================

static IMP nullImplementation_1_IMP;
static IMP nullImplementation_2_IMP;
static IMP nullImplementation_3_IMP;
static IMP nullImplementation_4_IMP;
static IMP nullImplementation_5_IMP;

@interface Tier1 (NucleationTests)
+ (id)nullImplementation_1;
+ (id)nullImplementation_2;
+ (id)nullImplementation_3;
+ (id)nullImplementation_4;
+ (id)nullImplementation_5;
@end


@implementation Tier1 (HierarchyTests)
+ (void)load
{
	// Cache the original implementation before weaving (method swizzling)
	nullImplementation_1_IMP = classImp([self class], @selector(nullImplementation_1));
	nullImplementation_2_IMP = classImp([self class], @selector(nullImplementation_2));
	nullImplementation_3_IMP = classImp([self class], @selector(nullImplementation_3));
	nullImplementation_4_IMP = classImp([self class], @selector(nullImplementation_4));
	nullImplementation_5_IMP = classImp([self class], @selector(nullImplementation_5));
}
@end

#pragma mark - Nucleation
// =============================================================================
// We don't implement those methods. Instead, we inject the default implementation.
// =============================================================================
#define AtAspect NucleationTest

// We attempt to load the aspect class of tier 4 before tier 1. We want to test
// whether the loading sequence will influence the weaving results or not. It
// should be the same. That's why we need the XAClassPatchCrystallizer class to
// collect the patches first, then crystallize from the root class.
#define AtAspectOfClass Tier4
@classPatchField(Tier4)
@synthesizeNucleusPatch(SuperCaller, +, id, nullImplementation_5);

AspectPatch(+, id, nullImplementation_5) {
	return @([XAMessageForward(nullImplementation_5) integerValue] + 13);
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier1
@classPatchField(Tier1)
@synthesizeNucleusPatch(Default, +, id, nullImplementation_2);
@synthesizeNucleusPatch(Default, +, id, nullImplementation_3);
@synthesizeNucleusPatch(Default, +, id, nullImplementation_4);
@synthesizeNucleusPatch(Default, +, id, nullImplementation_5);

AspectPatch(+, id, nullImplementation_2) {
	return XAMessageForward(nullImplementation_2);
}
AspectPatch(+, id, nullImplementation_3) {
	return @([XAMessageForward(nullImplementation_3) integerValue] + 5);
}
AspectPatch(+, id, nullImplementation_4) {
	return @([XAMessageForward(nullImplementation_4) integerValue] + 7);
}
AspectPatch(+, id, nullImplementation_5) {
	return @([XAMessageForward(nullImplementation_5) integerValue] + 11);
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier3
@classPatchField(Tier3)
@synthesizeNucleusPatch(SuperCaller, +, id, nullImplementation_4);
AspectPatch(+, id, nullImplementation_4) {
	return @([XAMessageForward(nullImplementation_4) integerValue] + 8);
}
@end
#undef AtAspectOfClass
#undef AtAspect // End aspect


#pragma mark - Start testing
// =============================================================================
// Start testing
// =============================================================================
@interface NucleationTest : XCTestCase

@end

@implementation NucleationTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark Test Nucleation
// Test 1: There is no implemention without nucleation (nullImplementation_1).
- (void)testNullNuleation
{
	SEL cmd = @selector(nullImplementation_1);
	IMP currentImp = classImp([Tier1 class], cmd);
	
	// Both original and current implementations are nil.
	XCTAssert(!currentImp,
			  @"The current implementation should be nil.");
	XCTAssert(!nullImplementation_2_IMP,
			  @"The original implementation should be nil.");
	
	// Invoking nullImplementation_1 through the hierarchy should throw an exception (unrecognized selector).
	XCTAssertThrows([Tier1 nullImplementation_1], @"It should throw an exception");
	XCTAssertThrows([Tier2 nullImplementation_1], @"It should throw an exception");
	XCTAssertThrows([Tier3 nullImplementation_1], @"It should throw an exception");
	XCTAssertThrows([Tier4 nullImplementation_1], @"It should throw an exception");
	XCTAssertThrows([Tier5 nullImplementation_1], @"It should throw an exception");
}

// Test 2: We try to inject the default implementation (nullImplementation_2).
- (void)testNuleationForTypeDefaultWithoutChangingReturnValue
{
	id sender = [Tier1 class];
	SEL cmd = @selector(nullImplementation_2);
	IMP currentImp = classImp([Tier1 class], cmd);
	// Successful default implementation injection for current implementation.
	XCTAssert(currentImp,
			  @"The current implementation should not be nil.");
	XCTAssert(!nullImplementation_2_IMP,
			  @"The original implementation should be nil.");
	
	// The value of original implementation and current implementation.
	NSNumber *currentRetVal = (NSNumber *)((id(*)(id,SEL))currentImp)(sender, cmd);
	XCTAssertEqualObjects(currentRetVal, nil,
						  @"The current value should be %@", nil);
	XCTAssertEqualObjects(currentRetVal, [Tier1 nullImplementation_2],
						  @"The values from implementation invocation and direct invoction should be the same.");
	
	// Recognized selector
	XCTAssertNoThrow([Tier1 nullImplementation_2], @"It should not throw an exception");
	XCTAssertNoThrow([Tier2 nullImplementation_2], @"It should not throw an exception");
	XCTAssertNoThrow([Tier3 nullImplementation_2], @"It should not throw an exception");
	XCTAssertNoThrow([Tier4 nullImplementation_2], @"It should not throw an exception");
	XCTAssertNoThrow([Tier5 nullImplementation_2], @"It should not throw an exception");
	
	// Null return value
	XCTAssertNil([Tier1 nullImplementation_2], @"The default Implementation should return nil.");
	XCTAssertNil([Tier2 nullImplementation_2], @"The default Implementation should return nil.");
	XCTAssertNil([Tier3 nullImplementation_2], @"The default Implementation should return nil.");
	XCTAssertNil([Tier4 nullImplementation_2], @"The default Implementation should return nil.");
	XCTAssertNil([Tier5 nullImplementation_2], @"The default Implementation should return nil.");
}

// Test 3: We try to inject the default implementation and modify the return value (nullImplementation_3).
- (void)testNuleationForTypeDefaultWithChangingReturnValue
{
	id sender = [Tier1 class];
	SEL cmd = @selector(nullImplementation_3);
	IMP currentImp = classImp([Tier1 class], cmd);
	// Successful default implementation injection for current implementation.
	XCTAssert(currentImp,
			  @"The current implementation should not be nil.");
	XCTAssert(!nullImplementation_3_IMP,
			  @"The original implementation should be nil.");
	
	// The value of original implementation and current implementation.
	NSNumber *currentRetVal = (NSNumber *)((id(*)(id,SEL))currentImp)(sender, cmd);
	XCTAssertEqualObjects(currentRetVal, @5,
						  @"The current value should be %@", @5);
	XCTAssertEqualObjects(currentRetVal, [Tier1 nullImplementation_3],
						  @"The values from implementation invocation and direct invoction should be the same.");
	
	// Recognized selector
	XCTAssertNoThrow([Tier1 nullImplementation_3], @"It should not throw an exception");
	XCTAssertNoThrow([Tier2 nullImplementation_3], @"It should not throw an exception");
	XCTAssertNoThrow([Tier3 nullImplementation_3], @"It should not throw an exception");
	XCTAssertNoThrow([Tier4 nullImplementation_3], @"It should not throw an exception");
	XCTAssertNoThrow([Tier5 nullImplementation_3], @"It should not throw an exception");
	
	// Modified return value
	XCTAssertEqualObjects([Tier1 nullImplementation_3], @5);
	XCTAssertEqualObjects([Tier2 nullImplementation_3], @5);
	XCTAssertEqualObjects([Tier3 nullImplementation_3], @5);
	XCTAssertEqualObjects([Tier4 nullImplementation_3], @5);
	XCTAssertEqualObjects([Tier5 nullImplementation_3], @5);
}

// Test 4: We try to inject an super caller implementation at tier 3 to modify the return value (nullImplementation_4).
- (void)testNuleationForTypeDefaultFollowedBySuperCallerInjection
{
	id sender = [Tier1 class];
	SEL cmd = @selector(nullImplementation_4);
	IMP currentImp = classImp([Tier1 class], cmd);
	// Successful default implementation injection for current implementation.
	XCTAssert(currentImp,
			  @"The current implementation should not be nil.");
	XCTAssert(!nullImplementation_4_IMP,
			  @"The original implementation should be nil.");
	
	// The value of original implementation and current implementation.
	NSNumber *currentRetVal = (NSNumber *)((id(*)(id,SEL))currentImp)(sender, cmd);
	XCTAssertEqualObjects(currentRetVal, @7,
						  @"The current value should be %@", @7);
	XCTAssertEqualObjects(currentRetVal, [Tier1 nullImplementation_4],
						  @"The values from implementation invocation and direct invoction should be the same.");
	
	// Recognized selector
	XCTAssertNoThrow([Tier1 nullImplementation_4], @"It should not throw an exception");
	XCTAssertNoThrow([Tier2 nullImplementation_4], @"It should not throw an exception");
	XCTAssertNoThrow([Tier3 nullImplementation_4], @"It should not throw an exception");
	XCTAssertNoThrow([Tier4 nullImplementation_4], @"It should not throw an exception");
	XCTAssertNoThrow([Tier5 nullImplementation_4], @"It should not throw an exception");
	
	// Modified return value
	XCTAssertEqualObjects([Tier1 nullImplementation_4], @7);
	XCTAssertEqualObjects([Tier2 nullImplementation_4], @7);
	XCTAssertEqualObjects([Tier3 nullImplementation_4], @15);
	XCTAssertEqualObjects([Tier4 nullImplementation_4], @15);
	XCTAssertEqualObjects([Tier5 nullImplementation_4], @15);
}

// Test 5: The loading sequence should not influence the weaving sequence and
// results. XAspect should always weave its superclass first.
- (void)testWeavingSequenceForNuleation
{
	id sender = [Tier1 class];
	SEL cmd = @selector(nullImplementation_5);
	IMP currentImp = classImp([Tier1 class], cmd);
	// Successful default implementation injection for current implementation.
	XCTAssert(currentImp,
			  @"The current implementation should not be nil.");
	XCTAssert(!nullImplementation_5_IMP,
			  @"The original implementation should be nil.");
	
	// The value of original implementation and current implementation.
	NSNumber *currentRetVal = (NSNumber *)((id(*)(id,SEL))currentImp)(sender, cmd);
	XCTAssertEqualObjects(currentRetVal, @11,
						  @"The current value should be %@", @11);
	XCTAssertEqualObjects(currentRetVal, [Tier1 nullImplementation_5],
						  @"The values from implementation invocation and direct invoction should be the same.");
	
	// Recognized selector
	XCTAssertNoThrow([Tier1 nullImplementation_5], @"It should not throw an exception");
	XCTAssertNoThrow([Tier2 nullImplementation_5], @"It should not throw an exception");
	XCTAssertNoThrow([Tier3 nullImplementation_5], @"It should not throw an exception");
	XCTAssertNoThrow([Tier4 nullImplementation_5], @"It should not throw an exception");
	XCTAssertNoThrow([Tier5 nullImplementation_5], @"It should not throw an exception");

	// Modified return value
	XCTAssertEqualObjects([Tier1 nullImplementation_5], @11);
	XCTAssertEqualObjects([Tier2 nullImplementation_5], @11);
	XCTAssertEqualObjects([Tier3 nullImplementation_5], @11);
	XCTAssertEqualObjects([Tier4 nullImplementation_5], @24);
	XCTAssertEqualObjects([Tier5 nullImplementation_5], @24);
}



@end
