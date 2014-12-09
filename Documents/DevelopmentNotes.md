Development Notes
=================

This document contains the following sections:

* [Bugs and Known Issues](#bugs-and-known-issues)
* [TODO List](#todo-list)

Bugs and Known Issues
---------------------

No contents.


TODO List
---------

Sorted by target version.

**@1.1.0**

 - Possible multiple targets issues:
	* Check the meta class of the root classes (NSObject) is itself. We should test whether the super caller for a class method should invoke the corresponding instance method. 
 	* Known issue: Multi-targets will cause wrong selector chain, because of the wrong method loading address.
	* Test the selector chain behavior.
 	* Test whether Obj-C category method will overwrite the selector chain.

 - Reliability
 	* Add more test cases.

 - Help 3rd party library embedding XAspect
	* Multiple executables/target loading issue. Avoid the duplicate symbols (functions/classes/methods) of XAspect in separated libraries using XAspect.
		* Provide a framework to be shared between libraries and projects.
	* Test in:
		* Extension
		* Framework
		* Unit test targets
		* static libraries

 - Usability (Injection)
 	* "Can we inject aspect into multiple methods from multiple classes?" Try to share the same aspect implementation for multiple aspect classes (one patch be injected into multiple target classes).
	* Inject patches into a class which you don't have its class hierarchy (headers) but you know the class name (a string).
	* Inject patches to a class which you don't have. Assert at weaving time when loading.


**@2.0.0**

 - Improve performance
	* Multi-threading to improve the performance for sorting and weaving aspect patch implementations.

 - Try to support Swift
	


**@someday**

 - Use `@XAspect(AspectName) ... @endXAspect` statement instead of `#define AtAspect AspectName ... #undef AtAspect` to create an aspect field.

	* Currently, I don't find a way to do that. You can't use a C macro to define another C macro with C99:


			// The following macros don't work.
			#define XAspect(AspectName) class NSObject; #define AtAspect AspectName
			#define endXAspect class NSObject; #undef AtAspect

 - Refactor (method rename) problem: Xcode will crash.
 - Ensure user did invoke `XAMessageForward()`
	* Raising compiler error, not just warning.
	* Check when weaving (just loaded), not invoking time.

  - Auto-synthesize null and super caller implementation in `AspectPatch()`.
	* We can use C++ template to generate the null return value implementation.
	* We need to find a way to invoke the super's super implementation. Because the XAspect subclasses the target class to implement the patches, the keyword `super` is equal to the target class itself, not the superclass of the target class.

