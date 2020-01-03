Class {
	#name : #MwTimeMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwTimeMethodWrapperTest >> testAverageTime [

	| wrapper instance count |
	count := 10.
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	count timesRepeat: [instance methodDelay].
	self assert: wrapper count = count.
	self assert: (wrapper time / count asFloat) = wrapper averageTime.
	wrapper uninstall.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size = 0.
	self assert: self wrapperClass classVarNames size = 0.

	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testCounts [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count = 0.
	instance methodDelay.
	self assert: wrapper count = 1.
	instance methodDelay.
	self assert: wrapper count = 2.
	wrapper uninstall.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testCountsAndTimes [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count = 0.
	self assert: wrapper time = 0.
	instance methodDelay.
	self assert: wrapper count = 1.
	self assert: wrapper time > 0.
	instance methodDelay.
	self assert: wrapper count = 2.
	self assert: wrapper time > 0.
	wrapper uninstall.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testNoProtoInstanceCount [

	| allInstCount protoInstCount |

	Smalltalk garbageCollect.
	allInstCount := self wrapperClass allInstances size.
	protoInstCount := self wrapperClass protoMethods size.
	self assert: (allInstCount - protoInstCount) = 0.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testTimes [

	| wrapper instance previousTime |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper time = 0.
	previousTime := wrapper time.
	instance methodDelay.
	self assert: wrapper time > previousTime.
	previousTime := wrapper time.
	instance methodDelay.
	self assert: wrapper time > previousTime.
	wrapper uninstall.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testTweakClassFormat [

	self assert: (self wrapperClass format bitAnd: 16r200) = 16r200.
]

{ #category : #private }
MwTimeMethodWrapperTest >> wrapperClass [

	^ MwTimeMethodWrapper
]
