

#import "AppDelegate.h"

// =============================================================================
#import <XAspect/XAspect.h>
#define AtAspect CocoaLumberjack
// =============================================================================

/**
 CocoaLumberjack
 
 @version 2.0.0-beta2
 @see https://github.com/CocoaLumberjack/CocoaLumberjack
 */

// We define the keyword `LOG_LEVEL_DEF` before importing CocoaLumberjack. We
// use this macro to indicate the level in this aspect file.
#ifdef DEBUG
	#define LOG_LEVEL_DEF LOG_LEVEL_VERBOSE
#else
	#define LOG_LEVEL_DEF LOG_LEVEL_WARN
#endif

#import <CocoaLumberjack/CocoaLumberjack.h>
// -----------------------------------------------------------------------------


#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

	
@tryCustomizeDefaultPatch(1, -, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions){
	return YES;
}

AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions) {

	[DDLog addLogger:[DDASLLogger sharedInstance]]; // sends log statements to Apple System Logger, so they show up on Console.app
	[DDLog addLogger:[DDTTYLogger sharedInstance]];	// sends log statements to Xcode console - if available
	
	DDLogInfo(@"CocoaLumberjack's Loggers have been configured when application did finish launching.");
	
	return XAMessageForward(application:(UIApplication *)application
							didFinishLaunchingWithOptions:(NSDictionary *)launchOptions);
}

@end
#undef AtAspectOfClass 

// -----------------------------------------------------------------------------


#define AtAspectOfClass UIViewController
@classPatchField(UIViewController)

@synthesizeNucleusPatch(Default, -, void, viewDidLoad);
@synthesizeNucleusPatch(Default, -, void, viewDidAppear:(BOOL)animated);

AspectPatch(-, void, viewDidLoad){
	
	DDLogInfo(@"[CocoaLumberjack Log]: %@'s view did load.", NSStringFromClass([self class]));
	
	return XAMessageForward(viewDidLoad);
}

AspectPatch(-, void, viewDidAppear:(BOOL)animated){
	
	DDLogInfo(@"[CocoaLumberjack Log]: %@'s view did appear.", NSStringFromClass([self class]));
	
	return XAMessageForward(viewDidAppear:(BOOL)animated);
}

@end
#undef AtAspectOfClass


