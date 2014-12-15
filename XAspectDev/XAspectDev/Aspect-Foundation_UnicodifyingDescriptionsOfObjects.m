// <XAspect>
// UnicodifyingDescriptionsOfNSFoundationObjects.h
//
// Copyright (c) 2014 Xaree Lee (Kang-Yu Lee)
// Released under the MIT license (see below)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

/**
 The will change the description if the locale is undefined. Useful for 
 displaying logs using Unicode in Apple System Logger (ASL).
 */

#import <Foundation/Foundation.h>
#import <XAspect/XAspect.h>
#define AtAspect Foundation_UnicodifyingDescriptionsOfObjects

// -----------------------------------------------------------------------------
// We use a tab for a identation level. You can change the identation if you want.
#define INDT @"\t"
// Indentation for levels
static NSString *indentationForLevels(NSUInteger level)
{
	switch (level) {
  		case 0: return @"";
		case 1: return INDT;
		case 2: return INDT INDT;
		case 3: return INDT INDT INDT;
		case 4: return INDT INDT INDT INDT;
		case 5: return INDT INDT INDT INDT INDT;
		case 6: return INDT INDT INDT INDT INDT INDT;
		case 7: return INDT INDT INDT INDT INDT INDT INDT;
		case 8: return INDT INDT INDT INDT INDT INDT INDT INDT;
		case 9: return INDT INDT INDT INDT INDT INDT INDT INDT INDT;
		case 10: return INDT INDT INDT INDT INDT INDT INDT INDT INDT INDT;
		default:
			return [indentationForLevels(10) stringByAppendingString:indentationForLevels(level-10)];
	}
}

NS_INLINE NSString *descrtionForKey(id obj)
{
	if ([obj isKindOfClass:[NSString class]]) {
		return [NSString stringWithFormat:@"\"%@\"", obj];
	} else if ([obj isKindOfClass:[NSNumber class]]) {
		return [obj description];
	}
	return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([obj class]), obj];
}

NS_INLINE NSString *descrtionForValue(id obj, NSUInteger level)
{
	if ([obj isKindOfClass:[NSString class]]) {
		return [NSString stringWithFormat:@"\"%@\"", obj];
	} else if ([obj isKindOfClass:[NSDictionary class]]) {
		return [(NSDictionary *)obj descriptionWithLocale:nil indent:level];
	} else if ([obj isKindOfClass:[NSArray class]]) {
		return [(NSArray *)obj descriptionWithLocale:nil indent:level];
	} else if ([obj isKindOfClass:[NSOrderedSet class]]) {
		return [(NSOrderedSet *)obj descriptionWithLocale:nil indent:level];
	} else if ([obj isKindOfClass:[NSNull class]]) {
		return @"null"; // JSON null value
	}
	return [obj description];
}


// -----------------------------------------------------------------------------
#define AtAspectOfClass NSDictionary
@classPatchField(NSDictionary)

AspectPatch(-, NSString *, descriptionWithLocale:(id)locale indent:(NSUInteger)level)
{
	// If local isn't nil. Return the original value.
	if (locale) {
		return XAMessageForward(descriptionWithLocale:locale indent:level);
	}
	
	// If locale is nil, we create the description string.
	__block BOOL isFirstElement = YES;
	NSUInteger elementLevel = level + 1;
	NSMutableString *desc = [@"{" mutableCopy];
	
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[desc appendFormat:@"%s\n%@%@ : %@",
		 					(isFirstElement)?"":",",
		 					indentationForLevels(elementLevel),
		 					descrtionForKey(key),
		 					descrtionForValue(obj, elementLevel)];
		isFirstElement = NO;
	}];
	
	[desc appendFormat:@"\n%@}", indentationForLevels(level)];
	
	return desc;
}

@end
#undef AtAspectOfClass

// -----------------------------------------------------------------------------

#define AtAspectOfClass NSArray
@classPatchField(NSArray)

AspectPatch(-, NSString *, descriptionWithLocale:(id)locale indent:(NSUInteger)level)
{
	// If local isn't nil. Return the original value.
	if (locale) {
		return XAMessageForward(descriptionWithLocale:locale indent:level);
	}
	
	// If locale is nil, we create the description string.
	__block BOOL isFirstElement = YES;
	NSUInteger elementLevel = level + 1;
	NSMutableString *desc = [@"[" mutableCopy];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[desc appendFormat:@"%s\n%@%@",
		 					(isFirstElement)?"":",",
							indentationForLevels(elementLevel),
							descrtionForValue(obj, elementLevel)];
		isFirstElement = NO;
	}];
	
	[desc appendFormat:@"\n%@]", indentationForLevels(level)];
	
	return desc;
}

@end
#undef AtAspectOfClass

// -----------------------------------------------------------------------------

#define AtAspectOfClass NSOrderedSet
@classPatchField(NSOrderedSet)

AspectPatch(-, NSString *, descriptionWithLocale:(id)locale indent:(NSUInteger)level)
{
	// If local isn't nil. Return the original value.
	if (locale) {
		return XAMessageForward(descriptionWithLocale:locale indent:level);
	}
	
	// If locale is nil, we create the description string.
	__block BOOL isFirstElement = YES;
	NSUInteger elementLevel = level + 1;
	NSMutableString *desc = [@"{(" mutableCopy];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[desc appendFormat:@"%s\n%@%@",
		 					(isFirstElement)?"":",",
		 					indentationForLevels(elementLevel),
		 					descrtionForValue(obj, elementLevel)];
		isFirstElement = NO;
	}];
	
	[desc appendFormat:@"\n%@)}", indentationForLevels(level)];
	
	return desc;

}

@end
#undef AtAspectOfClass


// -----------------------------------------------------------------------------

#define AtAspectOfClass NSSet
@classPatchField(NSSet)

AspectPatch(-, NSString *, descriptionWithLocale:(id)locale)
{
	// If local isn't nil. Return the original value.
	if (locale) {
		return XAMessageForward(descriptionWithLocale:locale);
	}
	
	// If locale is nil, we create the description string.
	__block BOOL isFirstElement = YES;
	NSMutableString *desc = [@"{(" mutableCopy];

	[self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		[desc appendFormat:@"%s\n%@%@",
		 					(isFirstElement)?"":",",
							INDT,
							descrtionForValue(obj, 1)];
		isFirstElement = NO;
	}];

	[desc appendFormat:@"\n})"];
	
	return desc;
}

@end
#undef AtAspectOfClass


// -----------------------------------------------------------------------------

#undef AtAspect