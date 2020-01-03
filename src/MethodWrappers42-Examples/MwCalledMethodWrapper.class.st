"
A called method wrapper is a special method wrapper that uninstalls itself once it has been called. Although this is initially slower than the count method wrapper, it will speed up to be the same speed as the unwrapped code.

Class Instance Variables:

	installing	<Boolean>
					Are we installing the wrappers? During installation, some of the
					methods might be called, but we shouldn't tag them as being called,
					since it results from the installation process, not normal code execution.
"
Class {
	#name : #MwCalledMethodWrapper,
	#superclass : #MwMethodWrapper,
	#type : #bytes,
	#classInstVars : [
		'installing'
	],
	#category : #'MethodWrappers42-Examples'
}

{ #category : #'class initialization' }
MwCalledMethodWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
	self installing: false.
]

{ #category : #accessing }
MwCalledMethodWrapper class >> installing [
	"^ <Boolean>"

	^ installing
]

{ #category : #accessing }
MwCalledMethodWrapper class >> installing: aBoolean [
	^installing := aBoolean
]

{ #category : #private }
MwCalledMethodWrapper class >> methodPropertiesClass [

	^MwCalledMethodWrapperInstVars
]

{ #category : #evaluating }
MwCalledMethodWrapper >> afterMethod [

	self called ifTrue: [self uninstall].
]

{ #category : #evaluating }
MwCalledMethodWrapper >> beforeMethod [

	(self called or: [self installing])
		ifFalse: [self called: true].
]

{ #category : #'derived accessing' }
MwCalledMethodWrapper >> called [

	^self properties called
]

{ #category : #'derived accessing' }
MwCalledMethodWrapper >> called: aBoolean [

	^self properties called: aBoolean
]

{ #category : #initialization }
MwCalledMethodWrapper >> class: aClass selector: aSymbol [

	self called: false.
	^ super class: aClass selector: aSymbol
]

{ #category : #'derived accessing' }
MwCalledMethodWrapper >> installing [

	^ self class installing
]
