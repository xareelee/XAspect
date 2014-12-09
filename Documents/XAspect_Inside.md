




## Technique Behind XAspect


### Selector Chain using Method Swizzling

### Safe Category from libextobjc

### Concise Syntax using C Macros


## Terminology of the XAspect 

#### Target Class (Patch Destination Class)

A target class is a class you want to patch. The target class is defined by `AtAspectOfClass` and used in `@classPatchField()` to create the aspect patch field.

	#define AtAspectOfClass TargetClass
	@classPatchField(TargetClass) 

#### Aspect Class (Patch Source class)

An aspect class is a class where you implement your patches. It is a subclass of the target class. The aspect class is created by macro `@classPatchField()`, and you should not use it directly.

The macro `@classPatchField()` takes both `AtAspect` and `AtAspectOfClass` in current context to synthesize the aspect class. The naming format is `<#TargeClassName#>_AtAspect_<#AspectName#>`. For example, if the aspect name is `HelloWorld` and the target class is `NSObject`, the aspect class name will be `_AtAspect_HelloWorld_OfClass_NSObject_`.



## Terminology of the XAspect Implementation


#### Crystallization

Crystallization, in XAspect, means the process how XAspect weaves your aspect implementation into the source at loading time. It contains two step:

1. **Nucleation**: this step is to ensure that the target selector of the target class has its source implementation for crystal growth (*method swizzling*).
2. **Crystal growth**: this step is to attach aspect implementations to the implementation nucleus by method swizzling. It forms a **selector chain** for aspects.


##### *Nucleation (Priming Phase)

The source implementation of a target selector of a target class is called '**nucleus**'. It's very crucial that there must be a nucleus for method swizzling. The result of method swizzling without a proper nucleus is unpredictable and properly might cause a fetal issue.

XAspect will try to find and inject an adequate implementation as the nucleus if there is no nucleus at the beginning. We call this step '**priming**'. If it fails to prime, XAspect will raise an exception and abort the program when the program is loaded.

The priming procedures are the following:

1. Check if the nucleus exists. If yes, XAspect will do nothing for this.
2. If no nucleus exists, XAspect will try to prime an adequate implementation:
	* If any superclass in the class hierarchy has an implementation for the selector, XAspect will use the '**super caller**' implementation to prime. If you don't prime this super caller implementation, XAspect will swizzle the aspect methods with its superclass's implementation, and the result is unpredictable.
	* If there is no implementation for the selector in the superclass hierarchy, XAspect will prime a '**default**' implementation which will return a null value for the return type if needed.
3. If it fails to find the adequate implementation,  will raise an exception and abort the program.

You can synthesize both *super caller* and *default* implementation by `@synthesizeNucleus()` macros. 

	@synthesizeNucleus(Default, -, void, doSomething);
	@synthesizeNucleus(SuperCaller, -, void, viewDidLoad);
	@synthesizeNucleus(DefaultAndSuperCaller, -, instancetype, init);

Although synthesizing nuclei is useless when the target implementation already exists, we still recommend you only synthesize those nuclei if needed.

* If you synthesize the super caller implementation, the superclass of the target class must respond to the selector.
* A default implementation will return a null/zero value for the return type.

If you want to change the return value from the default implementation, you can use `@tryCustomizeDefault()` macro to customize the default behavior and return value. For example, you might want to synthesize a default implementation which will return `YES` for `-application:didFinishLaunchingWithOptions:`, you can implement like this:

	@tryCustomizeDefault(1, -, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions){
		return YES;
	}




##### *Crystal growth (Selector Chaining or Aspect Weaving Phase)




##### *Safe Category Methods and Technology


**Safe category** methods are the category methods which will be added to a class without overwriting original implementation or be overwritten by other category methods. 

This technology ensures that your implementation won't be replaced by others—in other words, .

**Safe Category** technology is derived from another open source library—**libextobjc**.  

Any conflict will raise an exception and abort.



XAspect allows you to add category methods in the *aspect building field*, and it will try to inject your category implementations first before the *priming* phase. 

If the target class has already had the implementation for the target selector, XAspect will raise an exception to notify you that your category implementation is unsafe. Furthermore, if you implement more than one safe category method for the same selector (including using libextobjc), XAspect will raise an exception too.

If you are using both libextobjc and XAspect, you should implement your safe category methods in the *aspect building field* of XAspect due to the injection sequence—only XAspect ensure your safe category methods are injected before weaving phase. 


##### *Crystallization Sequence

Due to the priming procedure will choose the adequate implementation according to whether any of its superclasses has a corresponding implementation, the crystallization sequence matters.

If crystalizing a subclass ahead of a superclass, both of the classed will be primed with the *default* implementations. This will cause the subclass's primed implementation will not invoke its superclass's implementation and results in undesired behaviors. 

XAspect always will try to crystalize a superclass first if needed, to avoid undesired behaviors. 



#### Crystallization Build


A **crystallization build** is a C++ map (or dictionary) containing information about how many selectors would be involved with the **crystallization reaction** 