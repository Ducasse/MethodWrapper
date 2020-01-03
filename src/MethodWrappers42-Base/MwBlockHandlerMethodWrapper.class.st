"
MwBlockHandlerMethodWrapper allows one to wrap methods with an exception handler.
"
Class {
	#name : #MwBlockHandlerMethodWrapper,
	#superclass : #MwMethodWrapper,
	#type : #bytes,
	#category : #'MethodWrappers42-Base'
}

{ #category : #'class initialization' }
MwBlockHandlerMethodWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
]

{ #category : #private }
MwBlockHandlerMethodWrapper class >> methodPropertiesClass [

	^MwBlockHandlerMethodWrapperInstVars
]

{ #category : #evaluating }
MwBlockHandlerMethodWrapper >> afterMethod [

	self shouldNotImplement.
]

{ #category : #evaluating }
MwBlockHandlerMethodWrapper >> beforeMethod [

	self shouldNotImplement.
]

{ #category : #initialization }
MwBlockHandlerMethodWrapper >> class: aClass selector: aSymbol [

	super class: aClass selector: aSymbol.
	self
		exception: Error;
		handlerBlock: [:receiver :arguments :ex | ].
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> exception [

	^self properties exception
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> exception: anExceptionClass [

	^self properties exception: anExceptionClass
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> handlerBlock [

	^self properties handlerBlock
]

{ #category : #'derived accessing' }
MwBlockHandlerMethodWrapper >> handlerBlock: aBlockClosure [

	^self properties handlerBlock: aBlockClosure
]

{ #category : #evaluating }
MwBlockHandlerMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [

	self wasActive: true.
	^[self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects]
		on: self exception
		do: [:ex | self handlerBlock value: anObject value: anArrayOfObjects value: ex]
]
