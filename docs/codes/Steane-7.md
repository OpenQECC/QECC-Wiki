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
### Syndrome Circuit:
![Steane-7 Syndrome Circuit](../../src/pages/images/codeplots/Steane-7-codeplot.png)

## Benchmarking Results
This code was tested with the following decoders:
**Lookup table:** Ran in 0.3263s
![Steane-7 Truth Table PP](images\performanceplots\Steane-7-lookuptable.png)
**Belief decoder:** Ran in 7.388s
![Steane-7 Belief Decoder PP](images\performanceplots\Steane-7-beliefa.png)

## 

## ["QASM Downloads", "[QASM Encoding Circuit](QASMDownloads\\Steane-7-encodingCircuit.qasm)"]

## Similar Codes 
- **[Shor-9](https://math.mit.edu/~shor/papers/good-codes.pdf)**: Degenerate CSS code designed to account for parity errors

## References
Andrew Steane, Multiple Particle Interference and Quantum Error Correction, Proc.Roy.Soc.Lond. A452 (1996) 2551, [DOI](https://doi.org/10.1098/rspa.1996.0136)