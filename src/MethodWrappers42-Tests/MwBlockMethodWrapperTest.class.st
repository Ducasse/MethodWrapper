Class {
	#name : #MwBlockMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #running }
MwBlockMethodWrapperTest >> setUp [

	self result: 0.
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testAfter [

	| wrapper instance |
	instance := MwClassA new.
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper
		afterBlock: [:receiver :arguments | self result: self result + 4];
		install.
	instance methodOne.
	wrapper uninstall.
	self assert: self result = 4.
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testBefore [

	| wrapper instance |
	instance := MwClassA new.
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper
		beforeBlock: [:receiver :arguments | self result: self result + 3];
		install.
	instance methodOne.
	wrapper uninstall.
	self assert: self result = 3.
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testBeforeAfter [

	| wrapper instance |
	instance := MwClassA new.
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper
		beforeBlock: [:receiver :arguments | self result: self result + 3];
		afterBlock: [:receiver :arguments | self result: self result + 4];
		install.
	instance methodOne.
	wrapper uninstall.
	self assert: self result = 7.
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testBeforeAfterWithChangedArgument [

	| wrapper instance |
	instance := MwClassA new.
	instance x: 0.
	wrapper := self wrapperClass on: #methodWithArgument: inClass: MwClassA.
	wrapper
		beforeBlock: [:receiver :arguments | arguments at: 1 put: (arguments first raisedTo: 4)];
		afterBlock: [:receiver :arguments | receiver x: receiver x + (arguments first raisedTo: 3)];
		install.
	self result: (instance methodWithArgument: 2).
	wrapper uninstall.
	self assert: self result = 16. "0 + 2^4"
	self assert: instance x = 4112. "0 + 2^4+ (2^4)^3"
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testBeforeAfterWithReceiver [

	| wrapper instance |
	instance := MwClassA new.
	instance x: 0.
	wrapper := self wrapperClass on: #methodWithArgument: inClass: MwClassA.
	wrapper
		beforeBlock: [:receiver :arguments | receiver x: receiver x + 3];
		afterBlock: [:receiver :arguments | receiver x: receiver x + 4];
		install.
	self result: (instance methodWithArgument: 2).
	wrapper uninstall.
	self assert: self result = 5.
	self assert: instance x = 9.
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testBeforeAfterWithReceiverAndArgument [

	| wrapper instance |
	instance := MwClassA new.
	instance x: 0.
	wrapper := self wrapperClass on: #methodWithArgument: inClass: MwClassA.
	wrapper
		beforeBlock: [:receiver :arguments | receiver x: receiver x + (arguments first raisedTo: 2)];
		afterBlock: [:receiver :arguments | receiver x: receiver x + (arguments first raisedTo: 3)];
		install.
	self result: (instance methodWithArgument: 2).
	wrapper uninstall.
	self assert: self result = 6. "0 + 2^2 + 2"
	self assert: instance x = 14. "0 + 2^2 + 2 + 2^3"
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size = 0.
	self assert: self wrapperClass classVarNames size = 0.

	self assert: self wrapperClass methodPropertiesClass == MwBlockMethodWrapperInstVars.
	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #tests }
MwBlockMethodWrapperTest >> testInstallUninstall [

	| wrapper |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapper install.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == self wrapperClass.
	wrapper uninstall.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #private }
MwBlockMethodWrapperTest >> wrapperClass [

	^ MwBlockMethodWrapper
]
