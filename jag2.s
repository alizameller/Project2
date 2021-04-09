.data
.balign 4
inputFile: .word 1

.balign
outputFile: .word 1

.balign
programName: .word 1

.balign 4
helpMessage: .asciz "Usage: %s INPUT_FILE OUTPUT_FILE\nSort linefeed delimited numbers in a file in ascending order then output to a file\nExample: %s input.txt output.txt\n\nIt is also possible to replace the file with the sorted version: %s numbers.txt numbers.txt\n"

.balign 4
readMode: .asciz "r"

.balign 4
writeMode: .asciz "w"

.balign 4
templateString: .string "%d\n"

.balign 4
integer: .word 1

.balign 4
treeRoot: .word 1

.balign 4
debugging: .asciz "Debugging!\n"

.balign 4
debugPrint: .asciz "Debug: %s\n"

.balign 4
newline: .asciz "\n"

.balign 4
debug1: .asciz "Comparing %i and %i\n"

.balign 4
debug2: .asciz "Just read in %i\n"

.balign 4
filePointer: .word 1

.balign 4
cannotOpenFileMessage: .asciz "Cannot open file: %s\n"

.balign 4
cannotWriteFileMessage: .asciz "Cannot open file for writing: %s\n"

.balign 4
progress1: .asciz "Reading in file\n"

.balign 4
progress2: .asciz "Writing file\n"

.balign 4
progress3: .asciz "Process complete\n"

// Struct format for treeNode
// byte 0-7: integer
// byte 8-15: left
// byte 16-23: right

.text

.global fopen
.global main
.global malloc
.global fprintf
.global fscanf
.global printf
.global fclose

