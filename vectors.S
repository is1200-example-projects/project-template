.macro movi reg, val
	lui \reg, %hi(\val)
	ori \reg, \reg, %lo(\val)
.endm

.macro STUB num
	.align 4
	.section .vector_new_\num,"ax",@progbits
	.global __vector_\num
	__vector_\num:
		movi $k0, _isr_primary_install
		lw $k0, \num * 4($k0)
		jr $k0
.endm

.align 4
.global __use_isr_install
__use_isr_install:
STUB 0


.section .text
.align 4
.global _isr_primary_install
_isr_primary_install:
.word _isr_stub





# Interrupts are handled here
.align 4
.set noreorder
.global _isr_stub
_isr_stub:
	eret
	nop


# Exceptions are handled here (trap, syscall, etc)
.section .gen_handler,"ax",@progbits
.set noreorder
.ent _gen_exception
_gen_exception:
	mfc0 $k0, $14, 0
	addi $k0, $k0, 4
	mtc0 $k0, $14, 0
	eret
	nop

.end _gen_exception
