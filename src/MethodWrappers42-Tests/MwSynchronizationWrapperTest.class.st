Class {
	#name : #MwSynchronizationWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwSynchronizationWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size = 0.
	self assert: self wrapperClass classVarNames size = 0.

	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #tests }
MwSynchronizationWrapperTest >> testNoProtoInstanceCount [

	| allInstCount protoInstCount |

	Smalltalk garbageCollect.
	allInstCount := self wrapperClass allInstances size.
	protoInstCount := self wrapperClass protoMethods size.
	self assert: (allInstCount - protoInstCount) = 0.
]

{ #category : #tests }
MwSynchronizationWrapperTest >> testTweakClassFormat [

	self assert: (self wrapperClass format bitAnd: 16r200) = 16r200.
]

{ #category : #private }
MwSynchronizationWrapperTest >> wrapperClass [

	^ MwSynchronizationWrapper
]
