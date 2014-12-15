Release Notes
=============

This document contains the following sections:

* [Restrictions for Current Version](#restrictions_for_current_version)
* [Versions and Release Notes](#versions_and_release_notes)

Restrictions for Current Version
--------------------------------

- Don't use the keyword `super` in the `@classPatchField() ... @end` field. The keyword `super`  is equivalent to `self` in the `@classPatchField() ... @end` field.

- XAspect doesn't support any variadic method for aspect patches (e.g. `+[NSArray  arrayWithObjects:(id)firstObj, ...]`).


Versions and Release Notes
--------------------------

### Version 1.0.3
	
 - Fix the aspect patch assertion failure problem. Shared aspect file between targets won't cause the assertion fails.

### Version 1.0.2

 - Move *XAInjectionTemplate.{h, cpp}* to unused folder. This file currently is unused in XAspect.

### Version 1.0.1

 - Make the class parameter in `@classPatchField()` auto completable. Make the code snippet useful.

### Version 1.0.0

 - Remove Obj-C code from library to avoid trigger any Obj-C messaging before finishing weaving. Use C/C++ code instead.

 - Create a DSL (domain-specific language) for Obj-C to do aspect-oriented programming more intuitively (`AtAspect` keyword, `@classPatchField()...@end`, `AspectPatch()`, etc.).

 - Implement Safe category (the same as **libextobjc**).

 - Ignored method lists for safe category and aspect methods (ignore `+load` for safe category and aspect methods.
