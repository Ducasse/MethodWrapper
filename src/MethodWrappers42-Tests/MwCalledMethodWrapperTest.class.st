Class {
	#name : #MwCalledMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwCalledMethodWrapperTest >> testCalledWasActive [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper called not.
	self assert: wrapper wasActive not.
	instance methodOne.
	self assert: wrapper wasActive.
	wrapper uninstall.
]

{ #category : #tests }
MwCalledMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size equals: 1.
	self assert: self wrapperClass classVarNames size equals: 0.

	self assert: self wrapperClass installing equals: false.

	self assert: self wrapperClass methodPropertiesClass == MwCalledMethodWrapperInstVars.
	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #private }
MwCalledMethodWrapperTest >> wrapperClass [

	^ MwCalledMethodWrapper
]
