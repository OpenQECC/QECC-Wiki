# Steane-7

## Description
 - The Steane code is a quantum error-correcting code that encodes a single logical qubit into seven physical qubits.
 - This code is designed to correct for any single qubit error, which includes both bit-flip (analogous to classical bit errors) and phase-flip (a uniquely quantum error) errors.

## Example
Code Tableau:
___XXXX
_XX__XX
X_X_X_X
___ZZZZ
_ZZ__ZZ
Z_Z_Z_Z
- Number of qubits: N = 7
- Number of encoded bits: k = 1
- The Steane-7 code is not degenerate.
### Syndrome Circuit:
![Steane-7 Syndrome Circuit](images/codeplots/Steane-7-codeplot.png)

## Benchmarking Results

This code was tested with the following decoders:

###: table_decode and QuantumClifford.AbstractOperation[sCNOT(7,4), sCNOT(7,5), sHadamard(1), sZCX(1,4), sZCX(1,5), sZCX(1,6), sHadamard(2), sZCX(2,4), sZCX(2,6), sZCX(2,7), sHadamard(3), sZCX(3,5), sZCX(3,6), sZCX(3,7), sSWAP(7,6), sSWAP(4,3)] and QuantumClifford.AbstractOperation[sXCX(4,8), sXCX(5,8), sXCX(6,8), sXCX(7,8), sMRZ(8, 1), sXCX(2,9), sXCX(3,9), sXCX(6,9), sXCX(7,9), sMRZ(9, 2), sXCX(1,10), sXCX(3,10), sXCX(5,10), sXCX(7,10), sMRZ(10, 3), sCNOT(4,11), sCNOT(5,11), sCNOT(6,11), sCNOT(7,11), sMRZ(11, 4), sCNOT(2,12), sCNOT(3,12), sCNOT(6,12), sCNOT(7,12), sMRZ(12, 5), sCNOT(1,13), sCNOT(3,13), sCNOT(5,13), sCNOT(7,13), sMRZ(13, 6)]

![Steane-7 table_decode PP](images\performanceplots\Steane-7-table_decode.png)

###: belief_decode_X and QuantumClifford.AbstractOperation[sCNOT(7,4), sCNOT(7,5), sHadamard(1), sZCX(1,4), sZCX(1,5), sZCX(1,6), sHadamard(2), sZCX(2,4), sZCX(2,6), sZCX(2,7), sHadamard(3), sZCX(3,5), sZCX(3,6), sZCX(3,7), sSWAP(7,6), sSWAP(4,3)] and QuantumClifford.AbstractOperation[sXCX(4,8), sXCX(5,8), sXCX(6,8), sXCX(7,8), sMRZ(8, 1), sXCX(2,9), sXCX(3,9), sXCX(6,9), sXCX(7,9), sMRZ(9, 2), sXCX(1,10), sXCX(3,10), sXCX(5,10), sXCX(7,10), sMRZ(10, 3), sCNOT(4,11), sCNOT(5,11), sCNOT(6,11), sCNOT(7,11), sMRZ(11, 4), sCNOT(2,12), sCNOT(3,12), sCNOT(6,12), sCNOT(7,12), sMRZ(12, 5), sCNOT(1,13), sCNOT(3,13), sCNOT(5,13), sCNOT(7,13), sMRZ(13, 6)]

![Steane-7 belief_decode_X PP](images\performanceplots\Steane-7-belief_decode_X.png)

###: belief_decode_Z and QuantumClifford.AbstractOperation[sCNOT(7,4), sCNOT(7,5), sHadamard(1), sZCX(1,4), sZCX(1,5), sZCX(1,6), sHadamard(2), sZCX(2,4), sZCX(2,6), sZCX(2,7), sHadamard(3), sZCX(3,5), sZCX(3,6), sZCX(3,7), sSWAP(7,6), sSWAP(4,3)] and QuantumClifford.AbstractOperation[sXCX(4,8), sXCX(5,8), sXCX(6,8), sXCX(7,8), sMRZ(8, 1), sXCX(2,9), sXCX(3,9), sXCX(6,9), sXCX(7,9), sMRZ(9, 2), sXCX(1,10), sXCX(3,10), sXCX(5,10), sXCX(7,10), sMRZ(10, 3), sCNOT(4,11), sCNOT(5,11), sCNOT(6,11), sCNOT(7,11), sMRZ(11, 4), sCNOT(2,12), sCNOT(3,12), sCNOT(6,12), sCNOT(7,12), sMRZ(12, 5), sCNOT(1,13), sCNOT(3,13), sCNOT(5,13), sCNOT(7,13), sMRZ(13, 6)]

![Steane-7 belief_decode_Z PP](images\performanceplots\Steane-7-belief_decode_Z.png)

## ## QASM Downloads
[QASM Encoding Circuit](QASMDownloads\Steane-7-encodingCircuit.qasm)

## Similar Codes 
- **[Shor-9](https://math.mit.edu/~shor/papers/good-codes.pdf)**: Degenerate CSS code designed to account for parity errors

## References
Andrew Steane, Multiple Particle Interference and Quantum Error Correction, Proc.Roy.Soc.Lond. A452 (1996) 2551, [DOI](https://doi.org/10.1098/rspa.1996.0136)