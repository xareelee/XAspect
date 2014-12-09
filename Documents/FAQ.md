FAQ
===


Compiler warning
----------------

##### Apple Mach-O Linker Warning: **ld: warning: meta method '<#ClassName#>_XAspectCallSuperImp_<#SelectorName#>' in category from ... conflicts with same method from another category

 - You're repeating to synthesize super caller patches for the same selector. You can simply remove other duplicated auto-synthesizers to resolve this warning.


