"
A MwBlockMethodResultWrapper allows wrapping a method with optional before, after and curtailed blocks.  The before and curtailed blocks take the receiver and arguments as their arguments, whereas the after block takes the receiver arguments and result as arguments.  For example,

	| indent wrapper |
	indent := 0.
	wrapper := MwBlockMethodResultWrapper on: #benchFib inClass: Integer.
	wrapper
		beforeBlock: [:rcvr :selector :args|
					Transcript crtab: indent; print: rcvr; space; nextPutAll: selector; flush.
					indent := indent + 1];
		afterBlock: [:rcvr :selector :args :result| indent := indent - 1. Transcript crtab: indent; print: rcvr; space; nextPutAll: selector; nextPutAll: ' -> '; print: result; flush].
	[wrapper install.
	 7 benchFib] ensure: [wrapper uninstall]
"
Class {
	#name : #MwBlockMethodResultWrapper,
	#superclass : #MwBlockMethodWrapper,
	#type : #bytes,
	#category : #'MethodWrappers42-Base'
}

{ #category : #private }
MwBlockMethodResultWrapper class >> methodPropertiesClass [

	^MwBlockMethodResultWrapperInstVars
]

{ #category : #initialization }
MwBlockMethodResultWrapper >> class: aClass selector: aSymbol [
	super class: aClass selector: aSymbol.
	self curtailedBlock: nil
]

{ #category : #'derived accessing' }
MwBlockMethodResultWrapper >> curtailedBlock [

	^self properties curtailedBlock
]

{ #category : #'derived accessing' }
MwBlockMethodResultWrapper >> curtailedBlock: aBlockClosure [

	^self properties curtailedBlock: aBlockClosure
]

{ #category : #evaluating }
MwBlockMethodResultWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [
	"Optionally evaluate beforeBlock before evaluating clientMethod if beforeBlock is non-nil.
	 Optionally evaluate afterBlock afterwards if a result is returned and afterBlock is non-nil.
	 Optionally evaluate curtailedBlock if evaluation of the method is curtailed and curtailedBlock is non-nil."
	| clientSelector |
	self wasActive: true.
	clientSelector := self clientSelector.
	self beforeBlock ifNotNil:
		[:beforeBlock|
		 beforeBlock value: anObject value: clientSelector value: anArrayOfObjects].
	^[| result |
	   result := self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects.
	   self afterBlock ifNotNil:
		[:afterBlock|
		 afterBlock value: anObject value: clientSelector value: anArrayOfObjects value: result].
	   result]
		ifCurtailed:
			[self curtailedBlock ifNotNil:
				[:curtailedBlock|
				 curtailedBlock value: anObject value: clientSelector value: anArrayOfObjects]]
]
