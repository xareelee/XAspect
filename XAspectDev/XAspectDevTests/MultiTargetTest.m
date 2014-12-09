//
//  MultiTargetTest.m
//  XAspectDev
//
//  Created by Xaree on 11/30/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SharedClassBetweenTargets.h"
#import <XAspect/XAspect.h>
#import <XAspect/XACExtensions.h>


#define AtAspect TargetTestFromTest  // A name for your aspect field

@interface SharedClassBetweenTargets(TargetTestFromTest)
+ (NSInteger) _AtAspect_TargetTestFromTest_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets;
+ (NSInteger) _AtAspect_TargetTestFromProduct_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets;
@end


#define AtAspectOfClass SharedClassBetweenTargets
@classPatchField(SharedClassBetweenTargets)

AspectPatch(+, NSInteger, valueForSharedClassBetweenTargets) {
	return XAMessageForward(valueForSharedClassBetweenTargets) + 3;
}
@end


@interface MultiTargetTest : XCTestCase

@end

@implementation MultiTargetTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMultipleTargetsWeaving {
	// We haven't succeeded to pass multiple target loading test yet.
	
	
	const char *className = NSStringFromClass([SharedClassBetweenTargets class]).UTF8String;
	Class cls = objc_getClass(className);
	Class metaclass = objc_getMetaClass(className);
	printMethodsForClass(metaclass);
	NSLog(@"class <%p/%p>", cls, metaclass);
	
	NSLog(@"Test value (current selector): %ld <%p>",
		  [SharedClassBetweenTargets valueForSharedClassBetweenTargets],
		  method_getImplementation(class_getInstanceMethod(metaclass, @selector(valueForSharedClassBetweenTargets))));
	NSLog(@"Test value (test aspect selector): %ld <%p>",
		  [SharedClassBetweenTargets _AtAspect_TargetTestFromTest_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets],
		  method_getImplementation(class_getInstanceMethod(metaclass, @selector(_AtAspect_TargetTestFromTest_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets))));
	NSLog(@"Test value (product aspect selector): %ld <%p>",
		  [SharedClassBetweenTargets _AtAspect_TargetTestFromProduct_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets],
		  method_getImplementation(class_getInstanceMethod(metaclass, @selector(_AtAspect_TargetTestFromProduct_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets))));
	
	XCTAssertEqual([SharedClassBetweenTargets valueForSharedClassBetweenTargets], 123);
	XCTAssertEqual([SharedClassBetweenTargets _AtAspect_TargetTestFromTest_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets], 100);
	XCTAssertEqual([SharedClassBetweenTargets _AtAspect_TargetTestFromProduct_OfClass_SharedClassBetweenTargets__valueForSharedClassBetweenTargets], 103);
}


@end
#undef AtAspectOfClass 
