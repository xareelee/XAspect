Release Notes
=============

This document contains the following sections:

* [Restrictions for Current Version]
* [Versions and Release Notes]

Restrictions for Current Version
--------------------------------

- Don't use the keyword `super` in the `@asepctOfClass() ... @end` field. The keyword `super`  is equivalent to `self` in the `@asepctOfClass() ... @end` field.

- XAspect doesn't support any variadic method (e.g. `+[NSArray  arrayWithObjects:(id)firstObj, ...]`).

- User should manually synthesize the implementation of the target method if the implementation only exists in its superclass. If you don't, the program will fail to weave the aspect method and lead to be aborted. You may choose one of the following to add the implementation to call the super's implementation:

	* You may directly implement the method to call super in the source `@implementation ... @end` field.

	* You may use Obj-C category to add the implementation to the target class.

	* You may use `@autosynthesizeSuperCaller()` macro in the `@aspectOfClass() ... @end` field to automatically synthesize the implementation to call the super's implementation. XAspect will inject this implementation only when the target class doesn't have its own implementation. It's safer than using Obj-C Category to avoid unnecessary and unsafe override.



Versions and Release Notes
--------------------------

### Version 1.0.0

- Remove Obj-C code from library to avoid trigger Obj-C messaging before finishing weaving. Use C/C++ code instead of.

- Create a DSL (domain-specific language) for Obj-C to do aspect-oriented programming more intuitively (`AtXAspect` keyword, `@aspectOfClass()...@end`, `AspectPatch()`, etc.).

- Two styles to write aspect code –– *free style* (`AspectPatchFreeStyle()`) and *modal style* (`AspectPatchModalStyle()`). The default of `AspectPatch()` is free style.

- auto code completion for method signature (using `autoAspectPatch()` and then removing the prefix `auto`). 

- auto synthesize default implementation and super caller implementation (`_XAutosynthesize()`).

- Implement Safe category (the same as **libextobjc**).

- Ignored method lists for safe category and aspect methods (ignore `+load` and `+initialize` for safe category and aspect methods.
