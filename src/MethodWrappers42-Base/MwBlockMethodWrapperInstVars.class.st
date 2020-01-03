"
Instance Variables:

	beforeBlock	<BlockClosure>
	afterBlock		<BlockClosure>
"
Class {
	#name : #MwBlockMethodWrapperInstVars,
	#superclass : #MwMethodWrapperInstVars,
	#type : #variable,
	#instVars : [
		'beforeBlock',
		'afterBlock'
	],
	#category : #'MethodWrappers42-Base'
}

{ #category : #accessing }
MwBlockMethodWrapperInstVars >> afterBlock [
	"^ <BlockContext>"

	^ afterBlock
]

{ #category : #accessing }
MwBlockMethodWrapperInstVars >> afterBlock: aBlockContext [
	^afterBlock := aBlockContext
]

{ #category : #accessing }
MwBlockMethodWrapperInstVars >> beforeBlock [ "^<BlockClosure>"

	^beforeBlock
]

{ #category : #accessing }
MwBlockMethodWrapperInstVars >> beforeBlock: aBlockContext [
	^beforeBlock := aBlockContext
]
