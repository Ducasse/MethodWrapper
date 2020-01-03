"
A synchronization wrapper synchronizes method calls by using a recursion lock. The call to the original method is protected by the Monitor>>critical: method.
"
Class {
	#name : #MwSynchronizationWrapper,
	#superclass : #MwMethodWrapper,
	#type : #bytes,
	#category : #'MethodWrappers42-Examples'
}

{ #category : #testing }
MwSynchronizationWrapper class >> canWrap: aSelector inClass: aClass [

	self flag: #rhi. "Verify that Object>>primitiveChangeClassTo: will not fail!"
	"^ super canWrap: aSelector inClass: aClass"

	"This could cause infinite recursion if wrapping classes."
	^ true
]

{ #category : #'class initialization' }
MwSynchronizationWrapper class >> initialize [
	"doIt: [self initialize]"

	super initialize.
]

{ #category : #installation }
MwSynchronizationWrapper class >> installOn: aClass [

	| lock wrappers |
	lock := Monitor new.
	self flag: #rhi. "Shouldn't that be #allSelectors?!"
	wrappers := aClass selectors asOrderedCollection collect: [:each |
		(self on: each inClass: aClass)
			recursionLock: lock;
			install;
			yourself].
	^wrappers
]

{ #category : #installation }
MwSynchronizationWrapper class >> installOnObject: anObject [

	| oldClass newBehavior lock |
	oldClass := anObject class.
	newBehavior := Behavior new.
	newBehavior instVarNamed: 'format' put: oldClass format.
	newBehavior superclass: oldClass.
	newBehavior methodDictionary: MethodDictionary new.
	self flag: #rhi. "Call self>>#installOn: instead! (#allSelectors vs. #selectors?!)"
	lock := Monitor new.
	newBehavior allSelectors asOrderedCollection collect: [:each |
		(self on: each inClass: newBehavior)
			recursionLock: lock;
			install;
			yourself].
	newBehavior
		addSelector: #synchronize
		withMethod: (self class compiledMethodAt: #synchronize).
	newBehavior
		addSelector: #unsynchronize
		withMethod: (self class compiledMethodAt: #unsynchronize).
	anObject primitiveChangeClassTo: newBehavior basicNew
]

{ #category : #private }
MwSynchronizationWrapper class >> methodPropertiesClass [

	^MwSynchronizationWrapperInstVars
]

{ #category : #private }
MwSynchronizationWrapper class >> synchronize [
]

{ #category : #installation }
MwSynchronizationWrapper class >> uninstallOn: aClass [

	aClass selectors do: [:each |
			| method |
			method := aClass compiledMethodAt: each.
			method isMwMethodWrapper ifTrue: [method uninstall]].
]

{ #category : #installation }
MwSynchronizationWrapper class >> uninstallOnObject: anObject [

	anObject primitiveChangeClassTo: anObject class superclass basicNew.
]

{ #category : #private }
MwSynchronizationWrapper class >> unsynchronize [

	self uninstallOnObject: self.
]

{ #category : #evaluating }
MwSynchronizationWrapper >> afterMethod [

	self shouldNotImplement.
]

{ #category : #evaluating }
MwSynchronizationWrapper >> beforeMethod [

	self shouldNotImplement.
]

{ #category : #'derived accessing' }
MwSynchronizationWrapper >> recursionLock [

	^self properties recursionLock
]

{ #category : #'derived accessing' }
MwSynchronizationWrapper >> recursionLock: aMonitor [

	^self properties recursionLock: aMonitor
]

{ #category : #evaluating }
MwSynchronizationWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [

	self flag: #rhi. "Need to ensure RecursionLock semantics!"
	^self recursionLock critical:
		[self wasActive: true.
		 self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects]
]
