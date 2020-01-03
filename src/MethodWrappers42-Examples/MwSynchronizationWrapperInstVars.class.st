"
Instance Variables:

	recursionLock	<Monitor>
"
Class {
	#name : #MwSynchronizationWrapperInstVars,
	#superclass : #MwMethodWrapperInstVars,
	#type : #variable,
	#instVars : [
		'recursionLock'
	],
	#category : #'MethodWrappers42-Examples'
}

{ #category : #accessing }
MwSynchronizationWrapperInstVars >> recursionLock [
	"^ <Semaphore>"

	^ recursionLock
]

{ #category : #accessing }
MwSynchronizationWrapperInstVars >> recursionLock: aSemaphore [
	^recursionLock := aSemaphore
]
