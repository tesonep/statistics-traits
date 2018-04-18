Class {
	#name : #PackageStat,
	#superclass : #Object,
	#instVars : [
		'name',
		'members',
		'srcFolder',
		'definitions'
	],
	#category : #Statistics
}

{ #category : #accessing }
PackageStat >> classes [
	^ self definitions count: [ :e | e isClassDefinition ]
]

{ #category : #accessing }
PackageStat >> definitions [
	^ definitions ifNil: [ definitions := (TonelReader on: srcFolder fileName: name) definitions ]
]

{ #category : #accessing }
PackageStat >> lines [
	^ members sumNumbers: [ :e | e lines ].
]

{ #category : #accessing }
PackageStat >> methods [
	^ self definitions count: [ :e | e isMethodDefinition ].
]

{ #category : #'as yet unclassified' }
PackageStat >> printOn: aStream [
	aStream
		nextPutAll: self class name;
		space;
		nextPutAll: name;
		space;
		nextPutAll: self lines asString
]

{ #category : #'as yet unclassified' }
PackageStat >> read: aName from: srcRoot [ 
	| references |

	name := aName.
	srcFolder := srcRoot .
	
	references := (srcFolder / aName asString) entries reject: [ :e | e basename = 'package.st' ] thenCollect: [ :e | e reference ].
	
	members := references collect: [ :e | ClassStat new reference: e; yourself ].
	
]
