//
//  HierarchyTest.m
//  XAspectDev
//
//  Created by Xaree on 9/25/14.
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
 After method swizzling, the method invocations and the return values through
 the hierarchy should be tested.
 */
// =============================================================================

static NSInteger basic_value = 100;
static NSInteger value_for_test1_tier1 = 1;
static NSInteger value_for_test1_tier2 = 2;
static NSInteger value_for_test1_tier3 = 3;
static NSInteger value_for_test1_tier4 = 4;
static NSInteger value_for_test1_tier5 = 5;



// We don't implement this category but declare its interface. We'll use the
// auto-synthesized default implementation.
@interface Tier1 (HierarchyTests)
+ (NSInteger)valueForHierarchyTests_AspectPatchEveryTier;
+ (NSInteger)valueForHierarchyTests_AspectPatchEvery2Tier;
@end

@implementation Tier1 (HierarchyTests)
+ (NSInteger)valueForHierarchyTests_AspectPatchEveryTier{
  return basic_value;
}
+ (NSInteger)valueForHierarchyTests_AspectPatchEvery2Tier{
  return basic_value;
}
@end


#pragma mark - Add values to tiers by XAspect
// =============================================================================
/*
 - valueForHierarchyTests_AspectPatchEveryTier: add aspect patches for every 1 hierarchy tier (Tier 1/2/3/4/5).
 - valueForHierarchyTests_AspectPatchEvery2Tier: add aspect patches for every 2 hierarchy tiers (Tier 2/4).
 */
// =============================================================================
#define AtAspect HierarchyTest
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier1
@classPatchField(Tier1)
AspectPatch(+, NSInteger, valueForHierarchyTests_AspectPatchEveryTier){
  return XAMessageForward(valueForHierarchyTests_AspectPatchEveryTier) + value_for_test1_tier1;
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier2
@classPatchField(Tier2)
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForHierarchyTests_AspectPatchEveryTier);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForHierarchyTests_AspectPatchEvery2Tier);
AspectPatch(+, NSInteger, valueForHierarchyTests_AspectPatchEveryTier) {
  return XAMessageForward(valueForHierarchyTests_AspectPatchEveryTier) + value_for_test1_tier2;
}
AspectPatch(+, NSInteger, valueForHierarchyTests_AspectPatchEvery2Tier) {
  return XAMessageForward(valueForHierarchyTests_AspectPatchEvery2Tier) + value_for_test1_tier2;
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier3
@classPatchField(Tier3)
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForHierarchyTests_AspectPatchEveryTier);
AspectPatch(+, NSInteger, valueForHierarchyTests_AspectPatchEveryTier) {
  return XAMessageForward(valueForHierarchyTests_AspectPatchEveryTier) + value_for_test1_tier3;
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier4
@classPatchField(Tier4)
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForHierarchyTests_AspectPatchEveryTier);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForHierarchyTests_AspectPatchEvery2Tier);
AspectPatch(+, NSInteger, valueForHierarchyTests_AspectPatchEveryTier) {
  return XAMessageForward(valueForHierarchyTests_AspectPatchEveryTier) + value_for_test1_tier4;
}
AspectPatch(+, NSInteger, valueForHierarchyTests_AspectPatchEvery2Tier) {
  return XAMessageForward(valueForHierarchyTests_AspectPatchEvery2Tier) + value_for_test1_tier4;
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#define AtAspectOfClass Tier5
@classPatchField(Tier5)
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForHierarchyTests_AspectPatchEveryTier);
AspectPatch(+, NSInteger, valueForHierarchyTests_AspectPatchEveryTier) {
  return XAMessageForward(valueForHierarchyTests_AspectPatchEveryTier) + value_for_test1_tier5;
}
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
#undef AtAspect


#pragma mark - Start Testing
// =============================================================================
// Start Testing
// =============================================================================
@interface HierarchyTests : XCTestCase

@end

@implementation HierarchyTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testAspectPatchForEveryOneTierThroughHierarchy
{
  // We added values to value_for_test1_tier1 for every tier
  NSInteger valueForTier1 = basic_value + value_for_test1_tier1;
  NSInteger valueForTier2 = basic_value + value_for_test1_tier1 + value_for_test1_tier2;
  NSInteger valueForTier3 = basic_value + value_for_test1_tier1 + value_for_test1_tier2 + value_for_test1_tier3;
  NSInteger valueForTier4 = basic_value + value_for_test1_tier1 + value_for_test1_tier2 + value_for_test1_tier3 + value_for_test1_tier4;
  NSInteger valueForTier5 = basic_value + value_for_test1_tier1 + value_for_test1_tier2 + value_for_test1_tier3 + value_for_test1_tier4 + value_for_test1_tier5;
  
  XCTAssertEqual(valueForTier1, 101); // +1
  XCTAssertEqual(valueForTier2, 103); // +2
  XCTAssertEqual(valueForTier3, 106); // +3
  XCTAssertEqual(valueForTier4, 110); // +4
  XCTAssertEqual(valueForTier5, 115); // +5
  
  XCTAssertEqual([Tier1 valueForHierarchyTests_AspectPatchEveryTier], valueForTier1);
  XCTAssertEqual([Tier2 valueForHierarchyTests_AspectPatchEveryTier], valueForTier2);
  XCTAssertEqual([Tier3 valueForHierarchyTests_AspectPatchEveryTier], valueForTier3);
  XCTAssertEqual([Tier4 valueForHierarchyTests_AspectPatchEveryTier], valueForTier4);
  XCTAssertEqual([Tier5 valueForHierarchyTests_AspectPatchEveryTier], valueForTier5);
}

- (void)testAspectPatchForEveryTwoTierThroughHierarchy
{
  // We added values to basic_value for every 2 tiers
  NSInteger valueForTier1 = basic_value;
  NSInteger valueForTier2 = basic_value + value_for_test1_tier2;
  NSInteger valueForTier3 = basic_value + value_for_test1_tier2;
  NSInteger valueForTier4 = basic_value + value_for_test1_tier2 + value_for_test1_tier4;
  NSInteger valueForTier5 = basic_value + value_for_test1_tier2 + value_for_test1_tier4;
  
  XCTAssertEqual(valueForTier1, 100); // -
  XCTAssertEqual(valueForTier2, 102); // +2
  XCTAssertEqual(valueForTier3, 102); // -
  XCTAssertEqual(valueForTier4, 106); // +4
  XCTAssertEqual(valueForTier5, 106); // -
  
  XCTAssertEqual([Tier1 valueForHierarchyTests_AspectPatchEvery2Tier], valueForTier1);
  XCTAssertEqual([Tier2 valueForHierarchyTests_AspectPatchEvery2Tier], valueForTier2);
  XCTAssertEqual([Tier3 valueForHierarchyTests_AspectPatchEvery2Tier], valueForTier3);
  XCTAssertEqual([Tier4 valueForHierarchyTests_AspectPatchEvery2Tier], valueForTier4);
  XCTAssertEqual([Tier5 valueForHierarchyTests_AspectPatchEvery2Tier], valueForTier5);
}



@end
