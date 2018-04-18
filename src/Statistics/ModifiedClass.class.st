Class {
	#name : #ModifiedClass,
	#superclass : #Object,
	#instVars : [
		'added',
		'packageName',
		'className',
		'removed',
		'type'
	],
	#category : #Statistics
}

{ #category : #accessing }
ModifiedClass >> difference [
	^ added - removed
]

{ #category : #parsing }
ModifiedClass >> handleRename: aString [ 
	| matcher |
	matcher := RxMatcher forString: '{(.*) => (.*)}'.
	(matcher matches: aString) ifFalse: [ ^ aString ].
	^ matcher subexpression: 2
]

{ #category : #accessing }
ModifiedClass >> packageName [
	^ packageName
]

{ #category : #parsing }
ModifiedClass >> parseClassName: aString [ 
	| matcher |
	matcher := RxMatcher forString: '(.*)\.(.*)\.st'.
	(matcher matches: aString) ifFalse: [ self error ].
	
	className := (matcher subexpression: 2) asSymbol.
	type := matcher subexpression: 3.
	
]

{ #category : #parsing }
ModifiedClass >> parseLine: aLine [
	| matcher |
	matcher := RxMatcher forString: '(\d+)\t(\d+)\tsrc/(.*)/(.*)'.
	(matcher matches: aLine) ifFalse: [ self error ].
		
	added := (matcher subexpression: 2) asInteger.
	removed := (matcher subexpression: 3) asInteger.
	packageName  := (self handleRename: (matcher subexpression: 4)) asSymbol.
	self parseClassName: (self handleRename: (matcher subexpression: 5)).
	
	^ self
]

{ #category : #printing }
ModifiedClass >> printOn: anStream [
	anStream nextPutAll: self class name;
	nextPut: $(;
	nextPutAll: packageName;
	space;
	nextPutAll: className;
	space;	
	nextPutAll: (added - removed) asString;
	nextPut: $).
	
]
