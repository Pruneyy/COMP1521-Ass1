.data
	m1:		    .asciiz	"# Iterations: "
	m2:		    .asciiz	"==="
	m3:		    .asciiz	" After iteration "
	m4:		    .asciiz	"."
	m5:		    .asciiz	"#"
	m6:		    .asciiz	"\n"
	m7:		    .asciiz	" ==="
	
	n:		    .word 1
	i:		    .word 0
	k:		    .word 0
	nn:		    .word 0
	x:		    .word -1
	y:		    .word -1


.text
.globl main
main:


	la		    $a0, m1				        # Load message 1 to a0
	li		    $v0, 4			            # Printf("m1")
	syscall
	
	li		    $v0, 5			            # Scanf("%d", &maxiters)
	syscall
	
	move        $s5, $v0                    # Move maxiters to s5
	lw		    $s0, N			            # Load N to s0
	lw		    $s1, n			            # Load n to s1
	lw		    $s2, i			            # Load i to s2
	lw		    $s3, k			            # Load k to s3
	
Loop1:	
	bgt	    	$s1, $s5, EndProgram		# If n > maxiters, jump to e1
	lw	    	$s2, i			            # reset i to 0
	j	    	Loop2			            # Jump to Loop 2
	
Loop2:
	bge	    	$s2, $s0, EndLoop2	        # If i >= N, jump to E2
	lw	    	$s3, k			            # reset k to 0
	j	    	Loop3			            # Jump to Loop 3
	
Loop3:
	bge	    	$s3, $s0, Loop2Reset	    # If k >= N, jump to L2
	add	    	$a1, $zero, $s2		        # a1 = i + 0
	add	    	$a2, $zero, $s3		        # a2 = k + 0
	jal	    	neighbours		            # Jump and link to neighbours()
	    #move        $s6, $a0
	    #li          $v0, 1
	    #syscall
    li          $v0, 1
    syscall	
	move    	$s4, $a0                    # move a0 (should be nn from neighbours output) to s4

	mul     	$t0, $s2, $s0               # t0 = i * N
	add     	$t0, $t0, $s3               # t0 = t0 + k
	lb      	$t1, board($t0)             # t1 = value of board at location t0 (offset)
	
        move        $a0, $t1
        li          $v0, 1
        syscall

    li          $t4, 1
	bne     	$t1, $t4, If1               # branch to If1 if value of board at t0 == 0
	li      	$t2, 2                      # set t2 = 2
	li   		$t3, 3                      # set t3 = 3
	li      	$t4, 1                      # set t4 = 1

	beq     	$t2, $s4, If2	            # If nn == 2, jump to If2
	beq     	$t3, $s4, If2	            # If nn == 3, jump to If2
	j       	If3	                        # else jump to If3
If2:
    li          $t4, 1                      # Set t4 to = 1
    sb      	$t4, newBoard($t0)          # Set newBoard($t0) to 1
        li          $a0, 'b'
        li          $v0, 11
        syscall
    j       	Loop3Reset	                # Jump to Loop3Reset
If3:
	sb      	$zero, newBoard($t0)        # Set newBoard($t0) to 0
	    li          $a0, 'c'
        li          $v0, 11
        syscall
	j       	Loop3Reset        	        # Jump to Loop3Reset
	


If1:
    li          $t3, 3
    beq     	$t3, $s4, If4               # If nn == 3, jump to If4
    sb      	$zero, newBoard($t0)        # Set newBoard($t0) to 0
        li          $a0, 'a'
        li          $v0, 11
        syscall
    j       	Loop3Reset              	# Jump to Loop3Reset
    
   
If4:
    li          $t4, 1                      # Set t4 to = 1
    sb      	$t4, newBoard($t0)          # Set newBoard($t0) to 1
        li          $a0, 'd'
        li          $v0, 11
        syscall
    j       	Loop3Reset		            # Jump to Loop3Reset
    	
Loop2Reset:
	addi		$s2, $s2, 1		            # i = i + 1
	        la	    	$a0, m6		                # Load message 1 to a0
	        li	    	$v0, 4		                # Printf("\n")
	        syscall
	j   		Loop2				        # Jump to Loop 2  
Loop3Reset:
    addi		$s3, $s3, 1		            # k = k + 1
        li          $a0, ' '
        li          $v0, 11
        syscall        
    j       	Loop3                       # Jump to Loop3  
    	  
EndLoop2:	
	la	    	$a0, m2			            # Load message 1 to a0
	li	    	$v0, 4			            # Printf("===")
	syscall
	
	la	       	$a0, m3			            # Load message 1 to a0
	li	    	$v0, 4			            # Printf(" After Iteration ")
	syscall
	
    move    	$a0, $s1                    # printf("%d", $s1)
    li      	$v0, 1
    syscall
	
	la	    	$a0, m7		                # Load message 1 to a0
	li	    	$v0, 4		                # Printf("===")
	syscall	      	

	la	    	$a0, m6		                # Load message 1 to a0
	li	    	$v0, 4		                # Printf("\n")
	syscall
	
	jal         copyBackandShow             # Jump and Link to copyBackandShow
	
	addi		$s1, $s1, 1		            # n = n + 1
	j       	Loop1                       # Jump to Loop1
		
EndProgram:
   	li  		$v0, 10				        # End Program
   	syscall
   				
#######################
# Neighbours Function #
######################

