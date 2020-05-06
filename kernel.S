//(a & b)>> + c!
.syntax unified
.cpu cortex-m4
.thumb

#define A #7
#define B #4
#define C #2

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data:  .asciz "kernel started!\n"
    final: .asciz "Value in register #3: "
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line
    bl func

    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num

    end:
    b end

func:
    push {r0, r1, lr}
    mov r0, A      //a
    mov r1, B     //b
    and r0, r1
    lsr r12, r0, #1  //r1=(a&b)>>
    mov r0, C      //c
    bl factorial     //r0=r0!
    add r3, r12, r0 
    pop {r0, r1, pc}

factorial:
    push {r0, lr}
    cmp r0, #1
    bgt else
    mov r0, #1
    mov pc, lr
     else:
         sub r0, #1
        bl factorial
        pop {r1, lr}
        mul r0, r1
        mov pc, lr
