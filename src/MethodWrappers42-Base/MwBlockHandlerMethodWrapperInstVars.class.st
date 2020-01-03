"
Instance Variables:

	exception		<Exception class>
	handlerBlock	<BlockClosure>
"
Class {
	#name : #MwBlockHandlerMethodWrapperInstVars,
	#superclass : #MwMethodWrapperInstVars,
	#type : #variable,
	#instVars : [
		'exception',
		'handlerBlock'
	],
	#category : #'MethodWrappers42-Base'
}

{ #category : #accessing }
MwBlockHandlerMethodWrapperInstVars >> exception [
	"^ <Exception class>"

	^ exception
]

{ #category : #accessing }
MwBlockHandlerMethodWrapperInstVars >> exception: anExceptionClass [
	^exception := anExceptionClass
]

{ #category : #accessing }
MwBlockHandlerMethodWrapperInstVars >> handlerBlock [
	"^ <BlockContext>"

	^ handlerBlock
]

{ #category : #accessing }
MwBlockHandlerMethodWrapperInstVars >> handlerBlock: aBlockContext [
	^handlerBlock := aBlockContext
]
