"
Instance Variables:

	clientSelector		<Symbol>
	clientMethod		<CompiledMethod>
	definingClass		<Class>
	wrappedClass		<Class>
	wrappingWrapper	<MwMethodWrapper>
"
Class {
	#name : #MwMethodWrapperInstVars,
	#superclass : #AdditionalMethodState,
	#type : #variable,
	#instVars : [
		'clientSelector',
		'clientMethod',
		'definingClass',
		'wrappedClass',
		'wrappingWrapper',
		'wasActive'
	],
	#category : #'MethodWrappers42-Base'
}

{ #category : #accessing }
MwMethodWrapperInstVars >> clientMethod [
	"^ <CompiledMethod>"

	^ clientMethod
]

{ #category : #accessing }
MwMethodWrapperInstVars >> clientMethod: aCompiledMethod [
	^clientMethod := aCompiledMethod
]

{ #category : #accessing }
MwMethodWrapperInstVars >> clientSelector [
	"^ <Symbol>"

	^ clientSelector
]

{ #category : #accessing }
MwMethodWrapperInstVars >> clientSelector: aSymbol [
	^clientSelector := aSymbol
]

{ #category : #accessing }
MwMethodWrapperInstVars >> definingClass [
	"^ <Class>"

	^ definingClass
]

{ #category : #accessing }
MwMethodWrapperInstVars >> definingClass: aClass [
	^definingClass := aClass
]

{ #category : #'initialize-release' }
MwMethodWrapperInstVars >> initialize [
	super initialize.
	self wasActive: false.
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wasActive [
	"^ <Boolean>"

	^wasActive
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wasActive: aBoolean [
	^wasActive := aBoolean
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappedClass [
	"^ <Class>"

	^ wrappedClass
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappedClass: aClass [
	^wrappedClass := aClass
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappingWrapper [
	"^ <MwMethodWrapper>"

	^ wrappingWrapper
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappingWrapper: aMwMethodWrapper [
	^wrappingWrapper := aMwMethodWrapper
]
