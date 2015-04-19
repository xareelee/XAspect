//
//  ObjCRuntimeTest.m
//  XAspectDev
//
//  Created by Xaree on 11/29/14.
//  Copyright (c) 2015 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XACExtensions.h>
#import "FunctionForTesting.h"

#import "Tier1.h"
#import "Tier2.h"
#import "Tier3.h"
#import "Tier4.h"
#import "Tier5.h"


@protocol XAspectImplementationType <NSObject>
@optional
+ (NSInteger)implementation_1; // We don't implement this method.
+ (NSInteger)implementation_2; // We implement this method only in Tier 1.
+ (NSInteger)implementation_3; // We implement this method only in Tier 2.
+ (NSInteger)implementation_4; // We implement this method in both Tier 1 and Tier 2.
@end

@interface Tier1 (ObjCRuntimeTest) <XAspectImplementationType>
@end
@implementation Tier1 (ObjCRuntimeTest)
+ (NSInteger)implementation_2{ return 2; }
+ (NSInteger)implementation_4{ return 4; }
@end
@implementation Tier2 (ObjCRuntimeTest)
+ (NSInteger)implementation_3{ return 30; }
+ (NSInteger)implementation_4{ return [super implementation_4] + 40; }
@end


@interface ObjCRuntimeTest : XCTestCase

@end

@implementation ObjCRuntimeTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testImplementationType
{
  // We test `originImplementationType()` function here.
  Class metaclassOfTier2 = objc_getMetaClass("Tier2");
  XCTAssertEqual(originImplementationType(metaclassOfTier2, @selector(implementation_1)),
                 XAOriginImpTypeNotExists);
  
  XCTAssertEqual(originImplementationType(metaclassOfTier2, @selector(implementation_2)),
                 XAOriginImpTypeExistsInSuperclass);
  
  XCTAssertEqual(originImplementationType(metaclassOfTier2, @selector(implementation_3)),
                 XAOriginImpTypeExists);
  
  XCTAssertEqual(originImplementationType(metaclassOfTier2, @selector(implementation_3)),
                 XAOriginImpTypeExists);
}

@end
