//
//  NullReturnValueImpTest.m
//  XAspectDev
//
//  Created by Xaree on 12/9/14.
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

typedef struct {
  int a;
  float b;
  char *c;
} StructForTest;

typedef union {
  int i;
  double j;
  char *k;
} UnionForTest;


@interface Tier1 (NullReturnValueImpTest)
// Void
+ (void)nullReturnValueForType_void;
+ (void *)nullReturnValueForType_void_pointer;
// Primitive
+ (int)nullReturnValueForType_int;
+ (long)nullReturnValueForType_long;
+ (float)nullReturnValueForType_float;
+ (double)nullReturnValueForType_double;
+ (unsigned int)nullReturnValueForType_unsigned_int;
+ (unsigned long)nullReturnValueForType_unsigned_long;
+ (char *)nullReturnValueForType_char;
+ (const char *)nullReturnValueForType_const_char;
// Object
+ (id)nullReturnValueForType_id;
+ (instancetype)nullReturnValueForType_instancetype;
+ (NSString *)nullReturnValueForType_NSString;
+ (NSArray *)nullReturnValueForType_NSArray;
// Structure
+ (CGPoint)nullReturnValueForType_CGPoint;
+ (CGSize)nullReturnValueForType_CGSize;
+ (CGRect)nullReturnValueForType_CGRect;
+ (StructForTest)nullReturnValueForType_StructForTest;
// Union
+ (UnionForTest)nullReturnValueForType_UnionForTest;
@end


@implementation Tier1 (NullReturnValueImpTest)
// Void
+ (void)nullReturnValueForType_void _XANullReturnValueImplementation(void);  // !!
+ (void *)nullReturnValueForType_void_pointer _XANullReturnValueImplementation(VoidPointer); // !!!: use type `VoidPointer` instead of.
// Primitive
+ (int)nullReturnValueForType_int _XANullReturnValueImplementation(int);
+ (long)nullReturnValueForType_long _XANullReturnValueImplementation(long);
+ (float)nullReturnValueForType_float _XANullReturnValueImplementation(float);
+ (double)nullReturnValueForType_double _XANullReturnValueImplementation(double);
+ (unsigned int)nullReturnValueForType_unsigned_int _XANullReturnValueImplementation(unsigned int);
+ (unsigned long)nullReturnValueForType_unsigned_long  _XANullReturnValueImplementation(unsigned long);
+ (char *)nullReturnValueForType_char _XANullReturnValueImplementation(char *);
+ (const char *)nullReturnValueForType_const_char _XANullReturnValueImplementation(const char *);
// Object
+ (id)nullReturnValueForType_id _XANullReturnValueImplementation(id);
+ (instancetype)nullReturnValueForType_instancetype _XANullReturnValueImplementation(instancetype); // !!
+ (NSString *)nullReturnValueForType_NSString _XANullReturnValueImplementation(NSString *);
+ (NSArray *)nullReturnValueForType_NSArray _XANullReturnValueImplementation(NSArray *);
// Structure
+ (CGPoint)nullReturnValueForType_CGPoint _XANullReturnValueImplementation(CGPoint);
+ (CGSize)nullReturnValueForType_CGSize _XANullReturnValueImplementation(CGSize);
+ (CGRect)nullReturnValueForType_CGRect _XANullReturnValueImplementation(CGRect);
+ (StructForTest)nullReturnValueForType_StructForTest _XANullReturnValueImplementation(StructForTest);
// Union
+ (UnionForTest)nullReturnValueForType_UnionForTest _XANullReturnValueImplementation(UnionForTest);
@end

@interface NullReturnValueImpTest : XCTestCase

@end

@implementation NullReturnValueImpTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testNullReturnValue
{
  // void
  // We can't assert the return value fot type `void`, but we can test whether
  // the implementation exists
  [Tier1 nullReturnValueForType_void];
  
  XCTAssertEqual([Tier1 nullReturnValueForType_void_pointer], NULL);
  
  // Primitive
  XCTAssertEqual([Tier1 nullReturnValueForType_int], 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_long], 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_float], 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_double], 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_unsigned_int], 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_unsigned_long], 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_char], NULL);
  XCTAssertEqual([Tier1 nullReturnValueForType_const_char], NULL);
  
  // Object
  XCTAssertEqualObjects([Tier1 nullReturnValueForType_id], nil);
  XCTAssertEqualObjects([Tier1 nullReturnValueForType_instancetype], nil);
  XCTAssertEqualObjects([Tier1 nullReturnValueForType_NSString], nil);
  XCTAssertEqualObjects([Tier1 nullReturnValueForType_NSArray], nil);
  
  // Structure
  XCTAssert(CGPointEqualToPoint([Tier1 nullReturnValueForType_CGPoint], CGPointZero));
  XCTAssert(CGSizeEqualToSize([Tier1 nullReturnValueForType_CGSize], CGSizeZero));
  XCTAssert(CGRectEqualToRect([Tier1 nullReturnValueForType_CGRect], CGRectZero));
  XCTAssertEqual([Tier1 nullReturnValueForType_StructForTest].a, 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_StructForTest].b, 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_StructForTest].c, NULL);
  
  // Union
  XCTAssertEqual([Tier1 nullReturnValueForType_UnionForTest].i, 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_UnionForTest].j, 0);
  XCTAssertEqual([Tier1 nullReturnValueForType_UnionForTest].k, NULL);
  UnionForTest aUnion = [Tier1 nullReturnValueForType_UnionForTest];
  size_t elementISize = sizeof(aUnion.i);
  size_t elementJSize = sizeof(aUnion.j);
  size_t elementKSize = sizeof(aUnion.k);
  size_t unionSize = MAX(MAX(elementISize, elementJSize), elementKSize);
  XCTAssertEqual(unionSize, sizeof(UnionForTest));
}

@end
