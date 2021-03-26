.data

.balign 4
inputMessage: .asciz "Enter input file name: "

.balign 4
outputMessage: .asciz "\n Enter output file name:"

.balign 4
noFileMessage: .asciz "No file exists"

.balign 4
filemode: .asciz "w"

.balign 4
formatInFile: .asciz "%s"

.balign 4
formatOutFile:.asciz  "%s"

.balign 4
inputFile: .asciz "input.txt"

.balign 4
outputFile: .asciz "output.txt"

.text
address_of_inputMessage: .word inputMessage
address_of_outputMessage: .word outputMessage
address_of_noFileMessage: .word noFileMessage
address_of_formatInFile: .word formatInFile
address_of_formatOutFile: .word formatOutFile
address_of_inputFile: .word inputFile //is it a .word?
address_of_outputFile: .word outputFile //ditto

.global printf
.global scanf
.global fopen

.global main

main:
        ldr r0, address_of_inputMessage
        bl  printf

        ldr r0, address_of_inputFile
        ldr r1, #0 //mode - read
        bl fopen
        mov r4, r0
        bl fclose

        ldr r0, address_of_outputFile
        ldr r1, #1
        bl fopen
        mov r5, r0

