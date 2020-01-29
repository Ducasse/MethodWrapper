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
	self assert: wrapper count equals: count.
	self assert: (wrapper time / count asFloat) = wrapper averageTime.
	wrapper uninstall.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size equals: 0.
	self assert: self wrapperClass classVarNames size equals: 0.

	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testCounts [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count equals: 0.
	instance methodDelay.
	self assert: wrapper count equals: 1.
	instance methodDelay.
	self assert: wrapper count equals: 2.
	wrapper uninstall.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testCountsAndTimes [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper count equals: 0.
	self assert: wrapper time equals: 0.
	instance methodDelay.
	self assert: wrapper count equals: 1.
	self assert: wrapper time > 0.
	instance methodDelay.
	self assert: wrapper count equals: 2.
	self assert: wrapper time > 0.
	wrapper uninstall.
]

{ #category : #tests }
MwTimeMethodWrapperTest >> testTimes [

	| wrapper instance previousTime |
	wrapper := self wrapperClass on: #methodDelay inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	self assert: wrapper time equals: 0.
	previousTime := wrapper time.
	instance methodDelay.
	self assert: wrapper time > previousTime.
	previousTime := wrapper time.
	instance methodDelay.
	self assert: wrapper time > previousTime.
	wrapper uninstall.
]

{ #category : #private }
MwTimeMethodWrapperTest >> wrapperClass [

	^ MwTimeMethodWrapper
]