main:
    cmp r0, #3 // Expected number of arguments
    // If the number of expected arugments is not entered, print help message then exit
    ldr r5, =programName
    ldr r3, [sp, #8] // argv[0]
    ldr r2, [r3]
    str r2, [r5]
    bne printHelpMessage


    // Get inputFile argument
    ldr r5, =inputFile
    add r3, r3, #4 // argv[1]
    ldr r2, [r3]
    str r2, [r5]

    
    // Get outputFile arugment
    ldr r5, =outputFile
    add r3, r3, #4 // argv[2]
    ldr r2, [r3]
    str r2, [r5]

    // fopen the file
    ldr r0, =inputFile
    ldr r0, [r0]
    ldr r1, =readMode
    bl fopen

    // Check that the file open was sucessful
    cmp r0, #0
    beq cannotOpenFile

    // Store file pointer
    ldr r5, =filePointer
    str r0, [r5]

    push {r0-r12, lr}
    ldr r0, =progress1
    bl printf
    pop {r0-r12, lr}

    // Read a number from the file
    ldr r1, =templateString
    ldr r2, =integer
    bl fscanf

    // create treeRoot
    mov r0, #24
    bl malloc
    ldr r8, =treeRoot
    str r0, [r8]
    ldr r6, =integer
    ldr r6, [r6]
    str r6, [r0]
    add r0, r0, #8 
    mov r7, #0  
    str r7, [r0]
    add r0, r0, #8
    str r7, [r0]

read1:
    // load filePointer
    ldr r0, =filePointer
    ldr r0, [r0]
    // Read a number from the file
    ldr r1, =templateString
    ldr r2, =integer
    bl fscanf

    // Check if an actual value was found
    cmp r0, #1
    bne end1

    // Add value to tree
    ldr r0, =treeRoot
    ldr r1, =integer
    ldr r1, [r1]
    bl store
    
// For debugging: 
//  ldr r1, =integer
//  ldr r1, [r1]
//  ldr r0, =templateString
//  bl printf

    b read1

end1:
    ldr r0, =filePointer
    ldr r0, [r0]
    bl fclose

    push {r0-r12, lr}
    ldr r0, =progress2
    bl printf
    pop {r0-r12, lr}

    // Open file to write to
    ldr r0, =outputFile
    ldr r0, [r0]
    ldr r1, =writeMode
    bl fopen

    // Check that the fopen was sucessful
    cmp r0, #0
    beq cannotWriteFile

    // Call printNode
    push {r0-r12, lr}
    mov r1, r0		//r0 contains file pointer at this point
    ldr r0, =treeRoot
    bl printNode
    pop {r0-r12, lr}

    // Put trailing newline
    push {r0-r12, lr}
    ldr r1, =newline
    bl fprintf
    pop {r0-r12, lr}

    bl fclose

    push {r0-r12, lr}
    ldr r0, =progress3
    bl printf
    pop {r0-r12, lr}

    // Load in the return code
    mov r0, #0
    // From https://azeria-labs.com/writing-arm-shellcode/
    // Exit
    mov r7, #1
    swi 0

// store function
// r0: pointer to root node
// r1: integer
store:
    // Store original r0 pointer location
    ldr r5, [r0]

    // Load integer value
    ldr r0, [r5]

    // Print comparison for debug use
//  push {r0-r12, lr}
//  mov r2, r1
//  mov r1, r0
//  ldr r0, =debug1
//  bl printf
//  pop {r0-r12, lr}

    // Check if the value is larger than or smaller than
    cmp r0, r1
    mov r0, r5
    addge r0, r0, #8
    addlt r0, r0, #16
    ldr r4, [r0]

    // Print comparison for debug use
//  push {r0-r12, lr}
//  mov r1, r4
//  mov r2, #0
//  ldr r0, =debug1
//  bl printf
//  pop {r0-r12, lr}

    // Check if the leaf is set by checking if it is a pointer
    cmp r4, #0
    // If the leaf is not set, create a new leaf there
    pusheq {r0, lr}
    beq storeContinue

    // If the leaf is set, recurse function
    push {r0-r12, lr}
    bl store
    pop {r0-r12, lr}

    // Return
    bx lr

storeContinue:
    // Save pointer to leaf element of the struct
    mov r8, r0
    // Save the integer value to save
    mov r6, r1

    // Call malloc to create the required memory
    mov r0, #24
    bl malloc

    // Store newly created memory location into the leaf element of the struct
    str r0, [r8]
    // Save the memory address to the newly created location
    mov r5, r0

    // Save the integer value into the new location
    str r6, [r0]

    // Set the leaves to be 0.
    mov r6, r0
    add r0, r0, #8
    mov r7, #0
    str r7, [r0]
    add r0, r6, #16
    str r7, [r0]

    // Return
    pop {r0, lr}
    bx lr

// printNode Function
// r0: pointer to treeNode
// r1: File pointer
printNode:
    // Save original treeNode pointer
    ldr r5, [r0]
    // Save file pointer
    mov r8, r1

    // Load in the pointer to the treeNode itself
    // Check if left is NULL
    add r0, r5, #8
    mov r4, r0
    ldr r0, [r0]

    cmp r0, #0
    mov r0, r4
    push {r0-r12, lr}
    blne printNode
    pop {r0-r12, lr}

    // Print the value itself
    push {r0-r12, lr}
    ldr r2, [r5]
    ldr r1, =templateString
    mov r0, r8
    mov r7, r2
    bl fprintf
    pop {r0-r12, lr}

    // Check if right is NULL
    add r0, r4, #8
    mov r4, r0
    ldr r0, [r0]

    cmp r0, #0
    mov r0, r4

    push {r0-r12, lr}
    blne printNode
    pop {r0-r12, lr}

    bx lr

printHelpMessage:

    ldr r1, =programName
    ldr r1, [r1]
    mov r2, r1
    mov r3, r1
    ldr r0, =helpMessage
    bl printf


    // Exit with exit code 0
    mov r0, #0
    mov r7, #1
    swi 0

cannotOpenFile:
    ldr r0, =cannotOpenFileMessage
    ldr r1, =inputFile
    ldr r1, [r1]
    bl printf

    mov r0, #2
    mov r7, #1
    swi 0

cannotWriteFile:
    ldr r0, =cannotWriteFileMessage
    ldr r1, =outputFile
    ldr r1, [r1]
    bl printf
    
    mov r0, #3
    mov r7, #1
    swi 0

