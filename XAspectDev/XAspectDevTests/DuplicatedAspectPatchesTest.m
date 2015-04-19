//
//  DuplicatedAspectPatchesTest.m
//  XAspectDev
//
//  Created by Xaree on 12/15/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XAspect.h>

@interface DuplicatedAspectPatchesTest : XCTestCase

@end

@implementation DuplicatedAspectPatchesTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testWarnings
{
  XCTAssertEqual(XAspectWarningCounts, 4,
                 @"The count should be equal to the number of aspect patches in Aspect-Foundation_UnicodifyingDescriptionsOfObjects.m due to shared implementation.");
}

- (void)testDuplicatedAspectPatches {
  // This is an example of a functional test case.
  NSArray *array = @[@"如果你不愛我",
                     @"我會讓你走",
                     @"如果你真心愛我",
                     @"我會讓你擁有全世界",
                     @{@"真的嗎？":@"真的"}
                     ];
  
  NSString *descriptionOfArray = @"[\n\t\"如果你不愛我\",\n\t\"我會讓你走\",\n\t\"如果你真心愛我\",\n\t\"我會讓你擁有全世界\",\n\t{\n\t\t\"真的嗎？\" : \"真的\"\n\t}\n]" ;
  
  // Foundation_UnicodifyingDescriptionsOfObjects should generate duplicated
  // aspect patches for the same target
  XCTAssert([[array description] isEqualToString:descriptionOfArray],
            @"The string should be equal via aspect 'Foundation_UnicodifyingDescriptionsOfObjects'.");
}


@end
