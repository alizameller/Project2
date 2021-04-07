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


## Installation Method 1 (Recommended) 
1. Download the bash script using curl: 
```bash
curl https://raw.githubusercontent.com/jakekali/compArchProject1/main/runme --output runme
```
2. Change the permissions on the bash script file - runme
```bash
chmod +x runme
```
3. Run the runme bash file: 
```bash
./runme
```

## Installation Method 2
1. Download the assembly file from GitHub using curl:
```bash
curl https://raw.githubusercontent.com/jakekali/compArchProject1/main/jag.s --output jag.s
```
2. Download the Makefile from GitHub using curl: 
```bash
curl https://raw.githubusercontent.com/jakekali/compArchProject1/main/Makefile --output Makefile
```
3. Run the Makefile in the directory downloaded: (it might throw an error, but it can ignored, the file still generates)
```bash
make
```
4. Run the exectutable generated: 
```bash
./jag.out
```

## Design Document
The Design Document can be found [here](../main/Design%20Document%20-%20Project%20%231.pdf) 