neighbours:
    add         $sp,$sp,-20                 # save in stack
    sw          $ra,0($sp)
    sw          $s2,4($sp)
    sw          $s3,8($sp)
    sw          $s4,12($sp)
    sw          $s0,16($sp)

	move    	$s2, $a1		            # Move a1 to s2 (s2 = i)
	move	   	$s3, $a2		            # Move a2 to s3 (s3 = k)
	lw	    	$s4, nn			            # Load nn into s4
	lw	    	$t0, x		                # Load x = -1 into t0
	lw          $s0, N                      # Load N into s0
	addi		$t2, $zero, 1           	# Set t2 to equal 1
	j	    	Loop4			            # Jump to Loop 4
	
Loop4:
	bgt	    	$t0, $t2, EndNeighbours     # If x > 1, jump to E2
	lw	    	$t1, y			            # reset y to -1
	j 	    	Loop5			            # Jump to Loop 5
	
Loop5:
	bgt 		$t1, $t2, Loop4Reset        # If y > 1, jump to Loop 4
	add	    	$t3, $s2, $t0		        # t3 = i + x
	add	    	$t4, $s3, $t1		        # t4 = k + y
	addi		$t5, $s0, -1			    # t5 = N - 1
	
	blt		    $t3, $zero, Loop5Reset		# If (i + x) < 0 go to Loop5Reset
	bgt		    $t3, $t5, Loop5Reset		# If (i + x) > (N - 1) go to Loop5Reset
	blt		    $t4, $zero, Loop5Reset		# If (k + y) < 0 go to Loop5Reset
	bgt		    $t4, $t5, Loop5Reset		# If (k + y) > (N - 1) go to Loop5Reset
	beq		    $t0, $zero, YCheck		    # If x == 0, go to YCheck
	beq		    $t1, $zero, XCheck		    # If y == 0, go to XCheck
    j	        FinalIf                     # If x != 0, go to FinalIf

YCheck:
    beq		    $t1, $zero, Loop5Reset	    # If y == 0, go to Loop5Reset
    j           FinalIf                     # If y != 0, go to FinalIf
XCheck:
    beq		    $t0, $zero, Loop5Reset	    # If x == 0, go to Loop5Reset
    j           FinalIf                     # If x != 0, go to FinalIf    
    	
FinalIf:
	mul     	$t6, $t3, $s0               # t6 = (i + x) * N
	add     	$t6, $t6, $t4               # t6 = t6 + (k + y)
	lb      	$t7, board($t6)             # t7 = value of board at location t6 (offset)
	bne		    $t7, $zero, Incrementnn		# If board[i+x][k+y] != 0, go to incrementnn
	j           Loop5Reset                  # Jump to Loop5Reset
	
Incrementnn:
	addi		$s4, $s4, 1			        # nn = nn + 1
	j		    Loop5Reset			        # Jump to Loop5Reset
	
Loop4Reset:
	addi		$t0, $t0, 1		            # x = x + 1
	j           Loop4                       # Jump back to Loop 4    			
	
Loop5Reset:
	addi		$t1, $t1, 1		            # y = y + 1
	j	    	Loop5			            # Jump back to Loop 5

EndNeighbours:
		
	move		$a0, $s4			        # Move nn from s4 to a0
	
	#la	    	$a0, m6		                # Load message 1 to a0
	#li	    	$v0, 4		                # Printf("\n")
	#syscall
	
	lw          $ra,0($sp)       
    lw          $s2,4($sp)
    lw          $s3,8($sp)
    lw          $s4,12($sp)
    lw          $s0,16($sp)
    add         $sp,$sp,20       

	jr	    	$ra				            # Return to main

############################
# copyBackandShow Function #
###########################		

copyBackandShow:
	
	li	    	$t0, 0			            # t0 = i
	li	    	$t1, 0			            # t1 = k
	lw	    	$t2, N			            # t2 = N
	
Loop6:
	bge	    	$t0, $t2, EndShow	        # Branch to E3 if i >= N
	lw	    	$t1, k			            # reset k to 0
	j	    	Loop7			            # Jump to Loop 7
	
Loop7:
	bge	    	$t1, $t2, EndLoop6	        # Branch to Loop 6 if k >= N
	
	mul     	$t3, $t0, $t2               # t3 = i * N
	add     	$t3, $t3, $t1               # t3 = t3 + k
	lb      	$t4, newBoard($t3)             # t4 = value of board at location t3 (offset)
	sb  		$t4, board($t3)		    # Board at offset = newBoard at offset
	bne	    	$t4, $zero, hash	        # If Board at offset !=0, go to hash
	
	la	    	$a0, m4		                # Load message 4 to a0
	li	    	$v0, 4		                # Printf(".")
	syscall
	
	j	    	EndLoop7			        # Jump to EndLoop7

hash:
	la	    	$a0, m5		                # Load message 5 to a0
	li	    	$v0, 4		                # Printf("#")
	syscall
	
	j	    	EndLoop7			        # Jump to EndLoop7	
	
EndLoop6:
	la	    	$a0, m6		                # Load message 1 to a0
	li	    	$v0, 4		                # Printf("\n")
	syscall	
	
	addi		$t0, $t0, 1			        # i = i + 1
	j		    Loop6				        # Jump to Loop6
		
EndLoop7:
	addi		$t1, $t1, 1		            # k = k + 1
	j	    	Loop7			            # Jump back to L7
	
EndShow:
	jr	    	$ra
