//
//  Aspect-ObjectAllocation.m
//  XAspectDev
//
//  Created by Xaree on 11/13/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XAspect/XAspect.h>
#define AtAspect ObjectLifetime  // A name for your aspect field

// Create an aspect patch field for the class you want to add the aspect patches to.
#define AtAspectOfClass NSObject
@classPatchField(NSObject)

/* 
 Uncomment this patch will print a message for every object initialization. 
 */
//AspectPatch(-, instancetype, init)
//{
//	// Add your custom implementation here.
//	NSLog(@"[Init]: %@", NSStringFromClass([self class]));
//	
//	// Forward the message to the origin implementation.
//	return XAMessageForward(init);
//}


@end


