"
A MwMethodBreakpointWrapper arranges to raise the Halt signal on entry to its wrapped or client method, removing the intervening MwMethodBreakpointWrapper activations as it does so, typically leaving execution suspended on entry to the wrapped method.  It is careful to avoid breakpointing a quick method (^self,^inst var et al), creating a substitute non-quick version if necessary.  The debugger machinery can't execute a quick method and so to support breakpointing and continuing a quick method this subterfuge is required.

Whether the breakpoint is shown for the clientMethod (which may be a method wrapper oif there are multiple wrappers) or the unwraped method is controlled by the variable breakInUnwrapped, which is true and hence breaks for the unwrapped method by default.

N.B.  We do not implement nonQuickClientMethod: since this is a cache that reflects clientMethod, not an independent variable.  We do not implement nonQuickUnwrappedMethod: because if the unwrapped method changes the wrapper wil have been replaced in whatever method dictionary it was in and will be obsolete.

Instance Variables
	breakInUnwrapped <Boolean>
	nonQuickClientMethod <CompiledMethod|nil>
	nonQuickUnwrappedMethod <CompiledMethod|nil>
"
Class {
	#name : #MwMethodBreakpointWrapper,
	#superclass : #MwMethodWrapper,
	#type : #bytes,
	#category : #'MethodWrappers42-Examples'
}

{ #category : #private }
MwMethodBreakpointWrapper class >> methodPropertiesClass [

	^MwMethodBreakpointWrapperInstVars
]

{ #category : #'derived accessing' }
MwMethodBreakpointWrapper >> breakInUnwrapped [
	^self properties breakInUnwrapped
]

{ #category : #'derived accessing' }
MwMethodBreakpointWrapper >> breakInUnwrapped: aBoolean [
	^self properties breakInUnwrapped: aBoolean
]

{ #category : #'derived accessing' }
MwMethodBreakpointWrapper >> clientMethod: aCompiledMethod [
	"Override to void the nonQuickClientMethod cache when the client method is changed."
	self properties nonQuickClientMethod: nil.
	^super clientMethod: aCompiledMethod
]

{ #category : #private }
MwMethodBreakpointWrapper >> findInnerWrapperActivationFrom: startContext [
	| unwrappedMethod wrapperContext |
	unwrappedMethod := self unwrappedMethod.
	wrapperContext := startContext.
	[wrapperContext method unwrappedMethod == unwrappedMethod
	 and: [wrapperContext method isMwMethodWrapper]] whileFalse:
		[wrapperContext := wrapperContext sender].
	^wrapperContext
]

{ #category : #private }
MwMethodBreakpointWrapper >> findOuterWrapperActivationFrom: startContext unwrappedMethod: unwrappedMethod [
	| wrapperContext |
	wrapperContext := startContext.
	[wrapperContext isNil ifTrue: [^nil].
	 wrapperContext method unwrappedMethod == unwrappedMethod
	 and: [wrapperContext method isMwMethodWrapper]] whileFalse:
		[wrapperContext := wrapperContext sender].
	^(self
		findOuterWrapperActivationFrom: wrapperContext sender
		unwrappedMethod: unwrappedMethod)
			ifNil: [wrapperContext]
			ifNotNil: [:outerContext| outerContext]
]

{ #category : #'derived accessing' }
MwMethodBreakpointWrapper >> nonQuickClientMethod [
	"Answer the cached nonQuickClientMethod, computing it if required." 
	^self properties nonQuickClientMethod ifNil:
		[self properties nonQuickClientMethod:
			(self clientMethod isQuick
				ifTrue:
					[(self definingClass compilerClass new
							compile: self clientMethod getSource
							in: self definingClass
							notifying: nil
							ifFail: [self error: 'could not compile non-quick method'])
						ensureNotQuick;
						generate: self clientMethod trailer using: self clientMethod class]
				ifFalse:
					[self clientMethod])]
]

{ #category : #private }
MwMethodBreakpointWrapper >> nonQuickMethodToHaltIn [
	"Answer the non-quick version of either the unwrapped (default) or client method,
	 depending on breakInUnwrapped."
	^self breakInUnwrapped
		ifTrue: [self nonQuickUnwrappedMethod]
		ifFalse: [self nonQuickClientMethod]
]

{ #category : #'derived accessing' }
MwMethodBreakpointWrapper >> nonQuickUnwrappedMethod [
	"Answer the cached nonQuickUnwrappedMethod, computing it if required." 
	^self properties nonQuickUnwrappedMethod ifNil:
		[self properties nonQuickUnwrappedMethod:
			(self unwrappedMethod isQuick
				ifTrue:
					[(self definingClass compilerClass new
							compile: self unwrappedMethod getSource
							in: self definingClass
							notifying: nil
							ifFail: [self error: 'could not compile non-quick method'])
						ensureNotQuick;
						generate: self unwrappedMethod trailer using: self unwrappedMethod class]
				ifFalse:
					[self unwrappedMethod])]
]

{ #category : #evaluating }
MwMethodBreakpointWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [
	"Raise the Halt signal on entry to the wrapped method, while removing any activations
	 associated with the wrapper.  Do this by a) creating an activation of the wrapped method
	 and making its sender the sender of the  message that invoked this wrapper, and b) by
	 creating an activation of Object>>halt whose sender is the wrapped method activation,
	 and returning (eventually to the halt activation), there-by raising the Halt signal."
	| wrapperContext haltContext methodContext |
	self wasActive: true.
	wrapperContext := self findInnerWrapperActivationFrom: thisContext sender.
	"create an activation of the client method, safe for debugging (i.e. not quick, if quick)"
	methodContext := MethodContext
							sender: wrapperContext sender
							receiver: anObject
							method: self nonQuickMethodToHaltIn
							arguments: anArrayOfObjects.
	"create a Halt activation above it that will raise the halt signal."
	haltContext := MethodContext
							sender: methodContext
							receiver: anObject
							method: Object >> #halt
							arguments: #().
	wrapperContext swapSender: haltContext.
	^self
]
