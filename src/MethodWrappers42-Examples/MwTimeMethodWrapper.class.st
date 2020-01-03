"
A time method wrapper counts the number of times the method has been called, along with the total execution time this method has taken.
"
Class {
	#name : #MwTimeMethodWrapper,
	#superclass : #MwCountMethodWrapper,
	#type : #bytes,
	#category : #'MethodWrappers42-Examples'
}

{ #category : #'class initialization' }
MwTimeMethodWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
]

{ #category : #private }
MwTimeMethodWrapper class >> methodPropertiesClass [

	^MwTimeMethodWrapperInstVars
]

{ #category : #evaluating }
MwTimeMethodWrapper >> afterMethod [

	self shouldNotImplement.
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> averageTime [

	^ self count == 0
		ifTrue: [0]
		ifFalse: [self totalTime / self count asFloat]
]

{ #category : #evaluating }
MwTimeMethodWrapper >> beforeMethod [

	self shouldNotImplement.
]

{ #category : #initialization }
MwTimeMethodWrapper >> class: aClass selector: aSymbol [

	self time: 0.
	^ super class: aClass selector: aSymbol
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> time [

	^self properties time
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> time: anInteger [

	^self properties time: anInteger
]

{ #category : #'derived accessing' }
MwTimeMethodWrapper >> totalTime [

	^ self time
]

{ #category : #evaluating }
MwTimeMethodWrapper >> valueWithReceiver: anObject arguments: argumentsArray [
	"This method was overriden so that recursive calls will have a different beginTime."

	| beginTime |
	self wasActive: true.
	beginTime := Time millisecondClockValue.
	self count: self count + 1.
	^[self clientMethod valueWithReceiver: anObject arguments: argumentsArray]
		ensure: [self time: self time + (Time millisecondClockValue - beginTime max: 0)]
]
