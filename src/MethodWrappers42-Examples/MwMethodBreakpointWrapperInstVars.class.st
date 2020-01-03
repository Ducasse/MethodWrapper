Class {
	#name : #MwMethodBreakpointWrapperInstVars,
	#superclass : #MwMethodWrapperInstVars,
	#type : #variable,
	#instVars : [
		'breakInUnwrapped',
		'nonQuickClientMethod',
		'nonQuickUnwrappedMethod'
	],
	#category : #'MethodWrappers42-Examples'
}

{ #category : #accessing }
MwMethodBreakpointWrapperInstVars >> breakInUnwrapped [
	"Answer the value of breakInUnwrapped"

	^ breakInUnwrapped
]

{ #category : #accessing }
MwMethodBreakpointWrapperInstVars >> breakInUnwrapped: anObject [
	"Set the value of breakInUnwrapped"

	^breakInUnwrapped := anObject
]

{ #category : #'initialize-release' }
MwMethodBreakpointWrapperInstVars >> initialize [
	super initialize.
	breakInUnwrapped := true
]

{ #category : #accessing }
MwMethodBreakpointWrapperInstVars >> nonQuickClientMethod [
	"Answer the value of nonQuickClientMethod"

	^ nonQuickClientMethod
]

{ #category : #accessing }
MwMethodBreakpointWrapperInstVars >> nonQuickClientMethod: anObject [
	"Set the value of nonQuickClientMethod"

	^nonQuickClientMethod := anObject
]

{ #category : #accessing }
MwMethodBreakpointWrapperInstVars >> nonQuickUnwrappedMethod [
	"Answer the value of nonQuickUnwrappedMethod"

	^ nonQuickUnwrappedMethod
]

{ #category : #accessing }
MwMethodBreakpointWrapperInstVars >> nonQuickUnwrappedMethod: anObject [
	"Set the value of nonQuickUnwrappedMethod"

	^nonQuickUnwrappedMethod := anObject
]
