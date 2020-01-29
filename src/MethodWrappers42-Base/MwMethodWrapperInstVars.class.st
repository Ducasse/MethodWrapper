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
	"Return the original compiled method that is wrapped by the method wrapper"
	^ clientMethod
]

{ #category : #accessing }
MwMethodWrapperInstVars >> clientMethod: aCompiledMethod [
	clientMethod := aCompiledMethod
]

{ #category : #accessing }
MwMethodWrapperInstVars >> clientSelector [
	"Selector of the wrapped method"

	^ clientSelector
]

{ #category : #accessing }
MwMethodWrapperInstVars >> clientSelector: aSymbol [
	clientSelector := aSymbol
]

{ #category : #accessing }
MwMethodWrapperInstVars >> definingClass [
	"^ <Class>"

	^ definingClass
]

{ #category : #accessing }
MwMethodWrapperInstVars >> definingClass: aClass [
	definingClass := aClass
]

{ #category : #initialization }
MwMethodWrapperInstVars >> initialize [
	super initialize.
	self wasActive: false.
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wasActive [
	
	^ wasActive
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wasActive: aBoolean [
	wasActive := aBoolean
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappedClass [

	^ wrappedClass
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappedClass: aClass [
	wrappedClass := aClass
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappingWrapper [

	^ wrappingWrapper
]

{ #category : #accessing }
MwMethodWrapperInstVars >> wrappingWrapper: aMwMethodWrapper [
	^wrappingWrapper := aMwMethodWrapper
]
