"
Method wrappers can add ""hidden"" behavior to the ordinary method. They can change what is executed before or after the method. For example, a count method wrapper would increment a counter when the method is called, and then forward the call onto the original method.

While this class is not abstract (i.e., there are no subclassResponsibilities), these method wrappers don't do anything if you install them. Look at the subclasses for example uses.

To create a new type of method wrapper, you must create a subclass of MwMethodWrapper and redefine the #beforeMethod and/or #afterMethod as necessary. If you only need to redefine the #beforeMethod, you can redefine the #valueWithReceiver:arguments: method instead (see the count method wrapper). This will give you some added performance since it doesn't need to create two blocks and send the #ensure: message.

To use a method wrapper, send the class a #on:inClass: message. This will return a new method wrapper (or nil if this method shouldn't be wrapped). You can then install the method wrapper by sending the #install message and uninstall by sending the #uninstall message.

WARNING: Incorrectly using the wrappers can crash your image, so you should save your image before using them. Most problems occur as a result of installing them on methods that are called either in the #beforeMethod or #afterMethod.

Implementation:
	The class keeps a dictionary, called protoMethods, of method skeletons. There is one skeleton for 	each number of arguments. 
	Such skeletons are then copied and filled up with information instead of compiling a method 	
	from scratch during method wrapper installation.

Class Instance Variables:
	protoMethods		<Dictionary
								key: SmallInteger
								value: MwMethodWrapper>
"
Class {
	#name : #MwMethodWrapper,
	#superclass : #CompiledMethod,
	#type : #bytes,
	#classInstVars : [
		'protoMethods'
	],
	#category : #'MethodWrappers42-Base'
}

