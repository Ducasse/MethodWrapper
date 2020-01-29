Class {
	#name : #MwCountMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwCountMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size equals: 0.
	self assert: self wrapperClass classVarNames size equals: 0.

	self assert: self wrapperClass methodPropertiesClass == MwCountMethodWrapperInstVars.
	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #tests }
MwCountMethodWrapperTest >> testCounts [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count = 0.
	instance methodOne.
	self assert: wrapper count = 1.
	instance methodOne.
	self assert: wrapper count = 2.
	wrapper uninstall.
]

{ #category : #private }
MwCountMethodWrapperTest >> wrapperClass [

	^ MwCountMethodWrapper
]
