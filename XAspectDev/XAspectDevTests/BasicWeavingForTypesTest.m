//
//  BasicWeavingForTypesTest.m
//  BasicWeavingForTypesTest
//
//  Created by Xaree on 2014/8/29.
//  Copyright (c) 2014年 Xaree Lee. All rights reserved.
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

static double accuracy = 1E-6;

static IMP classMethodReturnIdObjectIMP;
static IMP classMethodReturnStringIMP;
static IMP classMethodReturnRectIMP;
static IMP classMethodReturnMutableArrayIMP;
static IMP classMethodReturnDoubleIMP;
static IMP classMethodReturnFloatIMP;

static IMP instanceMethodReturnIdObjectIMP;
static IMP instanceMethodReturnStringIMP;
static IMP instanceMethodReturnRectIMP;
static IMP instanceMethodReturnMutableArrayIMP;
static IMP instanceMethodReturnDoubleIMP;
static IMP instanceMethodReturnFloatIMP;

@interface Tier1 (BasicWeavingForTypesTest)
+ (id)classMethodReturnIdObject;
+ (NSString *)classMethodReturnString;
+ (CGRect)classMethodReturnRect;
+ (NSMutableArray *)classMethodReturnMutableArray;
+ (double)classMethodReturnDouble;
+ (float)classMethodReturnFloat;

- (id)instanceMethodReturnIdObject;
- (NSString *)instanceMethodReturnString;
- (CGRect)instanceMethodReturnRect;
- (NSMutableArray *)instanceMethodReturnMutableArray;
- (double)instanceMethodReturnDouble;
- (float)instanceMethodReturnFloat;
@end

@implementation Tier1 (BasicWeavingForTypesTest)

+ (void)load
{
  // Cache the original implementation before weaving (method swizzling)
  classMethodReturnIdObjectIMP = classImp([self class], @selector(classMethodReturnIdObject));
  classMethodReturnStringIMP = classImp([self class], @selector(classMethodReturnString));
  classMethodReturnRectIMP = classImp([self class], @selector(classMethodReturnRect));
  classMethodReturnMutableArrayIMP = classImp([self class], @selector(classMethodReturnMutableArray));
  classMethodReturnDoubleIMP = classImp([self class], @selector(classMethodReturnDouble));
  classMethodReturnFloatIMP = classImp([self class], @selector(classMethodReturnFloat));
  
  instanceMethodReturnIdObjectIMP = instanceImp([self class], @selector(instanceMethodReturnIdObject));
  instanceMethodReturnStringIMP = instanceImp([self class], @selector(instanceMethodReturnString));
  instanceMethodReturnRectIMP = instanceImp([self class], @selector(instanceMethodReturnRect));
  instanceMethodReturnMutableArrayIMP = instanceImp([self class], @selector(instanceMethodReturnMutableArray));
  instanceMethodReturnDoubleIMP = instanceImp([self class], @selector(instanceMethodReturnDouble));
  instanceMethodReturnFloatIMP = instanceImp([self class], @selector(instanceMethodReturnFloat));
}

+ (id)classMethodReturnIdObject{
  return @1;
}
+ (NSString *)classMethodReturnString{
  return @"2";
}
+ (CGRect)classMethodReturnRect{
  return CGRectMake(1, 2, 3, 4);
}
+ (NSMutableArray *)classMethodReturnMutableArray{
  return [@[@"A"] mutableCopy];
}
+ (double)classMethodReturnDouble{
  return (double) 2.345678901;
}
+ (float)classMethodReturnFloat{
  return (float) 1.23456789;
}

- (id)instanceMethodReturnIdObject{
  return @5;
}
- (NSString *)instanceMethodReturnString{
  return @"6";
}
- (CGRect)instanceMethodReturnRect{
  return CGRectMake(9, 8, 7, 6);
}
- (NSMutableArray *)instanceMethodReturnMutableArray{
  return [@[@"X", @"Y"] mutableCopy];
}
- (double)instanceMethodReturnDouble{
  return (double) 9.87654321;
}
- (float)instanceMethodReturnFloat{
  return (float) 8.765432109;
}

@end



