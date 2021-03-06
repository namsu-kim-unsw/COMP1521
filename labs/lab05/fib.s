# MIPS assembler to compute Fibonacci numbers

   .data
msg1:
   .asciiz "n = "
msg2:
   .asciiz "fib(n) = "
error:
   .asciiz "n must be > 0"
eol:
   .asciiz "\n"
n:
   .word 1

   .text

# int main(void)
# {
#    int n;
#    printf("n = ");
#    scanf("%d", &n);
#    if (n >= 1)
#       printf("fib(n) = %d\n", fib(n));
#    else {
#       printf("n must be > 0\n");
#       exit(1);
#    }
#    return 0;
# }

   .globl main
main:
   # prologue                             ### Can you explain prologues / epilogue
   addi $sp, $sp, -4
   sw   $fp, ($sp)
   move $fp, $sp
   addi $sp, $sp, -4
   sw   $ra, ($sp)

   # function body
   la   $a0, msg1       # printf("n = ");
   li   $v0, 4
   syscall

   li   $v0, 5          # scanf("%d", &n);
   syscall
   
   blti $v0, 1, end


   sw   $v0, n       # n = a0
   move $a0, $v0     # a0 = v0

# check if (n >= 1)
n_gt_0:
   li   $t0, 1          # t0 = 1
   blt  $a0, $t0, else  # if (n < 1) branch to else
   j    return          # if (n >= 1) jump to return
# print error message
else:
   lw   $a0, error   # load error msg
   li   $v0, 4       # print error msg
   syscall
   li   $v0, 10      # exit program
   syscall
return:
   # jump and link to fib() function

   jal  fib             # $s0 = fib(n);
   nop
   move $s0, $v0

   la   $a0, msg2       # printf((fib(n) = ");
   li   $v0, 4
   syscall

   move $a0, $s0        # printf("%d", $s0);
   li   $v0, 1
   syscall

   li   $a0, '\n'       # printf("\n");
   li   $v0, 11
   syscall

   # epilogue
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4
   jr   $ra


# int fib(int n)
# {
#    if (n < 1)
#       return 0;
#    else if (n == 1)
#       return 1;
#    else
#       return fib(n-1) + fib(n-2);
# }

fib:
   # prologue
   addi $sp, $sp, -4 # Alloc space for int on the stack by subtracting 4-bytes for the 32-bit int from the stack pointer
   sw   $fp, ($sp)   # store int
   move $fp, $sp     
   addi $sp, $sp, -4 # Alloc space for return address $ra so f() can link back to caller
   sw   $ra, ($sp)   # store address in ra

   # function body
   move $v0, $0         # v0 = 0 (the value zero - default)

   # epilogue
   lw   $ra, ($sp)
   addi $sp, $sp, 4
   lw   $fp, ($sp)
   addi $sp, $sp, 4

   jr   $ra


