//
//  CExtensionTest.m
//  XAspectDev
//
//  Created by Xaree on 11/30/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XACExtensions.h>
#import "FunctionForTesting.h"

@interface CExtensionTest : XCTestCase

@end

@implementation CExtensionTest

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testPrefix
{
  XCTAssert(xace_isPrefixedCString("ABCDEFG", "A"));
  XCTAssert(xace_isPrefixedCString("ABCDEFG", "AB"));
  XCTAssert(xace_isPrefixedCString("ABCDEFG", "ABC"));
  XCTAssert(xace_isPrefixedCString("ABCDEFG", "ABCD"));
  XCTAssert(xace_isPrefixedCString("ABCDEFG", "ABCDE"));
  XCTAssert(xace_isPrefixedCString("ABCDEFG", "ABCDEF"));
  XCTAssert(xace_isPrefixedCString("ABCDEFG", "ABCDEFG"));
  
  XCTAssertFalse(xace_isPrefixedCString("ABCDEFG", "ABCDEFGH"));
  XCTAssertFalse(xace_isPrefixedCString("ABCDEFG", "abc"));
  
  XCTAssert(xace_isPrefixedCString("ABCDEFG", ""));
  XCTAssertFalse(xace_isPrefixedCString("ABCDEFG", NULL));
  XCTAssertFalse(xace_isPrefixedCString(NULL, "ABC"));
  XCTAssertFalse(xace_isPrefixedCString(NULL, NULL));
}

- (void)testSuffix
{
  XCTAssert(xace_isSuffixedCString("ABCDEFG", "G"));
  XCTAssert(xace_isSuffixedCString("ABCDEFG", "FG"));
  XCTAssert(xace_isSuffixedCString("ABCDEFG", "EFG"));
  XCTAssert(xace_isSuffixedCString("ABCDEFG", "DEFG"));
  XCTAssert(xace_isSuffixedCString("ABCDEFG", "CDEFG"));
  XCTAssert(xace_isSuffixedCString("ABCDEFG", "BCDEFG"));
  XCTAssert(xace_isSuffixedCString("ABCDEFG", "ABCDEFG"));
  
  XCTAssertFalse(xace_isSuffixedCString("ABCDEFG", "OABCDEFG"));
  XCTAssertFalse(xace_isSuffixedCString("ABCDEFG", "efg"));
  
  XCTAssert(xace_isSuffixedCString("ABCDEFG", ""));
  XCTAssertFalse(xace_isSuffixedCString("ABCDEFG", NULL));
  XCTAssertFalse(xace_isSuffixedCString(NULL, "EFG"));
  XCTAssertFalse(xace_isSuffixedCString(NULL, NULL));
}

- (void)testSubstring
{
  {
    const char *substring __attribute__((cleanup(free_const_char))) = xace_createSubstring("ABCDEFG",0,3);
    XCTAssertCString(substring, "ABC");
  }
  {
    const char *substring __attribute__((cleanup(free_const_char))) = xace_createSubstring("ABCDEFG",0,3);
    XCTAssertCStringNotEqual(substring, "abc");
  }
  {
    const char *substring __attribute__((cleanup(free_const_char))) = xace_createSubstring("ABCDEFG",3,4);
    XCTAssertCString(substring, "DEFG");
  }
  {
    const char *substring __attribute__((cleanup(free_const_char))) = xace_createSubstring("ABCDEFG",0,7);
    XCTAssertCString(substring, "ABCDEFG");
  }
  {
    // !: return the tail when the passed length is 0.
    const char *substring __attribute__((cleanup(free_const_char))) = xace_createSubstring("ABCDEFG",0,0);
    XCTAssertCString(substring, "ABCDEFG");
  }
}

- (void)testStringConcat
{
  {
    const char *substring __attribute__((cleanup(free_const_char))) = xace_concat(2, "ABC", "DEFG");
    XCTAssertCString(substring, "ABCDEFG");
  }
  {
    const char *substring __attribute__((cleanup(free_const_char))) = xace_concat(2, "def", "abc");
    XCTAssertCString(substring, "defabc");
  }
  {
    const char *substring __attribute__((cleanup(free_const_char))) = xace_concat(3, "ABC", "DEFG", "HIJK");
    XCTAssertCString(substring, "ABCDEFGHIJK");
  }
}


@end