#pragma mark - Change return values by XAspect
// =============================================================================
// Change return values by XAspect; so we can kwow it works.
// =============================================================================
#define AtAspect XAspectBasicWeaving

#define AtAspectOfClass Tier1
@classPatchField(Tier1)

AspectPatch(+, id, classMethodReturnIdObject) {
  return @([XAMessageForward(classMethodReturnIdObject) integerValue] + 2);
}

AspectPatch(+, NSString *, classMethodReturnString) {
  return [XAMessageForward(classMethodReturnString) stringByAppendingString:@"3"];
}

AspectPatch(+, CGRect, classMethodReturnRect) {
  CGRect originalRetVal = XAMessageForward(classMethodReturnRect);;
  return CGRectMake(originalRetVal.origin.x *2,
                    originalRetVal.origin.y *2,
                    originalRetVal.size.width *2,
                    originalRetVal.size.height *2);
}

AspectPatch(+, NSMutableArray *, classMethodReturnMutableArray) {
  NSMutableArray *classMethodReturnMutableArray = XAMessageForward(classMethodReturnMutableArray);
  [classMethodReturnMutableArray addObject:@"B"];
  return classMethodReturnMutableArray;
}

AspectPatch(+, double, classMethodReturnDouble) {
  return XAMessageForward(classMethodReturnDouble) *3;
}

AspectPatch(+, float, classMethodReturnFloat) {
  return XAMessageForward(classMethodReturnFloat) *4;
}


AspectPatch(-, id, instanceMethodReturnIdObject) {
  return @([XAMessageForward(instanceMethodReturnIdObject) integerValue] + 2);
}

AspectPatch(-, NSString *, instanceMethodReturnString) {
  return [XAMessageForward(instanceMethodReturnString) stringByAppendingString:@"3"];
}

AspectPatch(-, CGRect, instanceMethodReturnRect) {
  CGRect originalRetVal = XAMessageForward(instanceMethodReturnRect);;
  return CGRectMake(originalRetVal.origin.x *2,
                    originalRetVal.origin.y *2,
                    originalRetVal.size.width *2,
                    originalRetVal.size.height *2);
}

AspectPatch(-, NSMutableArray *, instanceMethodReturnMutableArray) {
  NSMutableArray *instanceMethodReturnMutableArray = XAMessageForward(instanceMethodReturnMutableArray);
  [instanceMethodReturnMutableArray addObject:@"Z"];
  return instanceMethodReturnMutableArray;
}

AspectPatch(-, double, instanceMethodReturnDouble) {
  return XAMessageForward(instanceMethodReturnDouble) *3;
}

AspectPatch(-, float, instanceMethodReturnFloat) {
  return XAMessageForward(instanceMethodReturnFloat) *4;
}

@end
#undef AtAspectOfClass


#pragma mark - Start Testing
// =============================================================================
// Start Testing
// =============================================================================
@interface BasicWeavingForTypesTest : XCTestCase
@property (nonatomic, strong) Tier1 *tier1;
@end


@implementation BasicWeavingForTypesTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  self.tier1 = [Tier1 new];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

