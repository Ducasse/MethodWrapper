Class {
	#name : #MwSynchronizationWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwSynchronizationWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size equals: 0.
	self assert: self wrapperClass classVarNames size equals: 0.

	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #private }
MwSynchronizationWrapperTest >> wrapperClass [

	^ MwSynchronizationWrapper
]
