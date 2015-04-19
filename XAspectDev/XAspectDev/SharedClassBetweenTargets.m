//
//  SharedClassBetweenTargets.m
//  XAspectDev
//
//  Created by Xaree on 11/30/14.
//  Copyright (c) 2015 Xaree Lee. All rights reserved.
//

#import "SharedClassBetweenTargets.h"
#import <objc/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation SharedClassBetweenTargets
//+ (void)load
//{
//	Class metaclass = objc_getMetaClass("SharedClassBetweenTargets");
//	Method method = class_getInstanceMethod(metaclass, @selector(valueForSharedClassBetweenTargets));
//	NSLog(@"SharedClassBetweenTargets did load. Class: <%p>. Method: <%p>", metaclass, method_getImplementation(method));
//}
+ (NSInteger)valueForSharedClassBetweenTargets{
	Class metaclass = objc_getMetaClass("SharedClassBetweenTargets");
	Method method = class_getInstanceMethod(metaclass, @selector(valueForSharedClassBetweenTargets));
	NSLog(@"Invoke origin. Class: <%p>. Method: <%p>", metaclass, method_getImplementation(method));
	return 100;
}
@end


