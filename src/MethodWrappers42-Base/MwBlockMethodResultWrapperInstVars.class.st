"
Instance Variables:

	curtailedBlock		<BlockClosure>
"
Class {
	#name : #MwBlockMethodResultWrapperInstVars,
	#superclass : #MwBlockMethodWrapperInstVars,
	#type : #variable,
	#instVars : [
		'curtailedBlock'
	],
	#category : #'MethodWrappers42-Base'
}

{ #category : #accessing }
MwBlockMethodResultWrapperInstVars >> curtailedBlock [
	"Answer the value of curtailedBlock"

	^curtailedBlock
]

{ #category : #accessing }
MwBlockMethodResultWrapperInstVars >> curtailedBlock: anObject [
	"Set the value of curtailedBlock"

	^curtailedBlock := anObject
]
