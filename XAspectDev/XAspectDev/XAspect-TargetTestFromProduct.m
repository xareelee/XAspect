//
//  TargetTestFromProduct.m
//  XAspectDev
//
//  Created by Xaree on 11/30/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import "SharedClassBetweenTargets.h"
#import <XAspect/XAspect.h>
#define AtAspect TargetTestFromProduct  // A name for your aspect field


#define AtAspectOfClass SharedClassBetweenTargets
@classPatchField(SharedClassBetweenTargets)

AspectPatch(+, NSInteger, valueForSharedClassBetweenTargets)
{
	return XAMessageForward(valueForSharedClassBetweenTargets) + 20;
}

@end
#undef AtAspectOfClass

