Class {
	#name : #MwMethodWrapperInfrastructureTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwMethodWrapperInfrastructureTest >> testCanWrapInClass [

	"Method wrappers can NOT be wrapped."
	self deny: (self wrapperClass canWrap: #spunk inClass: self wrapperClass).

	"BlockContext>>ensure: can NOT be wrapped."
	self deny: (self wrapperClass canWrap: #ensure: inClass: BlockClosure).

	"CompiledMethod>>valueWithReceiver:arguments: can NOT be wrapped."
	self deny: (self wrapperClass
		canWrap: #valueWithReceiver:arguments: inClass: CompiledMethod).

	"A method that is not implemented by a class/object can NOT be wrapped."
	self assert: ((Object canUnderstand: #ensure:) not
		and: [(self wrapperClass canWrap: #ensure: inClass: Object) not]).

	"Certain primitives may NOT be wrapped."
	self assert: ((Object includesSelector: #at:put:)
		and: [(self wrapperClass canWrap: #at:put: inClass: Object) not]).
	self assert: ((BlockClosure includesSelector: #value)
		and: [(self wrapperClass canWrap: #value inClass: BlockClosure) not]).
]

{ #category : #tests }
MwMethodWrapperInfrastructureTest >> testCodeString0 [

	| expected actual |
	expected := 'value
	^#''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: {}'.
	actual := self wrapperClass codeStringFor: 0.
	self assert: expected equals: actual
]

{ #category : #tests }
MwMethodWrapperInfrastructureTest >> testCodeString1 [

	| expected actual |
	expected := 'value: t1
	^#''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: {t1}'.
	actual := self wrapperClass codeStringFor: 1.
	self assert: expected equals: actual
]

{ #category : #tests }
MwMethodWrapperInfrastructureTest >> testCodeString2 [

	| expected actual |
	expected := 'value: t1 value: t2
	^#''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: {t1. t2}'.
	actual := self wrapperClass codeStringFor: 2.
	self assert: expected equals: actual
]

{ #category : #tests }
MwMethodWrapperInfrastructureTest >> wrapperClass [

	^ MwMethodWrapper
]