#pragma mark Test Type id
- (void)testClassMethodReturnType_id
{
  // The original implementation and current implementation.
  id sender = [Tier1 class];
  SEL cmd = @selector(classMethodReturnIdObject);
  IMP currentImp = classImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(classMethodReturnIdObjectIMP,
            @"The original implementation should be cached.");
  XCTAssert(classMethodReturnIdObjectIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  NSNumber *originalRetVal = (NSNumber *)((id(*)(id,SEL))classMethodReturnIdObjectIMP)(sender, cmd);
  NSNumber *currentRetVal = (NSNumber *)((id(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualObjects(originalRetVal, @1,
                        @"The original value should be %@", @1);
  XCTAssertEqualObjects(currentRetVal, @3,
                        @"The current value should be %@", @3);
  XCTAssertEqualObjects(currentRetVal, [Tier1 classMethodReturnIdObject],
                        @"The values from implementation invocation and direct invoction should be the same.");
}

- (void)testInstanceMethodReturnType_id
{
  // The original implementation and current implementation.
  id sender = self.tier1;
  SEL cmd = @selector(instanceMethodReturnIdObject);
  IMP currentImp = instanceImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(instanceMethodReturnIdObjectIMP,
            @"The original implementation should be cached.");
  XCTAssert(instanceMethodReturnIdObjectIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  NSNumber *originalRetVal = (NSNumber *)((id(*)(id,SEL))instanceMethodReturnIdObjectIMP)(sender, cmd);
  NSNumber *currentRetVal = (NSNumber *)((id(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualObjects(originalRetVal, @5,
                        @"The original value should be %@", @5);
  XCTAssertEqualObjects(currentRetVal, @7,
                        @"The current value should be %@", @7);
  XCTAssertEqualObjects(currentRetVal, [self.tier1 instanceMethodReturnIdObject],
                        @"The values from implementation invocation and direct invoction should be the same.");
}

#pragma mark Test Type NSString
- (void)testClassMethodReturnType_string
{
  // The original implementation and current implementation.
  id sender = [Tier1 class];
  SEL cmd = @selector(classMethodReturnString);
  IMP currentImp = classImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(classMethodReturnStringIMP,
            @"The original implementation should be cached.");
  XCTAssert(classMethodReturnStringIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  NSString *originalRetVal = (NSString *)((NSString *(*)(id,SEL))classMethodReturnStringIMP)(sender, cmd);
  NSString *currentRetVal = (NSString *)((NSString *(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualObjects(originalRetVal, @"2",
                        @"The original value should be %@", @"2");
  XCTAssertEqualObjects(currentRetVal, @"23",
                        @"The current value should be %@", @"23");
  XCTAssertEqualObjects(currentRetVal, [Tier1 classMethodReturnString],
                        @"The values from implementation invocation and direct invoction should be the same.");
}

- (void)testInstanceMethodReturnType_string
{
  // The original implementation and current implementation.
  id sender = self.tier1;
  SEL cmd = @selector(instanceMethodReturnString);
  IMP currentImp = instanceImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(instanceMethodReturnStringIMP,
            @"The original implementation should be cached.");
  XCTAssert(instanceMethodReturnStringIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  NSString *originalRetVal = (NSString *)((NSString *(*)(id,SEL))instanceMethodReturnStringIMP)(sender, cmd);
  NSString *currentRetVal = (NSString *)((NSString *(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualObjects(originalRetVal, @"6",
                        @"The original value should be %@", @"6");
  XCTAssertEqualObjects(currentRetVal, @"63",
                        @"The current value should be %@", @"63");
  XCTAssertEqualObjects(currentRetVal, [self.tier1 instanceMethodReturnString],
                        @"The values from implementation invocation and direct invoction should be the same.");
}

#pragma mark Test Type Structure (CGRect)
- (void)testClassMethodReturnType_rect
{
  // The original implementation and current implementation.
  id sender = [Tier1 class];
  SEL cmd = @selector(classMethodReturnRect);
  IMP currentImp = classImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(classMethodReturnRectIMP,
            @"The original implementation should be cached.");
  XCTAssert(classMethodReturnRectIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  CGRect originalRetVal = (CGRect)((CGRect(*)(id,SEL))classMethodReturnRectIMP)(sender, cmd);
  CGRect currentRetVal = (CGRect)((CGRect(*)(id,SEL))currentImp)(sender, cmd);
  CGRect originalAssertionValue = CGRectMake(1, 2, 3, 4);
  CGRect currentAssertionValue = CGRectMake(2, 4, 6, 8);
  
  XCTAssert(CGRectEqualToRect(originalRetVal, originalAssertionValue),
            @"The original value should be %@", NSStringFromCGRect(originalAssertionValue));
  XCTAssert(CGRectEqualToRect(currentRetVal, currentAssertionValue),
            @"The current value should be %@", NSStringFromCGRect(currentAssertionValue));
  XCTAssert(CGRectEqualToRect(currentRetVal, [Tier1 classMethodReturnRect]),
            @"The values from implementation invocation and direct invoction should be the same.");
}


- (void)testInstanceMethodReturnType_rect
{
  // The original implementation and current implementation.
  id sender = self.tier1;
  SEL cmd = @selector(instanceMethodReturnRect);
  IMP currentImp = instanceImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(instanceMethodReturnRectIMP,
            @"The original implementation should be cached.");
  XCTAssert(instanceMethodReturnRectIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  CGRect originalRetVal = (CGRect)((CGRect(*)(id,SEL))instanceMethodReturnRectIMP)(sender, cmd);
  CGRect currentRetVal = (CGRect)((CGRect(*)(id,SEL))currentImp)(sender, cmd);
  CGRect originalAssertionValue = CGRectMake(9, 8, 7, 6);
  CGRect currentAssertionValue = CGRectMake(18, 16, 14, 12);
  
  XCTAssert(CGRectEqualToRect(originalRetVal, originalAssertionValue),
            @"The original value should be %@", NSStringFromCGRect(originalAssertionValue));
  XCTAssert(CGRectEqualToRect(currentRetVal, currentAssertionValue),
            @"The current value should be %@", NSStringFromCGRect(currentAssertionValue));
  XCTAssert(CGRectEqualToRect(currentRetVal, [self.tier1 instanceMethodReturnRect]),
            @"The values from implementation invocation and direct invoction should be the same.");
}


#pragma mark Test Type Collection (NSMutableArray)
- (void)testClassMethodReturnType_mutableArray
{
  // The original implementation and current implementation.
  id sender = [Tier1 class];
  SEL cmd = @selector(classMethodReturnMutableArray);
  IMP currentImp = classImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(classMethodReturnMutableArrayIMP,
            @"The original implementation should be cached.");
  XCTAssert(classMethodReturnMutableArrayIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  NSMutableArray *originalRetVal = (NSMutableArray *)((NSMutableArray *(*)(id,SEL))classMethodReturnMutableArrayIMP)(sender, cmd);
  NSMutableArray *currentRetVal = (NSMutableArray *)((NSMutableArray *(*)(id,SEL))currentImp)(sender, cmd);
  
  XCTAssertEqual([originalRetVal count], 1,
                 @"The original count of the array should be %d", 1);
  XCTAssertEqual([currentRetVal count], 2,
                 @"The current count of the array should be %d", 2);
  
  XCTAssertEqualObjects([originalRetVal lastObject], @"A",
                        @"The original last element of the array should be %@", @"A");
  XCTAssertEqualObjects([currentRetVal lastObject], @"B",
                        @"The current last element of the array should be %@", @"B");
  
  XCTAssertEqualObjects(currentRetVal, [Tier1 classMethodReturnMutableArray],
                        @"The values from implementation invocation and direct invoction should be the same.");
  
}

- (void)testInstanceMethodReturnType_mutableArray
{
  // The original implementation and current implementation.
  id sender = self.tier1;
  SEL cmd = @selector(instanceMethodReturnMutableArray);
  IMP currentImp = instanceImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(instanceMethodReturnMutableArrayIMP,
            @"The original implementation should be cached.");
  XCTAssert(instanceMethodReturnMutableArrayIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  NSMutableArray *originalRetVal = (NSMutableArray *)((NSMutableArray *(*)(id,SEL))instanceMethodReturnMutableArrayIMP)(sender, cmd);
  NSMutableArray *currentRetVal = (NSMutableArray *)((NSMutableArray *(*)(id,SEL))currentImp)(sender, cmd);
  
  XCTAssertEqual([originalRetVal count], 2,
                 @"The original count of the array should be %d", 2);
  XCTAssertEqual([currentRetVal count], 3,
                 @"The current count of the array should be %d", 3);
  
  XCTAssertEqualObjects([originalRetVal lastObject], @"Y",
                        @"The original last element of the array should be %@", @"Y");
  XCTAssertEqualObjects([currentRetVal lastObject], @"Z",
                        @"The current last element of the array should be %@", @"Z");
  
  XCTAssertEqualObjects(currentRetVal, [self.tier1 instanceMethodReturnMutableArray],
                        @"The values from implementation invocation and direct invoction should be the same.");
}


#pragma mark Test Type double
- (void)testClassMethodReturnType_double
{
  // The original implementation and current implementation.
  id sender = [Tier1 class];
  SEL cmd = @selector(classMethodReturnDouble);
  IMP currentImp = classImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(classMethodReturnDoubleIMP,
            @"The original implementation should be cached.");
  XCTAssert(classMethodReturnDoubleIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  double originalRetVal = (double)((double(*)(id,SEL))classMethodReturnDoubleIMP)(sender, cmd);
  double currentRetVal = (double)((double(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualWithAccuracy(originalRetVal, 2.345678901, accuracy,
                             @"The original value should be %f", 2.345678901);
  XCTAssertEqualWithAccuracy(currentRetVal, 3 * 2.345678901 , accuracy,
                             @"The current value should be %f", 3 * 2.345678901);
  XCTAssertEqualWithAccuracy(currentRetVal, [Tier1 classMethodReturnDouble], accuracy,
                             @"The values from implementation invocation and direct invoction should be the same.");
}

- (void)testInstanceMethodReturnType_double
{
  // The original implementation and current implementation.
  id sender = self.tier1;
  SEL cmd = @selector(instanceMethodReturnDouble);
  IMP currentImp = instanceImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(instanceMethodReturnDoubleIMP,
            @"The original implementation should be cached.");
  XCTAssert(instanceMethodReturnDoubleIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  double originalRetVal = (double)((double(*)(id,SEL))instanceMethodReturnDoubleIMP)(sender, cmd);
  double currentRetVal = (double)((double(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualWithAccuracy(originalRetVal, 9.87654321, accuracy,
                             @"The original value should be %f", 9.87654321);
  XCTAssertEqualWithAccuracy(currentRetVal, 3 * 9.87654321, accuracy,
                             @"The current value should be %f", 3 * 9.87654321);
  XCTAssertEqualWithAccuracy(currentRetVal, [self.tier1 instanceMethodReturnDouble], accuracy,
                             @"The values from implementation invocation and direct invoction should be the same.");
}


#pragma mark Test Type float
- (void)testClassMethodReturnType_float
{
  // The original implementation and current implementation.
  id sender = [Tier1 class];
  SEL cmd = @selector(classMethodReturnFloat);
  IMP currentImp = classImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(classMethodReturnFloatIMP,
            @"The original implementation should be cached.");
  XCTAssert(classMethodReturnFloatIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  float originalRetVal = (float)((float(*)(id,SEL))classMethodReturnFloatIMP)(sender, cmd);
  float currentRetVal = (float)((float(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualWithAccuracy(originalRetVal, 1.23456789, accuracy,
                             @"The original value should be %f", 1.23456789);
  XCTAssertEqualWithAccuracy(currentRetVal, 4 * 1.23456789, accuracy,
                             @"The current value should be %f", 4 * 1.23456789);
  XCTAssertEqualWithAccuracy(currentRetVal, [Tier1 classMethodReturnFloat], accuracy,
                             @"The values from implementation invocation and direct invoction should be the same.");
}

- (void)testInstanceMethodReturnType_float
{
  // The original implementation and current implementation.
  id sender = self.tier1;
  SEL cmd = @selector(instanceMethodReturnFloat);
  IMP currentImp = instanceImp([Tier1 class], cmd);
  XCTAssert(currentImp,
            @"The current implementation should not be nil.");
  XCTAssert(instanceMethodReturnFloatIMP,
            @"The original implementation should be cached.");
  XCTAssert(instanceMethodReturnFloatIMP != currentImp,
            @"The current implementation should have been swapped.");
  
  // The value of original implementation and current implementation.
  float originalRetVal = (float)((float(*)(id,SEL))instanceMethodReturnFloatIMP)(sender, cmd);
  float currentRetVal = (float)((float(*)(id,SEL))currentImp)(sender, cmd);
  XCTAssertEqualWithAccuracy(originalRetVal, 8.765432109, accuracy,
                             @"The original value should be %f", 8.765432109);
  XCTAssertEqualWithAccuracy(currentRetVal, 4 * 8.765432109, accuracy,
                             @"The current value should be %f", 4 * 8.765432109);
  XCTAssertEqualWithAccuracy(currentRetVal, [self.tier1 instanceMethodReturnFloat], accuracy,
                             @"The values from implementation invocation and direct invoction should be the same.");
}


@end
