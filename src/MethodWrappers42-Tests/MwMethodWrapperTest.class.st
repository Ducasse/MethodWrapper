Class {
	#name : #MwMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #running }
MwMethodWrapperTest >> tearDown [
	"make sure the wrappers are properly torn down or all hell breaks loose running these tests."
	{MwClassA. MwClassB} do:
		[:c|
		c selectorsAndMethodsDo:
			[:s :m|
			m class ~~ CompiledMethod ifTrue:
				[m clientMethod == m
					ifTrue: [self halt] "This definitely should not happen, and prevents correct uninstallation"
					ifFalse:
						[Transcript
							ensureCr;
							nextPutAll: 'warning, '; print: thisContext home;
							nextPutAll: ' had to uninstall '; print: c; nextPut: $>; nextPutAll: s;
							nextPutAll: ' after test '; print: self class; nextPut: $>; print: testSelector.
						 [(c compiledMethodAt: s) class ~~ CompiledMethod] whileTrue:
							[(c compiledMethodAt: s) uninstall]]]]]
]

{ #category : #tests }
MwMethodWrapperTest >> testCanWrapInClass [

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
MwMethodWrapperTest >> testChainRemoveLastFirst [

	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapperTwo := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperTwo uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: wrapperTwo clientMethod == nil.
	wrapperOne uninstall.
	self assert: wrapperOne clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #tests }
MwMethodWrapperTest >> testChainRemoveLastFirstHierarchy [

	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapperTwo := self wrapperClass on: #methodOne inClass: MwClassB.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: (MwClassB compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperTwo uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: wrapperTwo clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: (MwClassB compiledMethodAt: #methodOne ifAbsent: [nil]) == nil.
	wrapperOne uninstall.
	self assert: wrapperOne clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.

]

{ #category : #tests }
MwMethodWrapperTest >> testChainRemoveMiddleFirst [

	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapperTwo := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperOne uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperTwo.
	self assert: wrapperOne clientMethod == nil.
	wrapperTwo uninstall.
	self assert: wrapperTwo clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #tests }
MwMethodWrapperTest >> testChainRemoveMiddleFirstHierarchy [

	| wrapperOne wrapperTwo |
	wrapperOne := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapperTwo := self wrapperClass on: #methodOne inClass: MwClassB.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapperOne install.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	wrapperTwo install.
	self assert: wrapperOne wrappingWrapper == wrapperTwo.
	self assert: wrapperTwo wrappingWrapper == nil.
	self assert: wrapperTwo clientMethod == wrapperOne.
	self assert: (MwClassA compiledMethodAt: #methodOne) == wrapperOne.
	self assert: (MwClassB compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperOne uninstall.
	self assert: wrapperOne wrappingWrapper == nil.
	self assert: wrapperOne clientMethod == nil.
	self assert: wrapperTwo clientMethod ~~ nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	self assert: (MwClassB compiledMethodAt: #methodOne) == wrapperTwo.
	wrapperTwo uninstall.
	self assert: wrapperTwo clientMethod == nil.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	self assert: (MwClassB compiledMethodAt: #methodOne ifAbsent: [nil]) == nil.
]

{ #category : #tests }
MwMethodWrapperTest >> testClassInstVars [

	self assert: self wrapperClass class instVarNames size = 1.
	self assert: self wrapperClass classVarNames size = 0.

	self assert: self wrapperClass protoMethods ~~ nil.
	self assert: self wrapperClass protoMethods class == Dictionary.
]

{ #category : #tests }
MwMethodWrapperTest >> testCodeString0 [

	| expected actual |
	expected := 'value
	^#''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: {}'.
	actual := self wrapperClass codeStringFor: 0.
	self assert: expected = actual
]

{ #category : #tests }
MwMethodWrapperTest >> testCodeString1 [

	| expected actual |
	expected := 'value: t1
	^#''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: {t1}'.
	actual := self wrapperClass codeStringFor: 1.
	self assert: expected = actual
]

{ #category : #tests }
MwMethodWrapperTest >> testCodeString2 [

	| expected actual |
	expected := 'value: t1 value: t2
	^#''The method wrapper should be inserted in this position!'' valueWithReceiver: self arguments: {t1. t2}'.
	actual := self wrapperClass codeStringFor: 2.
	self assert: expected = actual
]

{ #category : #tests }
MwMethodWrapperTest >> testDefiningWrappedDifferent [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodOne.
	wrappedClass := MwClassB.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == MwClassA.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #tests }
MwMethodWrapperTest >> testDefiningWrappedSame [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodOne.
	wrappedClass := MwClassA.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #tests }
MwMethodWrapperTest >> testDefiningWrappedSame2 [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodTwo.
	wrappedClass := MwClassA.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #tests }
MwMethodWrapperTest >> testDefiningWrappedSame3 [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodTwo.
	wrappedClass := MwClassB.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #tests }
MwMethodWrapperTest >> testDefiningWrappedSame4 [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodThree.
	wrappedClass := MwClassB.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	wrapper install.
	self assert: wrapper definingClass == wrappedClass.
	self assert: wrapper wrappedClass == wrappedClass.
	wrapper uninstall.
]

{ #category : #tests }
MwMethodWrapperTest >> testDerivedInstVars [

	| wrapper |
	wrapper := self wrapperClass new.
	self assert: wrapper clientSelector == nil.
	self assert: wrapper clientMethod == nil.
	self assert: wrapper definingClass == nil.
	self assert: wrapper wrappedClass == nil.
	self assert: wrapper wrappingWrapper == nil.
]

{ #category : #tests }
MwMethodWrapperTest >> testInstallInstantiateUninstall [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	wrapper install.
	instance := MwClassA new.
	instance methodOne.
	wrapper uninstall.
	instance methodOne.
]

{ #category : #tests }
MwMethodWrapperTest >> testInstallUninstall [

	| wrapper |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
	wrapper install.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == self wrapperClass.
	wrapper uninstall.
	self assert: (MwClassA compiledMethodAt: #methodOne) class == CompiledMethod.
]

{ #category : #tests }
MwMethodWrapperTest >> testInstantiateInstallUninstall [

	| wrapper instance |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	instance := MwClassA new.
	instance methodOne.
	wrapper install.
	instance methodOne.
	wrapper uninstall.
	instance methodOne.
]

{ #category : #tests }
MwMethodWrapperTest >> testMethodPosition0 [

	| expected actual |
	expected := 3.
	actual := (self wrapperClass createMethodFor: 0) methodPosition.
	self assert: expected = actual
]

{ #category : #tests }
MwMethodWrapperTest >> testMethodPosition1 [

	| expected actual |
	expected := 3.
	actual := (self wrapperClass createMethodFor: 1) methodPosition.
	self assert: expected = actual
]

{ #category : #tests }
MwMethodWrapperTest >> testMethodPosition2 [

	| expected actual |
	expected := 3.
	actual := (self wrapperClass createMethodFor: 2) methodPosition.
	self assert: expected = actual
]

{ #category : #tests }
MwMethodWrapperTest >> testNoProtoInstanceCount [

	| allInstCount protoInstCount |

	Smalltalk garbageCollect.
	allInstCount := self wrapperClass allInstances size.
	protoInstCount := self wrapperClass protoMethods size.
	self assert: (allInstCount - protoInstCount) = 0.
]

{ #category : #tests }
MwMethodWrapperTest >> testOnInClass [

	| wrapper clientSelector wrappedClass |
	clientSelector := #methodOne.
	wrappedClass := MwClassA.
	wrapper := self wrapperClass on: clientSelector inClass: wrappedClass.
	self assert: wrapper clientSelector == clientSelector.
	self assert: wrapper clientMethod == nil.
	self assert: wrapper definingClass == nil.
	self assert: wrapper wrappedClass == wrappedClass.
	self assert: wrapper wrappingWrapper == nil.
	self assert: (wrapper realObjectAt: wrapper methodPosition) == wrapper.
	wrapper uninstall.
]

{ #category : #tests }
MwMethodWrapperTest >> testTweakClassFormat [

	self assert: (self wrapperClass format bitAnd: 16r200) = 16r200.
]

{ #category : #tests }
MwMethodWrapperTest >> testTweakClassFormatAllSubclasses [

	self wrapperClass withAllSubclassesDo: [:each |
		self assert: each instSpec = CompiledMethod instSpec].
]

{ #category : #tests }
MwMethodWrapperTest >> testWasActive [

	| wrapper |
	wrapper := self wrapperClass on: #methodOne inClass: MwClassA.
	self deny: wrapper wasActive.
	wrapper install.
	self deny: wrapper wasActive.
	wrapper uninstall.
	self deny: wrapper wasActive.
	self shouldnt: [wrapper install] raise: Error.
	wrapper uninstall
]

{ #category : #private }
MwMethodWrapperTest >> wrapperClass [

	^ MwMethodWrapper
]
