Class {
	#name : #MwCountMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwCountMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size = 0.
	self assert: self wrapperClass classVarNames size = 0.

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

{ #category : #tests }
MwCountMethodWrapperTest >> testNoProtoInstanceCount [

	| allInstCount protoInstCount |

	Smalltalk garbageCollect.
	allInstCount := self wrapperClass allInstances size.
	protoInstCount := self wrapperClass protoMethods size.
	self assert: (allInstCount - protoInstCount) = 0.
]

{ #category : #tests }
MwCountMethodWrapperTest >> testTweakClassFormat [

	self assert: (self wrapperClass format bitAnd: 16r200) = 16r200.
]

{ #category : #private }
MwCountMethodWrapperTest >> wrapperClass [

	^ MwCountMethodWrapper
]
