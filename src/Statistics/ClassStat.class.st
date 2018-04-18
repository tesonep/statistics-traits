Class {
	#name : #ClassStat,
	#superclass : #Object,
	#instVars : [
		'reference',
		'lines'
	],
	#category : #Statistics
}

{ #category : #accessing }
ClassStat >> lines [
	^ lines ifNil: [ lines := (reference contents lines reject: [:e | e trimBoth isEmpty ]) size ]
]

{ #category : #accessing }
ClassStat >> reference: aFileReference [ 
	reference := aFileReference 
]
