//
//  UserDefinedMacroKeywordTest.m
//  XAspectDev
//
//  Created by Xaree on 12/4/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XAspect/XAspect.h>


// =============================================================================
#pragma mark - Prepare Materials to Test
// =============================================================================
@interface XAAspectKeywordTestClass : NSObject
@end
@implementation XAAspectKeywordTestClass
@end


#undef NSAssertMacroKeywordEqual
#define NSAssertMacroKeywordEqual(Keyword1, Keyword2, message, ...) // Don't make the assertion work in this test file.


// -----------------------------------------------------------------------------
// Change `_isDefinedAtAspectDetected` to `YES` if `AtAspect` is defined.
#undef AtAspect
#define AtAspect AnyThing // Defined

BOOL _isDefinedAtAspectDetected = NO;
#undef _XAAspectNamespaceCheckerDefault
#define _XAAspectNamespaceCheckerDefault (_isDefinedAtAspectDetected = YES)

#define AtAspectOfClass XAAspectKeywordTestClass
@classPatchField(XAAspectKeywordTestClass)
@end
// -----------------------------------------------------------------------------
// Change `isBlankAtAspectDetected` to `YES` if a 'blank' error is detected.
#undef AtAspect
#define AtAspect // Blank

BOOL _isBlankAtAspectDetected = NO;
#undef _XAAspectNamespaceChecker_aspect_
#define _XAAspectNamespaceChecker_aspect_ metamacro_evaluate_push(_isBlankAtAspectDetected = YES)

#undef AtAspectOfClass
#define AtAspectOfClass XAAspectKeywordTestClass
@classPatchField(XAAspectKeywordTestClass)
@end
#undef AtAspectOfClass
// -----------------------------------------------------------------------------
// Change `_isUndefinedAtAspectDetected` to `YES` if an 'undefined' error is detected.
#undef AtAspect // Undefined

BOOL _isUndefinedAtAspectDetected = NO;
#undef _XAAspectNamespaceChecker_aspect_AtAspect
#define _XAAspectNamespaceChecker_aspect_AtAspect metamacro_evaluate_push(_isUndefinedAtAspectDetected = YES)

#undef AtAspectOfClass
#define AtAspectOfClass XAAspectKeywordTestClass
@classPatchField(XAAspectKeywordTestClass)
@end
#undef AtAspectOfClass
// =============================================================================
// Change `_isDefinedAtAspectOfClassDetected` to `YES` if `AtAspectOfClass` is defined.
#undef AtAspect
#define AtAspect DetectAtAspectOfClassKeywordTest
#undef AtAspectOfClass
#undef _XAAspectOfClassNamespaceCheckerDefault
BOOL _isDefinedAtAspectOfClassDetected = NO;
#define _XAAspectOfClassNamespaceCheckerDefault (_isDefinedAtAspectOfClassDetected = YES)

#define AtAspectOfClass XAAspectKeywordTestClass // Defined
@classPatchField(XAAspectKeywordTestClass)
@end
// -----------------------------------------------------------------------------
// Change `_isBlankAtAspectOfClassDetected` to `YES` if a 'blank' error is detected.
#undef AtAspect
#define AtAspect UndefinedAtAspectOfClassKeywordTest

BOOL _isBlankAtAspectOfClassDetected = NO;
#undef _XAAspectOfClassNamespaceChecker_patch_
#define _XAAspectOfClassNamespaceChecker_patch_ metamacro_evaluate_push(_isBlankAtAspectOfClassDetected = YES)

#undef AtAspectOfClass
#define AtAspectOfClass // Blank
@classPatchField(XAAspectKeywordTestClass)
@end
// -----------------------------------------------------------------------------
// Change `_isUndefinedAtAspectOfClassDetected` to `YES` if an 'undefined' error is detected.
#undef AtAspect
#define AtAspect BlankAtAspectOfClassKeywordTest

BOOL _isUndefinedAtAspectOfClassDetected = NO;
#undef _XAAspectOfClassNamespaceChecker_patch_AtAspectOfClass
#define _XAAspectOfClassNamespaceChecker_patch_AtAspectOfClass metamacro_evaluate_push(_isUndefinedAtAspectOfClassDetected = YES)

#undef AtAspectOfClass // Undefined
@classPatchField(XAAspectKeywordTestClass)
@end
// -----------------------------------------------------------------------------


// =============================================================================
#pragma mark - Test Case
// =============================================================================

@interface UserDefinedMacroKeywordTest : XCTestCase

@end

@implementation UserDefinedMacroKeywordTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIsDefinedAtAspectDetected {
	XCTAssert(_isDefinedAtAspectDetected,
			  "The `@classPatchField()` should detect the defined `AtAspect`.");
}

- (void)testIsBlankAtAspectDetected {
	XCTAssert(_isBlankAtAspectDetected,
			  "The `@classPatchField()` should detect the blank `AtAspect`.");
}

- (void)testIsUndefinedAtAspectDetected {
	XCTAssert(_isUndefinedAtAspectDetected,
			  "The `@classPatchField()` should detect the undefined `AtAspect`.");
}

- (void)testIsDefinedAtAspectOfClassDetected {
	XCTAssert(_isDefinedAtAspectOfClassDetected,
			  "The `@classPatchField()` should detect the defined `AtAspectOfClass`.");
}

- (void)testIsBlankAtAspectOfClassDetected {
	XCTAssert(_isBlankAtAspectOfClassDetected,
			  "The `@classPatchField()` should detect the blank `AtAspectOfClass`.");
}

- (void)testIsUndefinedAtAspectOfClassDetected {
	XCTAssert(_isUndefinedAtAspectOfClassDetected,
			  "The `@classPatchField()` should detect the undefined `AtAspectOfClass`.");
}



@end
