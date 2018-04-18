Class {
	#name : #Statistics,
	#superclass : #Object,
	#instVars : [
		'location',
		'repository',
		'oldAllPackages',
		'newAllPackages',
		'newKernelPackages',
		'oldKernelPackages'
	],
	#category : #Statistics
}

{ #category : #calculating }
Statistics >> calculateAllPackages [
	^ (self location / 'src') entries
		select: [ :e | e isDirectory ]
		thenCollect: [ :e | 
			PackageStat new
				read: e basename asSymbol from: (self location / 'src');
				yourself ]
]

{ #category : #calculating }
Statistics >> calculateKernelPackages: aCollection [
	^ aCollection
		collect: [ :each | 
			PackageStat new
				read: each from: (self location / 'src');
				yourself ]
]

{ #category : #calculating }
Statistics >> calculateNew [
	(newAllPackages isNotNil and: [ newKernelPackages isNotNil ]) ifTrue: [ ^ self ].
	
	self checkoutCommit: '6a77b6d51346d829f68c483512702dfcaa7e4a8e'.
	
	newAllPackages ifNil: [ 
		newAllPackages := self calculateAllPackages.
	].

	newKernelPackages ifNil: [ 
		newKernelPackages := self calculateKernelPackages: self newKernelPackageNames.
	].
]

{ #category : #calculating }
Statistics >> calculateOld [
	(oldAllPackages isNotNil and: [ oldKernelPackages isNotNil ]) ifTrue: [ ^ self ].
	
	self checkoutCommit: '2eb9bd2f41e7b0bd8f9f4190906910f83c178ab1'.
	
	oldAllPackages ifNil: [ 
		oldAllPackages := self calculateAllPackages.
	].

	oldKernelPackages ifNil: [ 
		oldKernelPackages := self calculateKernelPackages: self oldKernelPackageNames.
	].
]

{ #category : #utils }
Statistics >> checkoutCommit: aCommitishId [
	self repository workingCopy checkout: (IceCheckoutDoNotLoadPackages new committish: (repository lookupCommit: aCommitishId) yourself)
]

{ #category : #utils }
Statistics >> createRepository [
	LGitLibrary isInitialized
		ifFalse: [ LGitLibrary uniqueInstance initializeLibGit2 ].

	^ IceRepository registry
		detect: [ :e | e location = self location ]
		ifNone: [ (IceRepositoryCreator new
				location: self location;
				subdirectory: 'src';
				createRepository)
				register;
				yourself ]
]

{ #category : #accessing }
Statistics >> location [
	^ location
]

{ #category : #accessing }
Statistics >> location: aValue [
	location := aValue
]

{ #category : #packages }
Statistics >> newKernelPackageNames [
	^ {'FFI-Kernel' . 'FFI-Pools' . 'Announcements-Core' . 'Colors' . 'Collections-Abstract' . 'Collections-Native'.
	'Collections-Sequenceable' . 'Collections-Stack' . 'Collections-Streams' . 'Collections-Strings' . 'Collections-Support'.
	'Collections-Unordered' . 'Collections-Weak' . 'Files' . 'FileSystem-Path' . 'Hermes' . 'Kernel' . 'Kernel-BytecodeEncoders'.
	'Network-UUID' . 'Transcript-NonInteractive' . 'PharoBootstrap-Initialization' . 'RPackage-Core' . 'Random-Core'.
	'Shift-Changes' . 'Shift-ClassBuilder' . 'Shift-ClassInstaller' . 'Slot-Core' . 'System-Announcements'.
	'System-BasicCommandLineHandler' . 'System-CommandLine' . 'System-CommandLineHandler' . 'System-Finalization'.
	'System-Hashing' . 'System-Model' . 'System-Platforms' . 'System-SessionManager' . 'System-Sources' . 'System-Support'.
	'UIManager' . 'Zinc-Character-Encoding-Core' . 'InitializePackagesCommandLineHandler' . 'Multilingual-Languages'.
	'Multilingual-Encodings' . 'Multilingual-TextConversion'} collect: #asSymbol
]

{ #category : #packages }
Statistics >> oldKernelPackageNames [
	^ {'FFI-Kernel' . 'FFI-Pools' . 'AST-Core' . 'Announcements-Core' . 'Colors' . 'Collections-Abstract'.
	'Collections-Arithmetic' . 'Collections-Atomic' . 'Collections-Native' . 'Collections-Sequenceable'.
	'Collections-Stack' . 'Collections-Streams' . 'Collections-Strings' . 'Collections-Support'.
	'Collections-Unordered' . 'Collections-Weak' . 'Files' . 'FileSystem-Path'.
	'Hermes' . 'Jobs' . 'Kernel' . 'Kernel-BytecodeEncoders' . 'Network-UUID' . 'Transcript-NonInteractive'.
	'PharoBootstrap-Initialization' . 'RPackage-Core' . 'Random-Core' . 'Shift-Changes'.
	'Shift-ClassBuilder' . 'Shift-ClassInstaller' . 'Slot-Core' . 'System-Announcements'.
	'System-BasicCommandLineHandler' . 'System-CommandLine' . 'System-CommandLineHandler'.
	'System-Finalization' . 'System-Hashing' . 'System-Model' . 'System-Platforms'.
	'System-SessionManager' . 'System-Sources' . 'System-Support' . 'Traits' . 'UIManager'.
	'Zinc-Character-Encoding-Core' . 'InitializePackagesCommandLineHandler'.
	'Multilingual-Languages' . 'Multilingual-Encodings' . 'Multilingual-TextConversion'}
		collect: #asSymbol
]

{ #category : #printing }
Statistics >> printDifference: aStream [ 

	aStream 
		nextPutAll: 'Difference';
		cr;
		nextPutAll: '==========';
		cr;
		cr.

	aStream nextPutAll: 'Full Image: '; cr.

	aStream
		nextPutAll: 'Reduced Lines:';
		space;
		print: (oldAllPackages sumNumbers: [ :e | e lines ]) - (newAllPackages sumNumbers: [ :e | e lines ]);
		cr;
		nextPutAll: 'Reduced Classes:';
		space;
		print: (oldAllPackages sumNumbers: [ :e | e classes ]) - (newAllPackages sumNumbers: [ :e | e classes ]);
		cr;
		nextPutAll: 'Reduced Methods:';
		space;
		print: (oldAllPackages sumNumbers: [ :e | e methods ]) - (newAllPackages sumNumbers: [ :e | e methods ]);
		cr.
	
	aStream cr; nextPutAll: 'Kernel: '; cr.

	aStream
		nextPutAll: 'Reduced Lines:';
		space;
		print: (oldKernelPackages sumNumbers: [ :e | e lines ]) - (newKernelPackages sumNumbers: [ :e | e lines ]);
		cr;
		nextPutAll: 'Reduced Classes:';
		space;
		print: (oldKernelPackages sumNumbers: [ :e | e classes ]) - (newKernelPackages sumNumbers: [ :e | e classes ]);
		cr;
		nextPutAll: 'Reduced Methods:';
		space;
		print: (oldKernelPackages sumNumbers: [ :e | e methods ]) - (newKernelPackages sumNumbers: [ :e | e methods ]);
		cr.
]

{ #category : #printing }
Statistics >> printNewStatisticsOn: aStream [ 
	self calculateNew. 
	
	aStream 
		nextPutAll: 'New Version';
		cr;
		nextPutAll: '===========';
		cr;
		cr.
	
	aStream nextPutAll: 'All Image:'; cr.
	self printPackages: newAllPackages on: aStream.

	aStream cr;nextPutAll: 'Kernel:'; cr.	
	self printPackages: newKernelPackages on: aStream.
	
	aStream cr; cr.
	
]

{ #category : #printing }
Statistics >> printOldStatisticsOn: aStream [ 
	self calculateOld. 
	
	aStream 
		nextPutAll: 'Old Version';
		cr;
		nextPutAll: '===========';
		cr;
		cr.
	
	aStream nextPutAll: 'All Image:'; cr.
	self printPackages: oldAllPackages on: aStream.

	aStream cr;nextPutAll: 'Kernel:'; cr.	
	self printPackages: oldKernelPackages on: aStream.
	
	aStream cr; cr.
	
]

{ #category : #printing }
Statistics >> printPackages: packages on: aStream [
	aStream
		nextPutAll: 'Lines:';
		space;
		print: (packages sumNumbers: [ :e | e lines ]);
		cr;
		nextPutAll: 'Classes:';
		space;
		print: (packages sumNumbers: [ :e | e classes ]);
		cr;
		nextPutAll: 'Methods:';
		space;
		print: (packages sumNumbers: [ :e | e methods ]);
		cr.
]

{ #category : #accessing }
Statistics >> repository [
	^ repository ifNil: [ repository := self createRepository ]
]

{ #category : #'as yet unclassified' }
Statistics >> statistics [
	^ String streamContents: [ :s | 
		self 
			printOldStatisticsOn: s;	
			printNewStatisticsOn: s;
			printDifference: s.
	]
]
