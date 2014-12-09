//
//  FunctionForTesting.h
//  XAspectDev
//
//  Created by Xaree on 9/24/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

IMP classImp(Class cls, SEL sel);
IMP instanceImp(Class cls, SEL sel);

/*
 We test macro expansion results here.
 */
#define XCTAssertMacro(macroA, expandedResultsString, ...) \
	XCTAssertCString(metamacro_stringify(macroA), expandedResultsString, ## __VA_ARGS__)
#define XCTAssertCString(strA, strB, ...) \
	XCTAssert(strcmp(strA, strB) == 0, ## __VA_ARGS__)
#define XCTAssertCStringNotEqual(strA, strB, ...) \
	XCTAssert(strcmp(strA, strB) != 0, ## __VA_ARGS__)
