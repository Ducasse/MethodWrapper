Class {
	#name : #MwTestCase,
	#superclass : #TestCase,
	#instVars : [
		'result'
	],
	#category : #'MethodWrappers42-Tests'
}

{ #category : #accessing }
MwTestCase >> result [
	"^ <Integer>"

	^ result
]

{ #category : #accessing }
MwTestCase >> result: anInteger [

	result := anInteger.
]
