nop
# initial
ori $s1,$s1,0x12
ori $s7,$s1,0       # ori test(weak)
ori $s2,$s2,0x34
ori $s3,$s3,0x1234
ori $s4,$s4,0xffff
lui $s5,0x1a2b
lui $s6,0xffff
sw $s5,20($0)
sw $s3,12($0)
# end of initial

# jal for/back code
jal jal1_forward
nop
jal1_backward:
    # test hazard_add
    sub $t2,$s6,$s5
    add $t1,$s1,$s2
    add $t0,$t1,$t2 # $t1 hazard

    sub $t2,$s6,$s5
    add $t1,$s1,$s2
    add $t0,$t2,$t1 # $t2 hazard

    lw $t1,20($0)
    add $t0,$t1,$t1 # double hazard

    lui $t2,0x0123 # other instrctions
    add $t0,$t1,$t2

    ori $t2,0x0123 # other instrctions
    add $t0,$t2,$t1

    add $t0,$s2,$s2
    add $t8,$t0,$t0 # self test

jal jal1_end
jal1_forward:
    add $t0,$31,$s5 # $31 test with delay branch

    # test hazard_sub
    sub $t2,$s6,$s5
    add $t1,$s1,$s2
    sub $t0,$t2,$t1 # $rs hazard

    sub $t1,$s2,$s1
    add $t2,$s5,$s5
    sub $t0,$t1,$t2 # $rt hazard

    lw $t1,20($0)
    sub $t0,$t1,$t1 # double hazard

    lui $t2,0x0123 # other instrctions
    sub $t0,$s6,$t2

    ori $t2,0x0123 # other instrctions
    sub $t0,$t2,$s1

    add $t0,$s2,$s2
    sub $t8,$t0,$t0 # self test

jal jal1_backward
nop
jal1_end:
    add $t0,$31,$s5 # $31 test without delay branch

    # test hazard_ori
    add $t1,$s1,$s2
    ori $t0,$t1,0xffff # $t1 hazard

    lw $t1,20($0)
    ori $t0,$t1,0x0f0f # single hazard lw

    lui $t2,0x0123 # other instrctions
    ori $t0,$t1,0x4321

    ori $t2,0x0123 # other instrctions
    ori $t0,$t2,0x1234

    ori $t0,$s2,0x0345
    ori $t8,$t0,0x1234 # self test

# end of jal for/back

# jal func
ori $31,$0,0x3000 # if loop, then fail
jal func_a
nop
add $t1,$t1,$t1
sub $t1,$t1,$t1 # set 0
lui $t1,0x0
ori $t1,0x1
add $t1,$t1,$t1
add $t1,$t1,$t1
add $t1,$t1,$t1
add $t1,$t1,$t1

jal func_b
nop
jal func_beq
add $ra,$0,$ra # test $ra and add
add $t0,$t0,$t0
jal func_edge
add $t0,$t0,$t0

# **********to end************
jal end
# **********to end************

# func_a
func_a:
    nop
    ori $t6,$t6,0x4
    add $ra,$ra,$t6 # test jr hazard
jr $ra
add $t0,$s1,$s5

func_b:
    # lw,sw test
    lw $t0,20($0)
    sw $t0,32($0) # no stall

    add $t0,$s1,$s5
    sw $t0,32($0) # no stall either

    add $t0,$s1,$s7
    sw $t0,0($t0) # need a stall
    add $t8,$t0,$t0

    add $t0,$s1,$s7
    lw $t1,0($t0) # need a stall

    add $t0,$s1,$s7
    lw $t0,0($t0) # need a stall and same reg w/r

    sw $ra,3332($0) # test jr hazard
    lw $ra,3332($0)
jr $ra
add $t0,$s1,$s4

func_beq:
    # mostly no jump beq, but some like jal
    add $t0,$s1,$s1
    add $t1,$s2,$t0
    beq $t0,$t1,fail # hazard_complex

    lui $t0,0
    lw $t1,20($t0)
    beq $t0,$t1,fail # stall 2

    beq $0,$0,success1
    success1:

    add $t1,$t1,$t1
    ori $t1,0
    ori $t1,0x68
    beq $t0,$t1,success2
    nop
    add $t0,$s3,$s3 # does not execute
    success2:

ori $ra,$ra,0 # test jr (?)
jr $ra
nop

func_edge:
    lw $t0,12284($0)
    sw $t0,12284($0)

    sub $t1,$t1,$t1 # set 0
    lui $t1,0x7fff
    ori $t1,0xfffe

    sub $t2,$t2,$t2 # set 0
    ori $t2,0x1

    add $t0,$t1,$t2 # max
    sub $t3,$t2,$t0 # min + 1
jr $ra
nop

fail:
end: