//
//  CustomizedSupercalllerPatchTest.m
//  XAspectDev
//
//  Created by Xaree on 12/8/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XAspect.h>


#import "Tier1.h"
#import "Tier2.h"
#import "Tier3.h"
#import "Tier4.h"
#import "Tier5.h"


@interface Tier1 (CustomizedSupercalllerPatchTest)
+ (NSInteger)valueForSupercallerForwardMacro1;
+ (NSInteger)valueForSupercallerPriority;
+ (NSInteger)valueForSupercallerSequence1;
+ (NSInteger)valueForSupercallerSequence2;
+ (NSInteger)valueForSupercallerSequence3;
@end
@implementation Tier1 (CustomizedSupercalllerPatchTest)
+ (NSInteger)valueForSupercallerForwardMacro1{
	return 52;
}
+ (NSInteger)valueForSupercallerPriority{
	return 73;
}
+ (NSInteger)valueForSupercallerSequence1{
	return 98;
}
+ (NSInteger)valueForSupercallerSequence2{
	return 2001;
}
+ (NSInteger)valueForSupercallerSequence3{
	return 7003;
}
@end

#define AtAspect CustomizedSupercalllerPatchTest

@interface Tier2 (CustomizedSupercalllerPatchTest)
+ (NSInteger)invokeXAMessageForwardSuper;
+ (NSInteger)invokeXAMessageForwardSuperDirectly;
@end


#define AtAspectOfClass Tier2
@classPatchField(Tier2)

@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForSupercallerForwardMacro1);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForSupercallerPriority);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForSupercallerSequence1);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForSupercallerSequence2);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForSupercallerSequence3);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForSupercallerSequence3);
@synthesizeNucleusPatch(SuperCaller, +, NSInteger, valueForSupercallerSequence3);

// To test `XAMessageForwardSuper` and `XAMessageForwardSuperDirectly`.
+ (NSInteger)invokeXAMessageForwardSuper{
	return XAMessageForwardSuper(valueForSupercallerForwardMacro1);
}
+ (NSInteger)invokeXAMessageForwardSuperDirectly{
	return XAMessageForwardSuperDirectly(valueForSupercallerForwardMacro1);
}

// The Customize supercaller with priority
@tryCustomizeSupercallerPatch(63, +, NSInteger, valueForSupercallerPriority){
	return XAMessageForwardSuper(valueForSupercallerPriority) + 49;
}

// Test priority and sequence
@tryCustomizeSupercallerPatch(3, +, NSInteger, valueForSupercallerSequence1){
	return XAMessageForwardSuper(valueForSupercallerSequence1) + 3;
}
@tryCustomizeSupercallerPatch(33, +, NSInteger, valueForSupercallerSequence1){
	return XAMessageForwardSuper(valueForSupercallerSequence1) + 33;
}
@tryCustomizeSupercallerPatch(333, +, NSInteger, valueForSupercallerSequence1){ // Highest priority
	return XAMessageForwardSuper(valueForSupercallerSequence1) + 333;
}

@tryCustomizeSupercallerPatch(333, +, NSInteger, valueForSupercallerSequence2){ // Highest priority
	return XAMessageForwardSuper(valueForSupercallerSequence2) + 3;
}
@tryCustomizeSupercallerPatch(3, +, NSInteger, valueForSupercallerSequence2){
	return XAMessageForwardSuper(valueForSupercallerSequence2) + 33;
}
@tryCustomizeSupercallerPatch(33, +, NSInteger, valueForSupercallerSequence2){
	return XAMessageForwardSuper(valueForSupercallerSequence2) + 333;
}

@tryCustomizeSupercallerPatch(3, +, NSInteger, valueForSupercallerSequence3){
	return XAMessageForwardSuper(valueForSupercallerSequence3) + 3;
}
@tryCustomizeSupercallerPatch(333, +, NSInteger, valueForSupercallerSequence3){ // Highest priority
	return XAMessageForwardSuper(valueForSupercallerSequence3) + 33;
}
@tryCustomizeSupercallerPatch(33, +, NSInteger, valueForSupercallerSequence3){
	return XAMessageForwardSuper(valueForSupercallerSequence3) + 333;
}

@end


@interface CustomizedSupercalllerPatchTest : XCTestCase

@end

@implementation CustomizedSupercalllerPatchTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testXAMessageForwardSuperMacro{
	// Test XAMessageForwardSuper
	
	// We inject safe category patch, and invoke `XAMessageForwardSuper` inside.
    XCTAssertEqual([Tier2 invokeXAMessageForwardSuper], 52,
				   "The macro `XAMessageForwardSuper()` should work.");
	XCTAssertEqual([Tier2 invokeXAMessageForwardSuperDirectly], 52,
				   "The macro `invokeXAMessageForwardSuperDirectly()` should work.");
}

- (void)testTryCustomizeSupercallerPatchMacro
{
	// The customize supercaller should overwrite the supercaller from
	// `@synthesizeNucleusPatch()`.
	XCTAssertEqual([Tier2 valueForSupercallerPriority], 122,
				   "The macro `@tryCustomizeSupercallerPatch()` should work. The priority is higher than");
}

- (void)testTryCustomizeSupercallerPatchPriority
{
	// The loading/implementation sequence should not influence the results of priority competition.
	XCTAssertEqual([Tier2 valueForSupercallerSequence1], 431,
				   "The priority in `@tryCustomizeSupercallerPatch()` should work and no matter what the sequence is.");
	XCTAssertEqual([Tier2 valueForSupercallerSequence2], 2004,
				   "The priority in `@tryCustomizeSupercallerPatch()` should work and no matter what the sequence is.");
	XCTAssertEqual([Tier2 valueForSupercallerSequence3], 7036,
				   "The priority in `@tryCustomizeSupercallerPatch()` should work and no matter what the sequence is.");
}

@end


