//
//  FunctionForTesting.m
//  XAspectDev
//
//  Created by Xaree on 9/24/14.
//  Copyright (c) 2014 Xaree Lee. All rights reserved.
//

#import "FunctionForTesting.h"


IMP classImp(Class cls, SEL sel) {
	return method_getImplementation(class_getClassMethod(cls, sel));
}
IMP instanceImp(Class cls, SEL sel) {
	return method_getImplementation(class_getInstanceMethod(cls, sel));
}

