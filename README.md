# Computer Architecture ECE251 Project 2
## Purpose / Goal
- Read file that contains a list of numbers (One number per line - limited to 32 bits; Line terminated by '\n'
- Create another file that has the numbers in ascending order

## Help
Usage: Sort linefeed delimited numbers in a file in ascending order then output to a file

Example: 
- input.txt output.txt 
It is also possible to replace the file with the sorted version: 
- numbers.txt numbers.txt

## Installation Method
1. Download the assembly file from GitHub using curl:
```bash
curl https://raw.githubusercontent.com/alizameller/Project2/main/jag2.s --output jag2.s
```
2. Download the Makefile from GitHub using curl: 
```bash
curl https://raw.githubusercontent.com/alizameller/Project2/main/Makefile --output Makefile
```
3. Run the Makefile in the directory downloaded: 
```bash
make
```
4. Run the exectutable generated followed by the input and output file names: 
```bash
./jag2.out input.txt output.txt
```

**If you do not include an input/output file a help message will be displayed** 

## File Format

Your input file should look something like this:

```
1248293
-23472394
2384
2347
234
1
33423
23478
-6789
-2346
23487
-2342374

```

Running `jag2.out` will then output this into the output file:

```
-23472394
-2342374
-6789
-2346
1
234
2347
2384
23478
23487
33423
1248293

```

## Design Document
The Design Document can be found [here](../main/Design%20Document%20-%20Project%20%231.pdf) 
