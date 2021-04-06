.data
.balign 4
inputFile: .asciz "/afs/ee.cooper.edu/user/g/gary.kim/tmp/git/Project2/input.txt"

.balign 4
readMode: .asciz "r"

.balign 4
templateString: .string "%d\n"

.balign 4
integer: .word 1

.balign 4
treeRoot: .word 1

.balign 4
debugging: .asciz "Debugging!\n"

.balign 4
filePointer: .word 1

// Struct format for treeNode
// byte 0-7: integer
// byte 8-15: left
// byte 16-23: right

.text

.global fopen
.global main
.global malloc

main:
    ldr r0, =inputFile
    ldr r1, =readMode
    bl fopen

    // Store file pointer
    ldr r5, =filePointer
    str r0, [r5]

    // Read a number from the file
    ldr r1, =templateString
    ldr r2, =integer
    bl fscanf

    // create treeRoot
    mov r6, r1
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
    mov r0, r5

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

    ldr r1, =integer
    ldr r1, [r1]
    ldr r0, =templateString
    bl printf
end1:

    ldr r0, =treeRoot
    bl printNode

    // Load in the return code
    mov r0, #0
    // From https://azeria-labs.com/writing-arm-shellcode/
    // Exit
    mov r7, #1
    swi 0

// store function
// r0: pointer to start of node
// r1: integer
// return: pointer to new node
// TODO: Use stack pointer for this function to make sure that LR is not overwritten when recursing
store:
    // Store original r0 value
    mov r5, r0

    push {r0-r8, lr}
        ldr r0, =templateString
        bl printf
        pop {r0-r8, lr}

    // Load integer value
    ldr r0, [r0]
    cmp r0, r1
    mov r0, r5
    addlt r0, r0, #8
    addge r0, r0, #16
    ldr r4, [r0]
    cmp r4, #0
    beq storeContinue
    push {lr}
    bl store
    pop {lr}
    bx lr

storeContinue:
    mov r8, r0
    mov r6, r1
    mov r0, #24
    bl malloc
    str r0, [r8]
    mov r5, r0
    str r6, [r0]
    add r0, r0, #8
    mov r7, #0
    str r7, [r0]
    add r0, r0, #8
    str r7, [r0]
    bx lr

// printNode Function
// r0: treeNode
printNode:
    mov r5, r0
    // Check if left is NULL
    add r0, r0, #8
    ldr r0, [r0]
    cmp r0, #0
    mov r0, r5
    blne printNode

    // Print the value itself
    ldr r1, [r0]
    ldr r0, =templateString
    bl printf
    mov r0, r5

    // Check if right is NULL
    add r0, r0, #16
    ldr r0, [r0]
    cmp r0, #0
    mov r0, r5
    blne printNode

    bx lr

