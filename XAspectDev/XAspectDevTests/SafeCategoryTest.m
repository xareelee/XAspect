//
//  SafeCategoryTest.m
//  XAspectDev
//
//  Created by Xaree on 11/28/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XAspect.h>
#import <XAspect/XACExtensions.h>
#import "FunctionForTesting.h"

#import "Tier1.h"
#import "Tier2.h"
#import "Tier3.h"
#import "Tier4.h"
#import "Tier5.h"


#define AtAspect SafeCategoryTest

@interface Tier1 (SafeCategoryTest)
+ (NSInteger)testSafeCategoryInjection;
@end

#define AtAspectOfClass Tier1
@classPatchField(Tier1)
+ (NSInteger)testSafeCategoryInjection{
  return 9527;
}
@end


@interface SafeCategoryTest : XCTestCase

@end

@implementation SafeCategoryTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testSafeCategoryInjection
{
  XCTAssertEqual([Tier1 testSafeCategoryInjection], 9527);
}


@end
