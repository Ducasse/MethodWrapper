"
A count method wrapper counts the number of times the method is called.
"
Class {
	#name : #MwCountMethodWrapper,
	#superclass : #MwMethodWrapper,
	#type : #bytes,
	#category : #'MethodWrappers42-Examples'
}

{ #category : #'class initialization' }
MwCountMethodWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
]

{ #category : #private }
MwCountMethodWrapper class >> methodPropertiesClass [

	^MwCountMethodWrapperInstVars
]

{ #category : #evaluating }
MwCountMethodWrapper >> beforeMethod [

	self count: self count + 1.
]

{ #category : #initialization }
MwCountMethodWrapper >> class: aClass selector: aSymbol [

	self count: 0.
	^ super class: aClass selector: aSymbol
]

{ #category : #'derived accessing' }
MwCountMethodWrapper >> count [

	^self properties count
]

{ #category : #'derived accessing' }
MwCountMethodWrapper >> count: anInteger [

	^self properties count: anInteger
]
