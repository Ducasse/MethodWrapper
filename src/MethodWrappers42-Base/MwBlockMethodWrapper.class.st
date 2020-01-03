"
A MwBlockMethodWrapper allows wrapping a method with optional before and after blocks that take the receiver and arguments as their arguments.  For example,

	| indent wrapper |
	indent := 0.
	wrapper := MwBlockMethodWrapper on: #benchFib inClass: Integer.
	wrapper
		beforeBlock: [:rcvr :args|
					Transcript crtab: indent; print: rcvr; space; nextPutAll: #benchFib; flush.
					indent := indent + 1];
		afterBlock: [:rcvr :args| indent := indent - 1].
	[wrapper install.
	 7 benchFib] ensure: [wrapper uninstall]
"
Class {
	#name : #MwBlockMethodWrapper,
	#superclass : #MwMethodWrapper,
	#type : #bytes,
	#category : #'MethodWrappers42-Base'
}

{ #category : #'class initialization' }
MwBlockMethodWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
]

{ #category : #private }
MwBlockMethodWrapper class >> methodPropertiesClass [

	^MwBlockMethodWrapperInstVars
]

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> afterBlock [

	^self properties afterBlock
]

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> afterBlock: aBlockClosure [

	^self properties afterBlock: aBlockClosure
]

{ #category : #evaluating }
MwBlockMethodWrapper >> afterMethod [

	self shouldNotImplement.
]

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> beforeBlock [

	^self properties beforeBlock
]

{ #category : #'derived accessing' }
MwBlockMethodWrapper >> beforeBlock: aBlockClosure [

	^self properties beforeBlock: aBlockClosure
]

{ #category : #evaluating }
MwBlockMethodWrapper >> beforeMethod [

	self shouldNotImplement.
]

{ #category : #initialization }
MwBlockMethodWrapper >> class: aClass selector: aSymbol [
	super class: aClass selector: aSymbol.
	self beforeBlock: nil; afterBlock: nil
]

{ #category : #evaluating }
MwBlockMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [
	"Optionally evaluate beforeBlock before evaluating clientMethod if beforeBlock is non-nil.
	 Optionally evaluate afterBlock afterwards if afterBlock is non-nil."
	self wasActive: true.
	self beforeBlock ifNotNil:
		[:beforeBlock| beforeBlock value: anObject value: anArrayOfObjects].
	^self afterBlock
		ifNil: [self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects]
		ifNotNil:
			[:afterBlock|
			[self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects]
				ensure: [afterBlock value: anObject value: anArrayOfObjects]]
]
