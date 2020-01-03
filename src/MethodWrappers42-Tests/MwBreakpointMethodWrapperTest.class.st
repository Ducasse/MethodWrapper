Class {
	#name : #MwBreakpointMethodWrapperTest,
	#superclass : #MwTestCase,
	#category : #'MethodWrappers42-Tests'
}

{ #category : #tests }
MwBreakpointMethodWrapperTest >> testBreakpointsAndTracepoints [
	"Test that breakpoints play well with others
		- the wrapped method is run only once
		- the other wrapper action occurs
		- the breakpoint is above the right method."
	| instance bptWrapper blkWrapper blkWrapperInvoked signallerSenderMethod |
	instance := MwClassA new.
	instance x: 0.
	self shouldnt: [self result: instance x] raise: Halt.
	self assert: self result = 0.
	blkWrapperInvoked := false.
	bptWrapper := self wrapperClass on: #methodWithArgument: inClass: MwClassA.
	blkWrapper := MwBlockMethodWrapper on: #methodWithArgument: inClass: MwClassA.
	blkWrapper beforeBlock: [:rcvr :args| blkWrapperInvoked := true].
	bptWrapper install.
	blkWrapper install.
	self should: [self result: (instance methodWithArgument: 1)] raise: Halt.
	self assert: instance x = 0. "method should not have meen evaluated because we stopped execution at the Halt."
	self assert: blkWrapperInvoked. "but tracing wrapper should have run"
	instance x: 0.
	blkWrapperInvoked := false.
	"now proceed through the halt and check that
		- the breakpoint is above the unwrapped method (not the block wrapper method)
		- the unwrapped method is run"
	[self result: (instance methodWithArgument: 1)]
		on: Halt
		do: [:ex|
			signallerSenderMethod := ex signalerContext sender method.
			ex resume].
	self assert: signallerSenderMethod == bptWrapper unwrappedMethod.
	blkWrapper uninstall.
	bptWrapper uninstall.
	self assert: self result = 1. "method should have been run precisely once."
	self assert: blkWrapperInvoked. "and tracing wrapper should have run"
]

{ #category : #tests }
MwBreakpointMethodWrapperTest >> testNonQuickMethodBreakpoints [

	| wrapper instance |
	instance := MwClassA new.
	self shouldnt: [self result: instance methodWithoutException] raise: Halt.
	self assert: self result = 69.
	wrapper := self wrapperClass on: #methodWithoutException inClass: MwClassA.
	wrapper install.
	self assert: wrapper clientMethod isQuick not.
	self result: nil.
	self should: [self result: instance methodWithoutException] raise: Halt.
	self assert: self result isNil.
	[self result: instance methodWithoutException]
		on: Halt
		do: [:ex| ex resume].
	wrapper uninstall.
	self assert: self result = 69
]

{ #category : #tests }
MwBreakpointMethodWrapperTest >> testQuickMethodBreakpoints [

	| wrapper instance |
	instance := MwClassA new.
	instance x: 0.
	self shouldnt: [self result: instance x] raise: Halt.
	self assert: self result = 0.
	wrapper := self wrapperClass on: #x inClass: MwClassA.
	wrapper install.
	self assert: wrapper clientMethod isQuick.
	self should: [self result: instance x] raise: Halt.
	[instance x: 42.
	 self result: instance x]
		on: Halt
		do: [:ex| ex resume].
	wrapper uninstall.
	self assert: self result = 42
]

{ #category : #tests }
MwBreakpointMethodWrapperTest >> testTracepointsAndBreakpoints [
	"Test that breakpoints play well with others
		- the wrapped method is run only once
		- the other wrapper action occurs
		- the breakpoint is above the right method."
	| instance bptWrapper blkWrapper blkWrapperInvoked signallerSenderMethod |
	instance := MwClassA new.
	instance x: 0.
	self shouldnt: [self result: instance x] raise: Halt.
	self assert: self result = 0.
	blkWrapperInvoked := false.
	bptWrapper := self wrapperClass on: #methodWithArgument: inClass: MwClassA.
	blkWrapper := MwBlockMethodWrapper on: #methodWithArgument: inClass: MwClassA.
	blkWrapper beforeBlock: [:rcvr :args| blkWrapperInvoked := true].
	blkWrapper install.
	bptWrapper install.
	self should: [self result: (instance methodWithArgument: 1)] raise: Halt.
	self assert: instance x = 0. "method should not have meen evaluated because we stopped execution at the Halt."
	self assert: blkWrapperInvoked not. "but tracing wrapper should not have run"
	instance x: 0.
	blkWrapperInvoked := false.
	"now proceed through the halt and check that
		- the breakpoint is above the unwrapped method (not the block wrapper method)
		- the unwrapped method is run"
	[self result: (instance methodWithArgument: 1)]
		on: Halt
		do: [:ex|
			signallerSenderMethod := ex signalerContext sender method.
			ex resume].
	self assert: signallerSenderMethod == bptWrapper unwrappedMethod.
	blkWrapper uninstall.
	bptWrapper uninstall.
	self assert: self result = 1. "method should have been run precisely once."
	self assert: blkWrapperInvoked. "and tracing wrapper should have run"
]

{ #category : #private }
MwBreakpointMethodWrapperTest >> wrapperClass [
	^MwMethodBreakpointWrapper
]
