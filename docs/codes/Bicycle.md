# Bicycle

## Description
 - This LDPC code is based on circulant matrices of difference sets.
 - The difference should satisfy the property that each every difference (modulo N/2) in the set occurs at most once
 - This is a CSS code where each sub-matrix is constructed from the circulant and it's transpose horizontally contatinated. This sub-matrix then has some of it's rows removed while trying to keep the number of checks per column the same.

## Example
Code Tableau:
```
XX_XX_X
X__XXX_
ZZ_ZZ_Z
Z__ZZZ_
```

- Number of qubits: N = 7
- Number of encoded bits: k = 3
### Syndrome Circuit:
![Bicycle Syndrome Circuit](images\codeplots\Bicycle-codeplot.png)

## Benchmarking Results
This code was tested with the following decoders:
**Lookup table:** Ran in 0.4064s
![Bicycle Truth Table PP](images\performanceplots\Bicycle-lookuptable.png)

**Belief decoder:** Ran in 15.42s

![Bicycle Belief Decoder PP](images\performanceplots\Bicycle-beliefa.png)

##

## QASM Downloads
[Encoding Circuit](QASMDownloads\\Bicycle-encodingCircuit.qasm)

## Similar Codes
- **[Unicycle Codes](https://arxiv.org/abs/quant-ph/0304161)**: Circulant code based on perfect difference sets

## References
David J.C. MacKay, Graeme Mitchison, Paul L. McFadden, Sparse Graph Codes for Quantum Error-Correction, IEEE Transactions on Information Theory, Vol. 50, No. 10, p. 2315 (2004), [DOI](https://doi.org/10.1109/TIT.2004.834737)