	.file	"test_tokenizer.aria"
	.section	.text.unlikely.,"ax",@progbits
	.globl	failsafe
	.p2align	4
	.type	failsafe,@function
failsafe:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$1, %edi
	callq	exit@PLT
.Lfunc_end0:
	.size	failsafe, .Lfunc_end0-failsafe
	.cfi_endproc

	.text
	.globl	first_word
	.p2align	4
	.type	first_word,@function
first_word:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movq	%rdi, %rbx
	leaq	.L.str(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB1_2
	movq	%rbx, %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB1_2:
	movq	%rbx, %rax
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	first_word, .Lfunc_end1-first_word
	.cfi_endproc

	.globl	rest_after
	.p2align	4
	.type	rest_after,@function
rest_after:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movq	%rdi, %rbx
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB2_1
	incq	%rax
	movabsq	$9223372036854775807, %rsi
	cmovnoq	%rax, %rsi
	movq	8(%rbx), %rdx
	movq	%rbx, %rdi
	callq	aria_string_substring_simple@PLT
	jmp	.LBB2_2
.LBB2_1:
	leaq	.L.str.4(%rip), %rax
.LBB2_2:
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	rest_after, .Lfunc_end2-rest_after
	.cfi_endproc

	.globl	assert_str_eq
	.p2align	4
	.type	assert_str_eq,@function
assert_str_eq:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	pushq	%rax
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	%rdx, %r15
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movq	g_total@GOTPCREL(%rip), %rax
	movl	(%rax), %ecx
	incl	%ecx
	movl	$2147483647, %ebp
	cmovol	%ebp, %ecx
	movl	%ecx, (%rax)
	movq	(%rdi), %rdi
	movq	8(%rbx), %rsi
	movq	(%r14), %rdx
	movq	8(%r14), %rcx
	callq	aria_string_equals@PLT
	testb	$1, %al
	je	.LBB3_3
	movq	g_pass@GOTPCREL(%rip), %rax
	movl	(%rax), %ecx
	incl	%ecx
	cmovol	%ebp, %ecx
	movl	%ecx, (%rax)
	xorl	%eax, %eax
	jmp	.LBB3_2
.LBB3_3:
	leaq	.L.str.data.5(%rip), %rdi
	callq	aria_print_cstr@PLT
	movq	(%r15), %rdi
	callq	aria_print_cstr@PLT
	leaq	.L.str.data.7(%rip), %rdi
	callq	aria_print_cstr@PLT
	movq	(%r14), %rdi
	callq	aria_print_cstr@PLT
	leaq	.L.str.data.9(%rip), %rdi
	callq	aria_print_cstr@PLT
	movq	(%rbx), %rdi
	callq	aria_print_cstr@PLT
	leaq	.L.str.data.11(%rip), %rdi
	callq	aria_println_cstr@PLT
	movl	$1, %eax
.LBB3_2:
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end3:
	.size	assert_str_eq, .Lfunc_end3-assert_str_eq
	.cfi_endproc

	.globl	test_first_word
	.p2align	4
	.type	test_first_word,@function
test_first_word:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	leaq	.L.str.data.13(%rip), %rdi
	callq	aria_println_cstr@PLT
	leaq	.L.str.16(%rip), %rbx
	leaq	.L.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB4_2
	leaq	.L.str.16(%rip), %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB4_2:
	leaq	.L.str.18(%rip), %rsi
	leaq	.L.str.20(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	leaq	.L.str.22(%rip), %rbx
	leaq	.L.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB4_4
	leaq	.L.str.22(%rip), %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB4_4:
	leaq	.L.str.24(%rip), %rsi
	leaq	.L.str.26(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	leaq	.L.str.28(%rip), %rbx
	leaq	.L.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB4_6
	leaq	.L.str.28(%rip), %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB4_6:
	leaq	.L.str.30(%rip), %rsi
	leaq	.L.str.32(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	leaq	.L.str.34(%rip), %rbx
	leaq	.L.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB4_8
	leaq	.L.str.34(%rip), %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB4_8:
	leaq	.L.str.36(%rip), %rsi
	leaq	.L.str.38(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	leaq	.L.str.40(%rip), %rbx
	leaq	.L.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB4_10
	leaq	.L.str.40(%rip), %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB4_10:
	leaq	.L.str.42(%rip), %rsi
	leaq	.L.str.44(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	leaq	.L.str.46(%rip), %rbx
	leaq	.L.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB4_12
	leaq	.L.str.46(%rip), %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB4_12:
	leaq	.L.str.48(%rip), %rsi
	leaq	.L.str.50(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	xorl	%eax, %eax
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	popq	%rbx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end4:
	.size	test_first_word, .Lfunc_end4-test_first_word
	.cfi_endproc

	.globl	test_rest_after
	.p2align	4
	.type	test_rest_after,@function
test_rest_after:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movabsq	$9223372036854775807, %r14
	leaq	.L.str.data.51(%rip), %rdi
	callq	aria_println_cstr@PLT
	leaq	.L.str.54(%rip), %rdi
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	leaq	.L.str.4(%rip), %rbx
	movq	%rbx, %rdi
	testq	%rax, %rax
	js	.LBB5_2
	incq	%rax
	cmovoq	%r14, %rax
	leaq	.L.str.54(%rip), %rdi
	movl	$2, %edx
	movq	%rax, %rsi
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rdi
.LBB5_2:
	leaq	.L.str.56(%rip), %rsi
	leaq	.L.str.58(%rip), %rdx
	callq	assert_str_eq@PLT
	leaq	.L.str.60(%rip), %rdi
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	movq	%rbx, %rdi
	testq	%rax, %rax
	js	.LBB5_4
	incq	%rax
	cmovoq	%r14, %rax
	leaq	.L.str.60(%rip), %rdi
	movl	$6, %edx
	movq	%rax, %rsi
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rdi
.LBB5_4:
	leaq	.L.str.62(%rip), %rsi
	leaq	.L.str.64(%rip), %rdx
	callq	assert_str_eq@PLT
	leaq	.L.str.66(%rip), %rdi
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	movq	%rbx, %rdi
	testq	%rax, %rax
	js	.LBB5_6
	incq	%rax
	cmovoq	%r14, %rax
	leaq	.L.str.66(%rip), %rdi
	movl	$16, %edx
	movq	%rax, %rsi
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rdi
.LBB5_6:
	leaq	.L.str.68(%rip), %rsi
	leaq	.L.str.70(%rip), %rdx
	callq	assert_str_eq@PLT
	leaq	.L.str.72(%rip), %rdi
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	movq	%rbx, %rdi
	testq	%rax, %rax
	js	.LBB5_8
	incq	%rax
	cmovoq	%r14, %rax
	leaq	.L.str.72(%rip), %rdi
	movl	$24, %edx
	movq	%rax, %rsi
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rdi
.LBB5_8:
	leaq	.L.str.74(%rip), %rsi
	leaq	.L.str.76(%rip), %rdx
	callq	assert_str_eq@PLT
	leaq	.L.str.78(%rip), %rdi
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	movq	%rbx, %rdi
	testq	%rax, %rax
	js	.LBB5_10
	incq	%rax
	cmovoq	%r14, %rax
	leaq	.L.str.78(%rip), %rdi
	movq	%rax, %rsi
	xorl	%edx, %edx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rdi
.LBB5_10:
	leaq	.L.str.80(%rip), %rsi
	leaq	.L.str.82(%rip), %rdx
	callq	assert_str_eq@PLT
	leaq	.L.str.84(%rip), %rdi
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB5_12
	incq	%rax
	cmovoq	%r14, %rax
	leaq	.L.str.84(%rip), %rdi
	movl	$13, %edx
	movq	%rax, %rsi
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB5_12:
	leaq	.L.str.86(%rip), %rsi
	leaq	.L.str.88(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	xorl	%eax, %eax
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end5:
	.size	test_rest_after, .Lfunc_end5-test_rest_after
	.cfi_endproc

	.globl	test_combined
	.p2align	4
	.type	test_combined,@function
test_combined:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	leaq	.L.str.data.89(%rip), %rdi
	callq	aria_println_cstr@PLT
	leaq	.L.str.92(%rip), %rbx
	leaq	.L.str(%rip), %rsi
	movq	%rbx, %rdi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB6_2
	leaq	.L.str.92(%rip), %rdi
	xorl	%esi, %esi
	movq	%rax, %rdx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %rbx
.LBB6_2:
	leaq	.L.str.92(%rip), %rdi
	leaq	.L.str.2(%rip), %rsi
	callq	aria_string_index_of_simple@PLT
	testq	%rax, %rax
	js	.LBB6_3
	incq	%rax
	movabsq	$9223372036854775807, %rsi
	cmovnoq	%rax, %rsi
	leaq	.L.str.92(%rip), %rdi
	movl	$20, %edx
	callq	aria_string_substring_simple@PLT
	movq	%rax, %r14
	jmp	.LBB6_5
.LBB6_3:
	leaq	.L.str.4(%rip), %r14
.LBB6_5:
	leaq	.L.str.94(%rip), %rsi
	leaq	.L.str.96(%rip), %rdx
	movq	%rbx, %rdi
	callq	assert_str_eq@PLT
	leaq	.L.str.98(%rip), %rsi
	leaq	.L.str.100(%rip), %rdx
	movq	%r14, %rdi
	callq	assert_str_eq@PLT
	xorl	%eax, %eax
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end6:
	.size	test_combined, .Lfunc_end6-test_combined
	.cfi_endproc

	.globl	main
	.p2align	4
	.type	main,@function
main:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %rbp, -16
	movq	%rsi, %rbx
	movl	%edi, %ebp
	xorl	%edi, %edi
	xorl	%esi, %esi
	callq	aria_gc_init@PLT
	movl	%ebp, %edi
	movq	%rbx, %rsi
	callq	aria_args_init@PLT
	callq	aria_streams_init@PLT
	leaq	.L.str.data.101(%rip), %rdi
	callq	aria_println_cstr@PLT
	leaq	.L.str.data.103(%rip), %rdi
	callq	aria_println_cstr@PLT
	callq	test_first_word@PLT
	callq	test_rest_after@PLT
	callq	test_combined@PLT
	leaq	.L.str.data.105(%rip), %rdi
	callq	aria_println_cstr@PLT
	movq	g_pass@GOTPCREL(%rip), %rbx
	movslq	(%rbx), %rdi
	callq	aria_string_from_int_simple@PLT
	movq	(%rax), %rdi
	callq	aria_print_cstr@PLT
	leaq	.L.str.data.107(%rip), %rdi
	callq	aria_print_cstr@PLT
	movq	g_total@GOTPCREL(%rip), %r14
	movslq	(%r14), %rdi
	callq	aria_string_from_int_simple@PLT
	movq	(%rax), %rdi
	callq	aria_print_cstr@PLT
	leaq	.L.str.data.109(%rip), %rdi
	callq	aria_println_cstr@PLT
	movl	(%rbx), %eax
	cmpl	(%r14), %eax
	jne	.LBB7_2
	leaq	.L.str.data.111(%rip), %rdi
	callq	aria_println_cstr@PLT
	xorl	%edi, %edi
	callq	exit@PLT
.LBB7_2:
	leaq	.L.str.data.113(%rip), %rdi
	callq	aria_println_cstr@PLT
	movl	$1, %edi
	callq	exit@PLT
.Lfunc_end7:
	.size	main, .Lfunc_end7-main
	.cfi_endproc

	.globl	__test_tokenizer_init
	.p2align	4
	.type	__test_tokenizer_init,@function
__test_tokenizer_init:
	xorl	%eax, %eax
	retq
.Lfunc_end8:
	.size	__test_tokenizer_init, .Lfunc_end8-__test_tokenizer_init

	.type	g_pass,@object
	.bss
	.globl	g_pass
	.p2align	2, 0x0
g_pass:
	.long	0
	.size	g_pass, 4

	.type	g_total,@object
	.globl	g_total
	.p2align	2, 0x0
g_total:
	.long	0
	.size	g_total, 4

	.type	.L.str.data,@object
	.section	.rodata,"a",@progbits
.L.str.data:
	.asciz	" "
	.size	.L.str.data, 2

	.type	.L.str,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str:
	.quad	.L.str.data
	.quad	1
	.size	.L.str, 16

	.type	.L.str.data.1,@object
	.section	.rodata,"a",@progbits
.L.str.data.1:
	.asciz	" "
	.size	.L.str.data.1, 2

	.type	.L.str.2,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.2:
	.quad	.L.str.data.1
	.quad	1
	.size	.L.str.2, 16

	.type	.L.str.data.3,@object
	.section	.rodata,"a",@progbits
.L.str.data.3:
	.zero	1
	.size	.L.str.data.3, 1

	.type	.L.str.4,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.4:
	.quad	.L.str.data.3
	.quad	0
	.size	.L.str.4, 16

	.type	.L.str.data.5,@object
	.section	.rodata,"a",@progbits
.L.str.data.5:
	.asciz	"  FAIL: "
	.size	.L.str.data.5, 9

	.type	.L.str.data.7,@object
.L.str.data.7:
	.asciz	" \342\200\224 expected '"
	.size	.L.str.data.7, 16

	.type	.L.str.data.9,@object
.L.str.data.9:
	.asciz	"' got '"
	.size	.L.str.data.9, 8

	.type	.L.str.data.11,@object
.L.str.data.11:
	.asciz	"'"
	.size	.L.str.data.11, 2

	.type	.L.str.data.13,@object
	.p2align	4, 0x0
.L.str.data.13:
	.asciz	"\342\224\200\342\224\200 first_word \342\224\200\342\224\200"
	.size	.L.str.data.13, 25

	.type	.L.str.data.15,@object
.L.str.data.15:
	.asciz	"ls"
	.size	.L.str.data.15, 3

	.type	.L.str.16,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.16:
	.quad	.L.str.data.15
	.quad	2
	.size	.L.str.16, 16

	.type	.L.str.data.17,@object
	.section	.rodata,"a",@progbits
.L.str.data.17:
	.asciz	"ls"
	.size	.L.str.data.17, 3

	.type	.L.str.18,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.18:
	.quad	.L.str.data.17
	.quad	2
	.size	.L.str.18, 16

	.type	.L.str.data.19,@object
	.section	.rodata,"a",@progbits
.L.str.data.19:
	.asciz	"single word"
	.size	.L.str.data.19, 12

	.type	.L.str.20,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.20:
	.quad	.L.str.data.19
	.quad	11
	.size	.L.str.20, 16

	.type	.L.str.data.21,@object
	.section	.rodata,"a",@progbits
.L.str.data.21:
	.asciz	"ls -la"
	.size	.L.str.data.21, 7

	.type	.L.str.22,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.22:
	.quad	.L.str.data.21
	.quad	6
	.size	.L.str.22, 16

	.type	.L.str.data.23,@object
	.section	.rodata,"a",@progbits
.L.str.data.23:
	.asciz	"ls"
	.size	.L.str.data.23, 3

	.type	.L.str.24,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.24:
	.quad	.L.str.data.23
	.quad	2
	.size	.L.str.24, 16

	.type	.L.str.data.25,@object
	.section	.rodata,"a",@progbits
.L.str.data.25:
	.asciz	"two words"
	.size	.L.str.data.25, 10

	.type	.L.str.26,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.26:
	.quad	.L.str.data.25
	.quad	9
	.size	.L.str.26, 16

	.type	.L.str.data.27,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.27:
	.asciz	"echo hello world"
	.size	.L.str.data.27, 17

	.type	.L.str.28,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.28:
	.quad	.L.str.data.27
	.quad	16
	.size	.L.str.28, 16

	.type	.L.str.data.29,@object
	.section	.rodata,"a",@progbits
.L.str.data.29:
	.asciz	"echo"
	.size	.L.str.data.29, 5

	.type	.L.str.30,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.30:
	.quad	.L.str.data.29
	.quad	4
	.size	.L.str.30, 16

	.type	.L.str.data.31,@object
	.section	.rodata,"a",@progbits
.L.str.data.31:
	.asciz	"three words"
	.size	.L.str.data.31, 12

	.type	.L.str.32,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.32:
	.quad	.L.str.data.31
	.quad	11
	.size	.L.str.32, 16

	.type	.L.str.data.33,@object
	.section	.rodata,"a",@progbits
.L.str.data.33:
	.asciz	"cd /tmp"
	.size	.L.str.data.33, 8

	.type	.L.str.34,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.34:
	.quad	.L.str.data.33
	.quad	7
	.size	.L.str.34, 16

	.type	.L.str.data.35,@object
	.section	.rodata,"a",@progbits
.L.str.data.35:
	.asciz	"cd"
	.size	.L.str.data.35, 3

	.type	.L.str.36,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.36:
	.quad	.L.str.data.35
	.quad	2
	.size	.L.str.36, 16

	.type	.L.str.data.37,@object
	.section	.rodata,"a",@progbits
.L.str.data.37:
	.asciz	"cd with path"
	.size	.L.str.data.37, 13

	.type	.L.str.38,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.38:
	.quad	.L.str.data.37
	.quad	12
	.size	.L.str.38, 16

	.type	.L.str.data.39,@object
	.section	.rodata,"a",@progbits
.L.str.data.39:
	.zero	1
	.size	.L.str.data.39, 1

	.type	.L.str.40,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.40:
	.quad	.L.str.data.39
	.quad	0
	.size	.L.str.40, 16

	.type	.L.str.data.41,@object
	.section	.rodata,"a",@progbits
.L.str.data.41:
	.zero	1
	.size	.L.str.data.41, 1

	.type	.L.str.42,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.42:
	.quad	.L.str.data.41
	.quad	0
	.size	.L.str.42, 16

	.type	.L.str.data.43,@object
	.section	.rodata,"a",@progbits
.L.str.data.43:
	.asciz	"empty string"
	.size	.L.str.data.43, 13

	.type	.L.str.44,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.44:
	.quad	.L.str.data.43
	.quad	12
	.size	.L.str.44, 16

	.type	.L.str.data.45,@object
	.section	.rodata,"a",@progbits
.L.str.data.45:
	.asciz	"exit"
	.size	.L.str.data.45, 5

	.type	.L.str.46,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.46:
	.quad	.L.str.data.45
	.quad	4
	.size	.L.str.46, 16

	.type	.L.str.data.47,@object
	.section	.rodata,"a",@progbits
.L.str.data.47:
	.asciz	"exit"
	.size	.L.str.data.47, 5

	.type	.L.str.48,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.48:
	.quad	.L.str.data.47
	.quad	4
	.size	.L.str.48, 16

	.type	.L.str.data.49,@object
	.section	.rodata,"a",@progbits
.L.str.data.49:
	.asciz	"exit command"
	.size	.L.str.data.49, 13

	.type	.L.str.50,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.50:
	.quad	.L.str.data.49
	.quad	12
	.size	.L.str.50, 16

	.type	.L.str.data.51,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.51:
	.asciz	"\342\224\200\342\224\200 rest_after \342\224\200\342\224\200"
	.size	.L.str.data.51, 25

	.type	.L.str.data.53,@object
.L.str.data.53:
	.asciz	"ls"
	.size	.L.str.data.53, 3

	.type	.L.str.54,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.54:
	.quad	.L.str.data.53
	.quad	2
	.size	.L.str.54, 16

	.type	.L.str.data.55,@object
	.section	.rodata,"a",@progbits
.L.str.data.55:
	.zero	1
	.size	.L.str.data.55, 1

	.type	.L.str.56,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.56:
	.quad	.L.str.data.55
	.quad	0
	.size	.L.str.56, 16

	.type	.L.str.data.57,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.57:
	.asciz	"single word \342\206\222 empty"
	.size	.L.str.data.57, 22

	.type	.L.str.58,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.58:
	.quad	.L.str.data.57
	.quad	21
	.size	.L.str.58, 16

	.type	.L.str.data.59,@object
	.section	.rodata,"a",@progbits
.L.str.data.59:
	.asciz	"ls -la"
	.size	.L.str.data.59, 7

	.type	.L.str.60,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.60:
	.quad	.L.str.data.59
	.quad	6
	.size	.L.str.60, 16

	.type	.L.str.data.61,@object
	.section	.rodata,"a",@progbits
.L.str.data.61:
	.asciz	"-la"
	.size	.L.str.data.61, 4

	.type	.L.str.62,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.62:
	.quad	.L.str.data.61
	.quad	3
	.size	.L.str.62, 16

	.type	.L.str.data.63,@object
	.section	.rodata,"a",@progbits
.L.str.data.63:
	.asciz	"two words"
	.size	.L.str.data.63, 10

	.type	.L.str.64,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.64:
	.quad	.L.str.data.63
	.quad	9
	.size	.L.str.64, 16

	.type	.L.str.data.65,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.65:
	.asciz	"echo hello world"
	.size	.L.str.data.65, 17

	.type	.L.str.66,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.66:
	.quad	.L.str.data.65
	.quad	16
	.size	.L.str.66, 16

	.type	.L.str.data.67,@object
	.section	.rodata,"a",@progbits
.L.str.data.67:
	.asciz	"hello world"
	.size	.L.str.data.67, 12

	.type	.L.str.68,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.68:
	.quad	.L.str.data.67
	.quad	11
	.size	.L.str.68, 16

	.type	.L.str.data.69,@object
	.section	.rodata,"a",@progbits
.L.str.data.69:
	.asciz	"three words"
	.size	.L.str.data.69, 12

	.type	.L.str.70,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.70:
	.quad	.L.str.data.69
	.quad	11
	.size	.L.str.70, 16

	.type	.L.str.data.71,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.71:
	.asciz	"cd /home/randy/Workspace"
	.size	.L.str.data.71, 25

	.type	.L.str.72,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.72:
	.quad	.L.str.data.71
	.quad	24
	.size	.L.str.72, 16

	.type	.L.str.data.73,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.73:
	.asciz	"/home/randy/Workspace"
	.size	.L.str.data.73, 22

	.type	.L.str.74,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.74:
	.quad	.L.str.data.73
	.quad	21
	.size	.L.str.74, 16

	.type	.L.str.data.75,@object
	.section	.rodata,"a",@progbits
.L.str.data.75:
	.asciz	"path argument"
	.size	.L.str.data.75, 14

	.type	.L.str.76,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.76:
	.quad	.L.str.data.75
	.quad	13
	.size	.L.str.76, 16

	.type	.L.str.data.77,@object
	.section	.rodata,"a",@progbits
.L.str.data.77:
	.zero	1
	.size	.L.str.data.77, 1

	.type	.L.str.78,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.78:
	.quad	.L.str.data.77
	.quad	0
	.size	.L.str.78, 16

	.type	.L.str.data.79,@object
	.section	.rodata,"a",@progbits
.L.str.data.79:
	.zero	1
	.size	.L.str.data.79, 1

	.type	.L.str.80,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.80:
	.quad	.L.str.data.79
	.quad	0
	.size	.L.str.80, 16

	.type	.L.str.data.81,@object
	.section	.rodata,"a",@progbits
.L.str.data.81:
	.asciz	"empty string"
	.size	.L.str.data.81, 13

	.type	.L.str.82,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.82:
	.quad	.L.str.data.81
	.quad	12
	.size	.L.str.82, 16

	.type	.L.str.data.83,@object
	.section	.rodata,"a",@progbits
.L.str.data.83:
	.asciz	"cd ~/projects"
	.size	.L.str.data.83, 14

	.type	.L.str.84,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.84:
	.quad	.L.str.data.83
	.quad	13
	.size	.L.str.84, 16

	.type	.L.str.data.85,@object
	.section	.rodata,"a",@progbits
.L.str.data.85:
	.asciz	"~/projects"
	.size	.L.str.data.85, 11

	.type	.L.str.86,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.86:
	.quad	.L.str.data.85
	.quad	10
	.size	.L.str.86, 16

	.type	.L.str.data.87,@object
	.section	.rodata,"a",@progbits
.L.str.data.87:
	.asciz	"tilde path"
	.size	.L.str.data.87, 11

	.type	.L.str.88,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.88:
	.quad	.L.str.data.87
	.quad	10
	.size	.L.str.88, 16

	.type	.L.str.data.89,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.89:
	.asciz	"\342\224\200\342\224\200 combined tokenize \342\224\200\342\224\200"
	.size	.L.str.data.89, 32

	.type	.L.str.data.91,@object
	.p2align	4, 0x0
.L.str.data.91:
	.asciz	"grep -r pattern src/"
	.size	.L.str.data.91, 21

	.type	.L.str.92,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.92:
	.quad	.L.str.data.91
	.quad	20
	.size	.L.str.92, 16

	.type	.L.str.data.93,@object
	.section	.rodata,"a",@progbits
.L.str.data.93:
	.asciz	"grep"
	.size	.L.str.data.93, 5

	.type	.L.str.94,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.94:
	.quad	.L.str.data.93
	.quad	4
	.size	.L.str.94, 16

	.type	.L.str.data.95,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.95:
	.asciz	"cmd from compound"
	.size	.L.str.data.95, 18

	.type	.L.str.96,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.96:
	.quad	.L.str.data.95
	.quad	17
	.size	.L.str.96, 16

	.type	.L.str.data.97,@object
	.section	.rodata,"a",@progbits
.L.str.data.97:
	.asciz	"-r pattern src/"
	.size	.L.str.data.97, 16

	.type	.L.str.98,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.98:
	.quad	.L.str.data.97
	.quad	15
	.size	.L.str.98, 16

	.type	.L.str.data.99,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.99:
	.asciz	"args from compound"
	.size	.L.str.data.99, 19

	.type	.L.str.100,@object
	.section	.data.rel.ro,"aw",@progbits
	.p2align	3, 0x0
.L.str.100:
	.quad	.L.str.data.99
	.quad	18
	.size	.L.str.100, 16

	.type	.L.str.data.101,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
.L.str.data.101:
	.asciz	"hex-shell tokenizer tests"
	.size	.L.str.data.101, 26

	.type	.L.str.data.103,@object
	.p2align	4, 0x0
.L.str.data.103:
	.asciz	"\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220\342\225\220"
	.size	.L.str.data.103, 76

	.type	.L.str.data.105,@object
.L.str.data.105:
	.zero	1
	.size	.L.str.data.105, 1

	.type	.L.str.data.107,@object
.L.str.data.107:
	.asciz	"/"
	.size	.L.str.data.107, 2

	.type	.L.str.data.109,@object
.L.str.data.109:
	.asciz	" tests passed"
	.size	.L.str.data.109, 14

	.type	.L.str.data.111,@object
.L.str.data.111:
	.asciz	"ALL PASS"
	.size	.L.str.data.111, 9

	.type	.L.str.data.113,@object
.L.str.data.113:
	.asciz	"SOME FAILURES"
	.size	.L.str.data.113, 14

	.section	".note.GNU-stack","",@progbits