{ #category : #'monticello compatibility' }
MwMethodWrapper class >> asClassDefinitionOld [
	"the method was asClassDefinition but it broke"

	| mcClassDefinition |
	
	mcClassDefinition := Smalltalk at: #MCClassDefinition ifAbsent: [^self error: 'This message is implemented for Monticello compatibility, but MCClassDefinition is not installed in the image. Possible causes: MC is not installed or you are using a different version of MC' ].
	
	^mcClassDefinition
		name: self name
		superclassName: self superclass name
		traitComposition: self traitComposition asString
		classTraitComposition: self class traitComposition asString
		category: self category 
		instVarNames: self instVarNames
		classVarNames: self classVarNames
		poolDictionaryNames: self poolDictionaryNames
		classInstVarNames: self class instVarNames
		type: #bytes
		comment: self organization classComment	 asString
		commentStamp: self organization commentStamp
]

{ #category : #testing }
MwMethodWrapper class >> canWrap: aSelector inClass: aClass [
	"Test if a method can be wrapped without causing infinite recursion."

	| class method |
	(aClass includesBehavior: MwMethodWrapper) ifTrue: [^ false].
	((aClass includesBehavior: CompiledMethod)
		and: [aSelector == #valueWithReceiver:arguments:])
			ifTrue: [^ false].
	((aClass includesBehavior: BlockClosure)
		and: [#(ensure: value) includes: aSelector])
			ifTrue: [^ false].
	class := aClass whichClassIncludesSelector: aSelector.
	class isNil ifTrue: [^ false].
	method := class compiledMethodAt: aSelector ifAbsent: [nil].
	^ method notNil and: [(self primitives includes: method primitive) not]
]

{ #category : #private }
MwMethodWrapper class >> checkClassFormat [
	"Make sure the receiver has the format of a CompiledMethod.  In Pharo, as in
	CompiledMethods are special format objects, half pointers, half bytes."

	self instSpec ~= CompiledMethod instSpec ifTrue:
		[self setFormat: (self format bitOr: (CompiledMethod instSpec bitShift: 7))].
]

{ #category : #CHECKS }
MwMethodWrapper class >> checkClassFormats [
	"self checkClassFormats"

	| allFormatsOk |
	allFormatsOk := true.
	Smalltalk garbageCollect.
	^ String streamContents: [ :str | 
		self withAllSubclassesDo: [:each |
			| formatOk |
			formatOk := each instSpec = CompiledMethod instSpec.
			allFormatsOk := allFormatsOk & formatOk.
			str cr.
			str << each name << ' -> ' << formatOk printString ].
			str cr.
	 		str <<'=== ALL FORMATS OK -> ' << allFormatsOk printString].
]

{ #category : #private }
MwMethodWrapper class >> codeStringFor: numArgs [
	^ String streamContents:
		[ :s|
		numArgs = 0
			ifTrue: [s nextPutAll: 'value']
			ifFalse:
				[(1 to: numArgs)
					do: [:i| s nextPutAll: 'value: t'; print: i]
					separatedBy: [s space]].
		s	crtab;
			nextPut: $^;
			print: self methodWrapperSymbol;
			nextPutAll: ' valueWithReceiver: self arguments: {'.
		(1 to: numArgs)
			do: [:i| s nextPut: $t; print: i]
			separatedBy: [s nextPut: $.; space].
		s nextPut: $}]
			
	"(0 to: 2) collect: [:na| self codeStringFor: na]"
]

{ #category : #CHECKS }
MwMethodWrapper class >> countAllInstances [
	"doIt: [self countAllInstances]"

	| totalCount |
	totalCount := 0.
	Smalltalk garbageCollect.
	Transcript cr.
	self withAllSubclassesDo: [:each |
		| count |
		count := each allInstances size.
		totalCount := totalCount + count.
		Transcript cr; show: each name, ' -> ', count printString].
	Transcript cr; show: '=== TOTAL COUNT -> ', totalCount printString.
]

{ #category : #private }
MwMethodWrapper class >> createMethodFor: numArgs [
	self checkClassFormat.
	^ OpalCompiler new
		source: (self codeStringFor: numArgs);
		class: self;
		requestor: nil;
		failBlock: [  ];
		parse
	"generate: CompiledMethodTrailer empty
		using: self"
]

{ #category : #'class initialization' }
MwMethodWrapper class >> initialize [
	"doIt: [self initialize]"
	self protoMethods: Dictionary new
]

{ #category : #'class initialization' }
MwMethodWrapper class >> initializeWithAllSubclasses [
	"doIt: [self initializeWithAllSubclasses]"

	self withAllSubclassesDo: [:each | each initialize].
]

{ #category : #private }
MwMethodWrapper class >> methodPropertiesClass [

	^MwMethodWrapperInstVars
]

{ #category : #private }
MwMethodWrapper class >> methodWrapperSymbol [

	^ #'The method wrapper should be inserted in this position!'
]

{ #category : #private }
MwMethodWrapper class >> nuke [
	"doIt: [self nuke]"
	"doIt: [self withAllSubclassesDo: [:mwc| mwc nuke]]"

	self
		uninstallAllWrappers;
		initialize
]

{ #category : #'instance creation' }
MwMethodWrapper class >> on: aSymbol inClass: aClass [

	| wrapper |
	self flag: #rhi. "How about signaling an exception instead of returning nil?"
	(self canWrap: aSymbol inClass: aClass) ifFalse: [^ nil].
	wrapper := (self protoMethods
						at: aSymbol numArgs
						ifAbsentPut: [self createMethodFor: aSymbol numArgs])
					copyWithTrailerBytes: CompiledMethodTrailer empty.
	self assert: wrapper ~~ (self protoMethods at: aSymbol numArgs).
	self assert: wrapper properties ~~ (self protoMethods at: aSymbol numArgs) properties.
	wrapper class: aClass selector: aSymbol.
	self assert: (wrapper realObjectAt: wrapper methodPosition) == wrapper.
	^ wrapper
]

{ #category : #private }
MwMethodWrapper class >> primitives [

	^ #(
		61		"at:put:"
		71		"new:"
		81		"value"
	)
]

{ #category : #accessing }
MwMethodWrapper class >> protoMethods [
	"^<Dictionary key: SmallInteger value: MwMethodWrapper>"

	^protoMethods ifNil: [protoMethods := Dictionary new]
]

{ #category : #accessing }
MwMethodWrapper class >> protoMethods: aDictionary [
	"protoMethods is a dictionary containing compiled methods skeletons that can be efficiently cloned."
	protoMethods := aDictionary
]

{ #category : #private }
MwMethodWrapper class >> uninstallAllWrappers [
	"self uninstallAllWrappers"

	self allSubInstancesDo: [:inst | inst uninstall]
]

{ #category : #evaluating }
MwMethodWrapper >> afterMethod [
]

{ #category : #evaluating }
MwMethodWrapper >> beforeMethod [
]

{ #category : #initialization }
MwMethodWrapper >> class: aClass selector: aSymbol [

	self
		objectAt: self methodPosition put: self;
		wrappedClass: aClass;
		clientSelector: aSymbol
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientMethod [

	^self properties clientMethod
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientMethod: aCompiledMethod [

	^self properties clientMethod: aCompiledMethod
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientSelector [

	^self properties clientSelector
]

{ #category : #'derived accessing' }
MwMethodWrapper >> clientSelector: aSymbol [

	^self properties clientSelector: aSymbol
]

{ #category : #initialization }
MwMethodWrapper >> copyWithTrailerBytes: trailer [
	| copy |
	copy := super copyWithTrailerBytes: trailer.
	copy objectAt: self methodPosition put: copy.
	^copy
]

{ #category : #'derived accessing' }
MwMethodWrapper >> definingClass [

	^self properties definingClass
]

{ #category : #'derived accessing' }
MwMethodWrapper >> definingClass: aClass [

	^self properties definingClass: aClass
]

{ #category : #installation }
MwMethodWrapper >> install [

	| holdingClass method |
	self flag: #rhi. "KLUDGE: Einwegwrapper."
	self wasActive ifTrue: [self error: 'Einwegwrapper!'].
	holdingClass := self wrappedClass whichClassIncludesSelector: self clientSelector.
	holdingClass isNil ifTrue: [^ self].
	method := holdingClass compiledMethodAt: self clientSelector.
	method == self ifTrue: [^ self].
	self
		clientMethod: method;
		setSourcePointer: method sourcePointer.
	method isMwMethodWrapper
		ifTrue: [
			method wrappingWrapper: self.
			self definingClass: method definingClass]
		ifFalse: [self definingClass: holdingClass].
	self wrappedClass addSelector: self clientSelector withMethod: self.
]

{ #category : #testing }
MwMethodWrapper >> isMwMethodWrapper [

	^ true
]

{ #category : #decompiling }
MwMethodWrapper >> methodForDecompile [
	"Answer a wrapper *without* itself in the methodPosition to avoid infinite
	 recursion in the attempt to print the literal method in wrapper position."
	^self copy
		objectAt: self methodPosition put: self class methodWrapperSymbol;
		yourself
]

{ #category : #private }
MwMethodWrapper >> methodPosition [

	^ (2 to: self numLiterals + 1) 
		detect: [:i |
			| each |
			each := self realObjectAt: i.
			each == self class methodWrapperSymbol or: [each == self]]
		ifNone: [self error: 'Cannot find position to insert wrapper']
]

{ #category : #private }
MwMethodWrapper >> objectAt: anIndex [ 
	"Lie about what's in our literal frame. This has the bad side-effect that we can't
	view the correct information in inspectors, but the good news is that we stop
	infinite recursion. Good thing the VM doesn't use the basicAt: method :)."

	| object |
	object := self realObjectAt: anIndex.
	^ object == self ifTrue: [self clientMethod] ifFalse: [object]
]

{ #category : #accessing }
MwMethodWrapper >> properties [
	"Answer the method properties of the receiver.  Override to create the properties if none already exist."
	| propertiesOrSelector |
	(propertiesOrSelector := self penultimateLiteral) isMethodProperties ifFalse:
		[propertiesOrSelector := self class methodPropertiesClass
									forMethod: self
									selector: propertiesOrSelector.
		 self penultimateLiteral: propertiesOrSelector].
	^propertiesOrSelector
]

{ #category : #private }
MwMethodWrapper >> realObjectAt: anIndex [

	^ super objectAt: anIndex
]

{ #category : #installation }
MwMethodWrapper >> uninstall [

	self flag: #rhi. "The #uninstall should actually become #destroy!"
	self clientMethod ifNil: [^ self].
	(self wrappedClass compiledMethodAt: self clientSelector ifAbsent: [nil]) == self
		ifTrue: [self wrappedClass == self definingClass
			ifTrue: [self wrappedClass
				addSelector: self clientSelector
				withMethod: self clientMethod]
			ifFalse: [self wrappedClass removeSelector: self clientSelector]].
	self clientMethod isMwMethodWrapper
		ifTrue: [self clientMethod wrappingWrapper: self wrappingWrapper].
	self wrappingWrapper
		ifNotNil: [
			self wrappingWrapper
				clientMethod: self clientMethod;
				definingClass: self definingClass.
			self wrappingWrapper: nil].
	self
		definingClass: nil;
		clientMethod: nil.
]

{ #category : #'derived accessing' }
MwMethodWrapper >> unwrappedMethod [

	^ self clientMethod ifNotNil: [self clientMethod unwrappedMethod]
]

{ #category : #evaluating }
MwMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [
	"This is the general case where you want both a before and after method, but if you
	want just a before method, you might want to override this method for optimization."

	self wasActive: true.
	self beforeMethod.
	^[self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects]
		ensure: [self afterMethod]
]

{ #category : #testing }
MwMethodWrapper >> wasActive [

	^self properties wasActive
]

{ #category : #testing }
MwMethodWrapper >> wasActive: aBoolean [

	^self properties wasActive: aBoolean
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappedClass [

	^self properties wrappedClass
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappedClass: aClass [

	^self properties wrappedClass: aClass
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappingWrapper [

	^self properties wrappingWrapper
]

{ #category : #'derived accessing' }
MwMethodWrapper >> wrappingWrapper: aMwMethodWrapper [

	^self properties wrappingWrapper: aMwMethodWrapper
]
