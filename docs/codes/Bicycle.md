# Bicycle

## Description
 - This LDPC code is based on circulant matrices of difference sets.
 - The difference should satisfy the property that each every difference (modulo N/2) in the set occurs at most once
 - This is a CSS code where each sub-matrix is constructed from the circulant and it's transpose horizontally contatinated. This sub-matrix then has some of it's rows removed while trying to keep the number of checks per column the same.

## Example
Code Tableau:
_XX_XX__
__XX_XX_
X__X__XX
_ZZ_ZZ__
__ZZ_ZZ_
Z__Z__ZZ
- Number of qubits: N = 8
- Number of encoded bits: k = 2
- The Bicycle code is degenerate!
### Syndrome Circuit:
![Bicycle Syndrome Circuit](images/codeplots/Bicycle-codeplot.png)

## Benchmarking Results

This code was tested with the following decoders:

###: tableDecode and QuantumClifford.AbstractOperation[sCNOT(7,4), sCNOT(8,4), sCNOT(8,5), sCNOT(8,6), sHadamard(1), sZCX(1,4), sZCX(1,7), sZCX(1,8), sHadamard(2), sZCX(2,4), sZCX(2,5), sZCX(2,7), sHadamard(3), sZCX(3,4), sZCX(3,6), sZCX(3,7)] and QuantumClifford.AbstractOperation[sXCX(2,9), sXCX(3,9), sXCX(5,9), sXCX(6,9), sMRZ(9, 1), sXCX(3,10), sXCX(4,10), sXCX(6,10), sXCX(7,10), sMRZ(10, 2), sXCX(1,11), sXCX(4,11), sXCX(7,11), sXCX(8,11), sMRZ(11, 3), sCNOT(2,12), sCNOT(3,12), sCNOT(5,12), sCNOT(6,12), sMRZ(12, 4), sCNOT(3,13), sCNOT(4,13), sCNOT(6,13), sCNOT(7,13), sMRZ(13, 5), sCNOT(1,14), sCNOT(4,14), sCNOT(7,14), sCNOT(8,14), sMRZ(14, 6)]

![Bicycle tableDecode PP](images\performanceplots\Bicycle-tableDecode.png)

###: beliefDecodeX and QuantumClifford.AbstractOperation[sCNOT(7,4), sCNOT(8,4), sCNOT(8,5), sCNOT(8,6), sHadamard(1), sZCX(1,4), sZCX(1,7), sZCX(1,8), sHadamard(2), sZCX(2,4), sZCX(2,5), sZCX(2,7), sHadamard(3), sZCX(3,4), sZCX(3,6), sZCX(3,7)] and QuantumClifford.AbstractOperation[sXCX(2,9), sXCX(3,9), sXCX(5,9), sXCX(6,9), sMRZ(9, 1), sXCX(3,10), sXCX(4,10), sXCX(6,10), sXCX(7,10), sMRZ(10, 2), sXCX(1,11), sXCX(4,11), sXCX(7,11), sXCX(8,11), sMRZ(11, 3), sCNOT(2,12), sCNOT(3,12), sCNOT(5,12), sCNOT(6,12), sMRZ(12, 4), sCNOT(3,13), sCNOT(4,13), sCNOT(6,13), sCNOT(7,13), sMRZ(13, 5), sCNOT(1,14), sCNOT(4,14), sCNOT(7,14), sCNOT(8,14), sMRZ(14, 6)]

![Bicycle beliefDecodeX PP](images\performanceplots\Bicycle-beliefDecodeX.png)

###: beliefDecodeZ and QuantumClifford.AbstractOperation[sCNOT(7,4), sCNOT(8,4), sCNOT(8,5), sCNOT(8,6), sHadamard(1), sZCX(1,4), sZCX(1,7), sZCX(1,8), sHadamard(2), sZCX(2,4), sZCX(2,5), sZCX(2,7), sHadamard(3), sZCX(3,4), sZCX(3,6), sZCX(3,7)] and QuantumClifford.AbstractOperation[sXCX(2,9), sXCX(3,9), sXCX(5,9), sXCX(6,9), sMRZ(9, 1), sXCX(3,10), sXCX(4,10), sXCX(6,10), sXCX(7,10), sMRZ(10, 2), sXCX(1,11), sXCX(4,11), sXCX(7,11), sXCX(8,11), sMRZ(11, 3), sCNOT(2,12), sCNOT(3,12), sCNOT(5,12), sCNOT(6,12), sMRZ(12, 4), sCNOT(3,13), sCNOT(4,13), sCNOT(6,13), sCNOT(7,13), sMRZ(13, 5), sCNOT(1,14), sCNOT(4,14), sCNOT(7,14), sCNOT(8,14), sMRZ(14, 6)]

![Bicycle beliefDecodeZ PP](images\performanceplots\Bicycle-beliefDecodeZ.png)

## ## QASM Downloads
[QASM Encoding Circuit](QASMDownloads\Bicycle-encodingCircuit.qasm)

## Similar Codes 
- **[Unicycle Codes](https://arxiv.org/abs/quant-ph/0304161)**: Circulant code based on perfect difference sets

## References
David J.C. MacKay, Graeme Mitchison, Paul L. McFadden, Sparse Graph Codes for Quantum Error-Correction, IEEE Transactions on Information Theory, Vol. 50, No. 10, p. 2315 (2004), [DOI](https://doi.org/10.1109/TIT.2004.834737)