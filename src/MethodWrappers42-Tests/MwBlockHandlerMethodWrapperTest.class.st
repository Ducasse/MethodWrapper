Class {
	#name : #MwBlockHandlerMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #running }
MwBlockHandlerMethodWrapperTest >> setUp [

	self result: 0.
]

{ #category : #tests }
MwBlockHandlerMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size = 0.
	self assert: self wrapperClass classVarNames size = 0.

	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #tests }
MwBlockHandlerMethodWrapperTest >> testException [

	| wrapper instance |
	instance := MwClassA new.
	self should: [self result: instance methodWithException] raise: Warning.
	self assert: self result = 0.
	wrapper := self wrapperClass on: #methodWithException inClass: MwClassA.
	wrapper
		exception: Warning;
		handlerBlock: [:receiver :arguments :ex | 42];
		install.
	self shouldnt: [self result: instance methodWithException] raise: Warning.
	wrapper uninstall.
	self assert: self result = 42.
]

{ #category : #tests }
MwBlockHandlerMethodWrapperTest >> testInstallUninstall [

	| wrapper |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapper install.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == self wrapperClass.
	wrapper uninstall.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #tests }
MwBlockHandlerMethodWrapperTest >> testNoException [

	| wrapper instance |
	instance := MwClassA new.
	self shouldnt: [self result: instance methodWithoutException] raise: Warning.
	self assert: self result = 69.
	wrapper := self wrapperClass on: #methodWithoutException inClass: MwClassA.
	wrapper
		exception: Warning;
		handlerBlock: [:receiver :arguments :ex | 42];
		install.
	self shouldnt: [self result: instance methodWithoutException] raise: Warning.
	wrapper uninstall.
	self assert: self result = 69.
]

{ #category : #tests }
MwBlockHandlerMethodWrapperTest >> testNoProtoInstanceCount [

	| allInstCount protoInstCount |

	Smalltalk garbageCollect.
	allInstCount := self wrapperClass allInstances size.
	protoInstCount := self wrapperClass protoMethods size.
	self assert: (allInstCount - protoInstCount) = 0.
]

{ #category : #tests }
MwBlockHandlerMethodWrapperTest >> testOtherException [

	| wrapper instance |
	instance := MwClassA new.
	self should: [instance methodWithException] raise: Warning.
	self assert: self result = 0.
	wrapper := self wrapperClass on: #methodWithException inClass: MwClassA.
	wrapper
		exception: Error;
		handlerBlock: [:receiver :arguments :ex | 42];
		install.
	self should: [self result: instance methodWithException] raise: Warning.
	wrapper uninstall.
	self assert: self result = 0.
]

{ #category : #tests }
MwBlockHandlerMethodWrapperTest >> testTweakClassFormat [

	self assert: (self wrapperClass format bitAnd: 16r200) = 16r200.
]

{ #category : #private }
MwBlockHandlerMethodWrapperTest >> wrapperClass [

	^ MwBlockHandlerMethodWrapper
]
