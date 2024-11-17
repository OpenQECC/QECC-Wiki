# Toric

## Description
 - Toric codes, a generalization of the topological surface codes where the X and Z checks depends opon the spatial location of the qubits.
 - In a grid with qubits at every midpoint between vertices, X checks are done between the 4 qubits neighboring a vertex, and Z checks are done between the 4 qubits around a grid square.

## Example
- Number of qubits: N = 32
- Number of encoded bits: k = 2
- The Toric code is not degenerate.

<details><summary><h3>Code Tableau</h3></summary>

```
+ X___X___________X__X____________
+ _X___X__________XX______________
+ __X___X__________XX_____________
+ ___X___X__________XX____________
+ ____X___X___________X__X________
+ _____X___X__________XX__________
+ ______X___X__________XX_________
+ _______X___X__________XX________
+ ________X___X___________X__X____
+ _________X___X__________XX______
+ __________X___X__________XX_____
+ ___________X___X__________XX____
+ X___________X_______________X__X
+ _X___________X______________XX__
+ __X___________X______________XX_
+ ZZ______________Z___________Z___
+ _ZZ______________Z___________Z__
+ __ZZ______________Z___________Z_
+ Z__Z_______________Z___________Z
+ ____ZZ__________Z___Z___________
+ _____ZZ__________Z___Z__________
+ ______ZZ__________Z___Z_________
+ ____Z__Z___________Z___Z________
+ ________ZZ__________Z___Z_______
+ _________ZZ__________Z___Z______
+ __________ZZ__________Z___Z_____
+ ________Z__Z___________Z___Z____
+ ____________ZZ__________Z___Z___
+ _____________ZZ__________Z___Z__
+ ______________ZZ__________Z___Z_
```
</details>


## Benchmarking Results

This code was tested with the following decoders:

### TableDecoder and NaiveSyndromeECCSetup

![Toric TableDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Toric-TableDecoder-NaiveSyndromeECCSetup.png)

### BeliefPropDecoder and NaiveSyndromeECCSetup

![Toric BeliefPropDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Toric-BeliefPropDecoder-NaiveSyndromeECCSetup.png)

### PyMatchingDecoder and NaiveSyndromeECCSetup

![Toric PyMatchingDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Toric-PyMatchingDecoder-NaiveSyndromeECCSetup.png)

### BitFlipDecoder and NaiveSyndromeECCSetup

![Toric BitFlipDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Toric-BitFlipDecoder-NaiveSyndromeECCSetup.png)

### PyBeliefPropDecoder and NaiveSyndromeECCSetup

![Toric PyBeliefPropDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Toric-PyBeliefPropDecoder-NaiveSyndromeECCSetup.png)

## QASM Downloads
[QASM Toric Naive Encoding Circuit](QASMDownloads\Toric-naive_encoding_circuit.qasm)

[QASM Toric Naive Syndrome Circuit](QASMDownloads\Toric-naive_syndrome_circuit.qasm)

## Similar Codes 
- **[Shor-9](https://math.mit.edu/~shor/papers/good-codes.pdf)**: Degenerate CSS code designed to account for parity errors
- **[Surface Code](https://www.nature.com/articles/s41586-022-05434-1)**: This is a surface code hehe

## References
A. Y. Kitaev, Quantum computations: algorithms and error correction, Russian Mathematical Surveys 52, 1191 (1997), [Link](https://www.mathnet.ru/php/archive.phtml?wshow=paper&jrnid=rm&paperid=892&option_lang=eng)