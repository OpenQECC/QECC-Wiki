<script type="module" src="index.js"></script>

# Shor-9

## Description
 - Nine-qubit CSS code that is the first quantum error-correcting code.

## Example
- Number of qubits: N = 9
- Number of encoded bits: k = 1
- The Shor-9 code is degenerate!

$$
a = 
$$

<details><summary><h3>Code Tableau</h3></summary>

```
+ ZZ_______
+ _ZZ______
+ ___ZZ____
+ ____ZZ___
+ ______ZZ_
+ _______ZZ
+ XXXXXX___
+ ___XXXXXX
```
</details>


<details><summary><h3>Encoding Circuit</h3></summary>

![Shor-9 Encoding Circuit](images/codeplots/Shor-9-encoding_circuit.png)
</details>
<details><summary><h3>Syndrome Circuit</h3></summary>

![Shor-9 Syndrome Circuit](images/codeplots/Shor-9-syndrome_circuit.png)
</details>

## Benchmarking Results

This code was tested with the following decoders:

### TableDecoder and NaiveSyndromeECCSetup

![Shor-9 TableDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Shor-9-TableDecoder-NaiveSyndromeECCSetup.png)

### TableDecoder and ShorSyndromeECCSetup

![Shor-9 TableDecoder ShorSyndromeECCSetup PP](images\performanceplots\Shor-9-TableDecoder-ShorSyndromeECCSetup.png)

### BeliefPropDecoder and NaiveSyndromeECCSetup

![Shor-9 BeliefPropDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Shor-9-BeliefPropDecoder-NaiveSyndromeECCSetup.png)

### BeliefPropDecoder and ShorSyndromeECCSetup

![Shor-9 BeliefPropDecoder ShorSyndromeECCSetup PP](images\performanceplots\Shor-9-BeliefPropDecoder-ShorSyndromeECCSetup.png)

### PyMatchingDecoder and NaiveSyndromeECCSetup

![Shor-9 PyMatchingDecoder NaiveSyndromeECCSetup PP](images\performanceplots\Shor-9-PyMatchingDecoder-NaiveSyndromeECCSetup.png)

### PyMatchingDecoder and ShorSyndromeECCSetup

![Shor-9 PyMatchingDecoder ShorSyndromeECCSetup PP](images\performanceplots\Shor-9-PyMatchingDecoder-ShorSyndromeECCSetup.png)

## QASM Downloads
[QASM Shor-9 Naive Encoding Circuit](QASMDownloads\Shor-9-naive_encoding_circuit.qasm)

[QASM Shor-9 Naive Syndrome Circuit](QASMDownloads\Shor-9-naive_syndrome_circuit.qasm)

## Similar Codes 
- **[sample name](sample link)**: short desc
- **[Surface Code](https://www.nature.com/articles/s41586-022-05434-1)**: This is a surface code hehe

## References
Nathanan Tantivasadakarn and Ruben Verresen and Ashvin Vishwanath, Shortest Route to Non-Abelian Topological Order on a Quantum Processor, Physical Review Letters, [DOI](https://doi.org/10.1103/PhysRevLett.131.060405)