"
Instance Variables:

	called	<Boolean>
"
Class {
	#name : #MwCalledMethodWrapperInstVars,
	#superclass : #MwMethodWrapperInstVars,
	#type : #variable,
	#instVars : [
		'called'
	],
	#category : #'MethodWrappers42-Examples'
}

{ #category : #accessing }
MwCalledMethodWrapperInstVars >> called [
	"^ <Boolean>"

	^ called
]

{ #category : #accessing }
MwCalledMethodWrapperInstVars >> called: aBoolean [
	^called := aBoolean
]
