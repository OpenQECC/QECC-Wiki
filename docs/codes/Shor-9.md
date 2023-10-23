# Shor9

## Description
 - Nine-qubit CSS code that is the first quantum error-correcting code.

## Example
Code Tableau:
```
ZZ_______
_ZZ______
___ZZ____
____ZZ___
______ZZ_
_______ZZ
XXXXXX___
___XXXXXX
```

- Number of qubits: N = 9
- Number of encoded bits: k = 1
### Syndrome Circuit:
![Shor-9 Syndrome Circuit](images/codeplots/Shor-9-codeplot.png)

## Benchmarking Results
This code was tested with the following decoders:
**Lookup table:** Ran in 1.866s
![Shor-9 Truth Table PP](images\performanceplots\Shor-9-lookuptable.png)

**Belief decoder:** Ran in 42.28s

![Shor-9 Belief Decoder PP](images\performanceplots\Shor-9-beliefa.png)

##

## QASM Downloads
[Encoding Circuit](QASMDownloads\\Shor-9-encodingCircuit.qasm)

## Similar Codes
- **[sample name](sample link)**: short desc
- **[Surface Code](https://www.nature.com/articles/s41586-022-05434-1)**: This is a surface code hehe

## References
Nathanan Tantivasadakarn and Ruben Verresen and Ashvin Vishwanath, Shortest Route to Non-Abelian Topological Order on a Quantum Processor, Physical Review Letters, [DOI](https://doi.org/10.1103/PhysRevLett.131.060405)