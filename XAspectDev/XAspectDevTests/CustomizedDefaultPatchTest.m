//
//  CustomizedDefaultPatchTest.m
//  XAspectDev
//
//  Created by Xaree on 12/5/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XAspect.h>


// =============================================================================
#pragma mark - Prepare Materials to Test
// =============================================================================
@protocol CustomizedDefaultPatch <NSObject>
@optional
+ (NSInteger)valueForTest1;
+ (NSInteger)valueForTest2;
+ (NSInteger)valueForTestCustomizedDefaultPatch;
+ (NSInteger)valueForTestCustomizedDefaultPatch2;

+ (NSInteger)valueForTestPriorityAndLoadingSequence1;
+ (NSInteger)valueForTestPriorityAndLoadingSequence2;
+ (NSInteger)valueForTestPriorityAndLoadingSequence3;
@end
// We don't implement the protocol. Only leave the interface.
@interface CustomizedDefaultPatch : NSObject <CustomizedDefaultPatch>
@end

@implementation CustomizedDefaultPatch
@end

// -----------------------------------------------------------------------------
#define AtAspect CustomizedDefaultPatchTest
#define AtAspectOfClass CustomizedDefaultPatch
@classPatchField(CustomizedDefaultPatch)

// Which will return a 0.
@synthesizeNucleusPatch(Default, +, NSInteger, valueForTest2);

// Test the competition from `@synthesizeNucleusPatch`
@synthesizeNucleusPatch(Default, +, NSInteger, valueForTestCustomizedDefaultPatch);
@tryCustomizeDefaultPatch(5, +, NSInteger, valueForTestCustomizedDefaultPatch){
  return 5;
}
@tryCustomizeDefaultPatch(5, +, NSInteger, valueForTestCustomizedDefaultPatch2){
  return 90;
}

// We don't synthesize any nucleus for customized default patches.

@tryCustomizeDefaultPatch(500, +, NSInteger, valueForTestPriorityAndLoadingSequence1){ // The highest priority
  return 77;
}
@tryCustomizeDefaultPatch(50, +, NSInteger, valueForTestPriorityAndLoadingSequence1){
  return 88;
}
@tryCustomizeDefaultPatch(5, +, NSInteger, valueForTestPriorityAndLoadingSequence1){
  return 99;
}

@tryCustomizeDefaultPatch(50, +, NSInteger, valueForTestPriorityAndLoadingSequence2){
  return 77;
}
@tryCustomizeDefaultPatch(500, +, NSInteger, valueForTestPriorityAndLoadingSequence2){ // The highest priority
  return 88;
}
@tryCustomizeDefaultPatch(5, +, NSInteger, valueForTestPriorityAndLoadingSequence2){
  return 99;
}

@tryCustomizeDefaultPatch(50, +, NSInteger, valueForTestPriorityAndLoadingSequence3){
  return 77;
}
@tryCustomizeDefaultPatch(5, +, NSInteger, valueForTestPriorityAndLoadingSequence3){
  return 88;
}
@tryCustomizeDefaultPatch(500, +, NSInteger, valueForTestPriorityAndLoadingSequence3){ // The highest priority
  return 99;
}




@end

// -----------------------------------------------------------------------------

@interface CustomizedDefaultPatchTest : XCTestCase

@end

@implementation CustomizedDefaultPatchTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testSynthesizeNucleus
{
  // Test @synthesizeNucleusPatch()
  XCTAssertThrows([CustomizedDefaultPatch valueForTest1],
                  @"We don't either implement or synthesize the implementation of `valueForTest1`. It should throw an exception.");
  
  XCTAssertEqual([CustomizedDefaultPatch valueForTest2], 0,
                 @"We synthesize an default implementation which returns a null value for the return type via `@synthesizeNucleusPatch()`. It value should be 0.");
}

- (void)testCustomizeDefaultPatch
{
  // With `@synthesizeNucleusPatch()` competition
  XCTAssertEqual([CustomizedDefaultPatch valueForTestCustomizedDefaultPatch], 5,
                 @"We synthesize an customized default implementation. The value shouldn't be 0. It should be 5.");
  
  // Without `@synthesizeNucleusPatch()` competition
  XCTAssertEqual([CustomizedDefaultPatch valueForTestCustomizedDefaultPatch2], 90,
                 @"We synthesize an customized default implementation without `@synthesizeNucleusPatch()`. The value shouldn't be 0. It should be 90.");
}

- (void)testCustomizeDefaultPriorities
{
  // The loading/implementation sequence should not influence the results of priority competition.
  XCTAssertEqual([CustomizedDefaultPatch valueForTestPriorityAndLoadingSequence1], 77);
  XCTAssertEqual([CustomizedDefaultPatch valueForTestPriorityAndLoadingSequence2], 88);
  XCTAssertEqual([CustomizedDefaultPatch valueForTestPriorityAndLoadingSequence3], 99);
}


@end
