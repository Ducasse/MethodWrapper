Class {
	#name : #MwTestCase,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'MethodWrappers42-Tests'
}

{ #category : #accessing }
MwTestCase >> result [

	^ result
]

{ #category : #accessing }
MwTestCase >> result: anInteger [

	result := anInteger
]

{ #category : #tests }
MwTestCase >> testNoProtoInstanceCount [

	| allInstCount protoInstCount |

	Smalltalk garbageCollect.
	allInstCount := self wrapperClass allInstances size.
	protoInstCount := self wrapperClass protoMethods size.
	self assert: (allInstCount - protoInstCount) = 0.
]

{ #category : #tests }
MwTestCase >> testTweakClassFormat [

	self assert: (self wrapperClass format bitAnd: 16r200) = 16r200.
]
