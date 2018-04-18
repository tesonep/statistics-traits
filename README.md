# statistics-traits

This repository contains the code to calculate statistics over the new Traits implementation in Pharo 7. 
Comparing the size of the code and how the code modularization improved the general structure of Pharo.

To run the statistics, in a Pharo 7 Playground print:

```Smalltalk
stats := Statistics new.

stats 
	location: '/path/to/git/repo/of/pharo' asFileReference;
	statistics.
```

Remember changing _/path/to/git/repo/of/pharo_ to the path of a clon of Pharo repo (https://github.com/pharo-project/pharo).


The result will be exaclty, as the calculation is based in the previous and the commit integrating the new implementation.

```text
Old Version
===========

All Image:
Lines: 824745
Classes: 6339
Methods: 91753

Kernel:
Lines: 147248
Classes: 694
Methods: 13937


New Version
===========

All Image:
Lines: 824745
Classes: 6339
Methods: 91753

Kernel:
Lines: 147248
Classes: 694
Methods: 13937


Difference
==========

Full Image: 
Reduced Lines: 5704
Reduced Classes: -23
Reduced Methods: 614

Kernel: 
Reduced Lines: 22606
Reduced Classes: 107
Reduced Methods: 2897
```
