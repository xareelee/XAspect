//
//  MethodPrefixTest.m
//  XAspectDev
//
//  Created by Xaree on 12/9/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XAspect.h>
#import "FunctionForTesting.h"

@interface MethodPrefixTest : XCTestCase

@end

@implementation MethodPrefixTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

// -----------------------------------------------------------------------------
#pragma mark - Macro Prefix Test
// -----------------------------------------------------------------------------
- (void)testPriorityPrefixedMethod
{
  // The priority prefix will be used in customized default patched and
  // customized supercaller patches.
  XCTAssertMacro(_XAspectPriorityMethodPrefix,
                 "_Priority_");
  
  XCTAssertMacro(_XAspectCustomizedMethodJoiner,
                 "_ForCustomization__");
  
  XCTAssertMacro(_PriorityPrefixMethodBody(7, init),
                 "_Priority_7_ForCustomization__init");
}

// You can replace the method name or selctor name for testing the prefixed name.
- (void)testDefaultPrefixedMethod
{
  // Default method prefix.
  XCTAssertMacro(_XADefaultPrefix,
                 "_XAspectDefault_");
  
  // Default prefixed method.
  // Because the default patch only exists in the aspect class, the selector
  // will not be exposed in the target class. So the selector name doesn't
  // need to be unique in the class hierarchy.
  XCTAssertMacro(_XADefaultPrefixMethod(init),
                 "_XAspectDefault_init");
}

- (void)testCustomizedDefaultPrefixedMethod
{
  // Customized default method with priority.
  XCTAssertMacro(_customizedDefaultPrefixMethodBody(7, init),
                 "_XAspectDefault__Priority_7_ForCustomization__init");
}

- (void)testSuperCallerPrefixedMethod
{
  // Test super-caller method prefix
  XCTAssertMacro(_XACallSuperKeyword,
                 "_XAspectCallSuperImp_");
  
  // Test super-caller method name.
  // The selector name should be unique in the class hierarchy due to it is
  // implemented in the target class and may be conflicted to other
  // implementation.
  XCTAssertMacro(_XACallSuperMethod(NSObject, init),
                 "NSObject_XAspectCallSuperImp_init");
}

- (void)testCustomizedSupercallerPrefixedMethod
{
  // Customized supercaller method with priority.
#define AtAspectOfClass NSObject
  XCTAssertMacro(_customizedSupercallerPrefixMethodBody(7, init),
                 "NSObject_XAspectCallSuperImp__Priority_7_ForCustomization__init");
#undef AtAspect
}

- (void)testAspectPrefixedMethod
{
#define AtAspect HelloWorld
  // Test synthesized aspect method prefix for a class
  XCTAssertMacro(_XAAspectMethodPrefix(NSObject),
                 "_AtAspect_HelloWorld_OfClass_NSObject__");
  
  // Test the aspect prefiexed method name
  XCTAssertMacro(_XAAspectPrefixedMethodBody(NSObject, init),
                 "_AtAspect_HelloWorld_OfClass_NSObject__init");
#undef AtAspect
}

@end
