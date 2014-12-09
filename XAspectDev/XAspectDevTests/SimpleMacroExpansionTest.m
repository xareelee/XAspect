//
//  SimpleMacroExpansionTest.m
//  XAspectDev
//
//  Created by Xaree on 11/25/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XAspect.h>
#import <XAspect/XACExtensions.h>
#import "FunctionForTesting.h"


@interface SimpleMacroExpansionTest : XCTestCase

@end

@implementation SimpleMacroExpansionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


// -----------------------------------------------------------------------------
#pragma mark -Aspect Keyword Test
// -----------------------------------------------------------------------------
- (void)testAspectClassName
{
	XCTAssertMacro(_XAspect_Class_For_Aspect(NSObject, TestAspect),
				   "_AtAspect_TestAspect_OfClass_NSObject_");
}

// -----------------------------------------------------------------------------
#pragma mark -Default aspect return Test
// -----------------------------------------------------------------------------
- (void)testDefaultImplementationForReturnType
{
	// Return type: id
	XCTAssertMacro(_XANullReturnValueImplementation(id),
				   "{ id retVal; __builtin___memset_chk (&(retVal), 0, sizeof(id), __builtin_object_size (&(retVal), 0)); return retVal; }");
	
	// Return type: instancetype (We should convert the type instancetype to id)
	XCTAssertMacro(_XANullReturnValueImplementation(instancetype),
				   metamacro_stringify(_XANullReturnValueImplementation(id)));
	
	// Return type: structure (CGRect)
	XCTAssertMacro(_XANullReturnValueImplementation(CGRect),
				   "{ CGRect retVal; __builtin___memset_chk (&(retVal), 0, sizeof(CGRect), __builtin_object_size (&(retVal), 0)); return retVal; }");
	
	// Return type: pointer (ObjC object)
	XCTAssertMacro(_XANullReturnValueImplementation(NSString *),
				   "{ NSString * retVal; __builtin___memset_chk (&(retVal), 0, sizeof(NSString *), __builtin_object_size (&(retVal), 0)); return retVal; }");
	
	// Return type: pointer of pointer
	XCTAssertMacro(_XANullReturnValueImplementation(NSError **),
				   "{ NSError ** retVal; __builtin___memset_chk (&(retVal), 0, sizeof(NSError **), __builtin_object_size (&(retVal), 0)); return retVal; }");
	
	// Return type: void (**just return**)
	XCTAssertMacro(_XANullReturnValueImplementation(void),
				   "{return;}");
}


@end
