#programa que recebe o numero de linhas, o numero de colunas 
# e uma matriz de float em seguida imprime a matriz

.data
    initialProgramText: .asciiz "Programa que lê e imprime uma matriz real"
    getRowsNumberText: .asciiz "Insira o numero de linhas: "
    getColsNumberText: .asciiz "Insira o numero de colunas: "
    insertMatrixText: .asciiz "Insira a matriz:"
    newLineChar: .asciiz  "\n"
    spaceChar: .byte ' '
.text
    main:        
        la $a0,initialProgramText #carrega o endereço de initialProgramText em $a0
        li $v0,4 #carrega o valor 4 em $v0
        syscall # chamada do sistema para imprimir initialProgramText

	jal newLine # chama subrotina para imprimir quebra de linha

 	la $a0,getRowsNumberText #carrega o endereço de getRowsNumberText em $a0
        li $v0,4 #carrega o valor 4 em $v0 código de impressão de string
        syscall # chamada do sistema para imprimir getRowsNumberText

	jal newLine
		        
        li $v0,5 #carrega o valor 5 em $v0 código de leitura inteiro
        syscall # chamada do  sistena para ler um int e armazenar em $v0
        
	add $s0,$v0,$zero #salvando numero de linhas
        
        la $a0,getColsNumberText #carrega o endereço de getRowsNumberText em $a0
        li $v0,4 #carrega o valor 4 em $v0 codigo de impressão de string
        syscall # chamada do sistema para imprimir getRowsNumberText
        
        
        jal newLine # chama subrotina para imprimir quebra de linha
        
        li $v0,5 #carrega o valor 5 em $v0 código de leitura inteiro
        syscall # chamada do  sistena para ler um int e armazenar em $v0
        
        add $s1,$v0,$zero #salvando o numero de colunas
        
        mul $t0,$s0,$s1 #calculando numero de floats que serao recebidos
        
        mul $t1,$t0,4 #calculando numero de bytes para armazenamento e salvando em $t3
        
        add $a0,$zero,$t1 #carregando em $a0 o numero de bytes necessarios
        li $v0,9 # codigo para solicitar reserva de mémoria heap
        syscall  # chamada do sistema para alocar memoria  
	
	div $t1,$s0 #calculando tamanho em bytes de uma linha      
        mflo $s3 #salvando tamanho em bytes de uma linha
        
        add $s2,$zero,$v0 # salvando o endereco inicial da sequencia de bytes
        
        add $t1,$zero,$t0 # iniciando contador de elementos
        
        add $t0,$zero,$v0 # inciando o iterador para amazenagem na pilha
        
        la $a0,insertMatrixText #carrega o endereço de getRowsNumberText em $a0
        li $v0,4 #carrega o valor 4 em $v0 codigo de impressão de string
        syscall # chamada do sistema para imprimir getRowsNumberText
        
        jal newLine
        
        readLoop:
               	li $v0,6 # carregando em $v0 codigo de leitura de float
        	syscall # chamada do sistema para ler um float
        	s.s $f0,($t0) # armazenando o valor lido na "matriz"  
        	addiu $t0,$t0,4 # apontando para o espaco de armazenamento seguinte
        	subi $t1,$t1,1 # decrementa o contador de elementos
        	bne $t1,$zero,readLoop # carrega o endereço de readLoop em $pc se $t1 for diferente de $zero
        
        jal newLine
        
        add $t2,$zero,$s2 # iniciando iterador de impressao
        
        printLineLoop:
        	beq $t2,$t0,exit_sucess
        	add $sp,$sp,-4
        	sw $t2,($sp)
        	jal imprimeLinha
        	jal newLine
        	add $t2,$t2,$s3
        	add $sp,$sp,4
        	j printLineLoop
    imprimeLinha:
    	lw $t1,($sp) # armazena o valor de ($sp) em $t1 para imprimir o valor
    	add $t3,$t1,$s3
    	printColLoop:
    		beq $t3,$t1,return
    		l.s $f12,($t1)
    		li $v0,2 # armazena em $v0 codigo para impressão de float
    		syscall # chamada do sistema para impressão de float
    		
    		la $a0,spaceChar # carrega o endereço de spaceChar é armazenado em $a0
    		li $v0,4 # armazena o codigo de impressao de char em $v0
    		syscall # chamada do sistema para impressao de espaco
    		addiu $t1,$t1,4
    		j printColLoop    	
    	return:	
    	jr $ra # carrega em $pc o valor de $ra
    
    newLine:
    	la $a0, newLineChar #Carrega o endereço de newLine em $a0
    	li $v0, 4 # carrega o código de impressão de caractere em $v0
    	syscall # chamada do sistema para imprimir \n
    	jr $ra
    
    exit_sucess:	
    	li $v0,10
        syscall