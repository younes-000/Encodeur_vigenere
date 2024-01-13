section .data
    message db 'TEST', 0    ; Message to encrypt
    key     db 'ABCDEFGHIKLMNOPQRSTUVWXYZ', 0           ; Encryption key
    key_len equ $ - key           ; Length of the key

section .bss
    res resb 10                   ; Encrypted result

section .text
global _start

_start:
    mov rsi, message              ;Pointeur vers le message
    mov rdi, res                  ;Pointeur vers le résultat
    xor rcx, rcx                  ;Indice clé

cipher_loop:
    mov al, [rsi]                 ;Chargez le caractère de message actuel dans Al
    cmp al, 0                     ;Vérifiez si c'est la fin de la chaîne
    je  end_loop                  ;Si c'est la fin, sortez de la boucle

    ; Vigenère cipher
    mov bl, [key + rcx]           ;Chargez la lettre de clé actuelle dans BL
    sub bl, 'A'                   ;Convertir de l'ASCII en index alphabétique
    add al, bl                    ;Ajouter le décalage de la clé
    cmp al, 'Z'                   ;Vérifiez le débordement
    jg  wrap_around               ;Manipuler
    jmp no_wrap

wrap_around:
    sub al, 26                    ;Envelopper au début de l'alphabet

no_wrap:
    mov [rdi], al                 ;Magasin de personnage crypté
    inc rsi                       ;Passez au personnage du message suivant
    inc rdi                       ;Passez au personnage du résultat suivant
    inc rcx                       ;Passez au personnage clé suivant
    cmp rcx, key_len              ;Vérifiez si la fin de la clé est atteinte
    jl  cipher_loop
    xor rcx, rcx                  ;Réinitialisez l'index de la clé à 0
    jmp cipher_loop

end_loop:
    ; Print the encrypted message
    mov rdx, 10                   ;Longueur du message
    mov rsi, res                  ;Pointeur vers le message crypté
    mov rdi, 1                    ;Descripteur de fichiers (1 pour stdout)
    mov rax, 1                    ;Numéro d'appel système pour sys_write
    syscall                       ;Appeler le noyau

    ; Exit the program
    mov rax, 60                   ;Numéro d'appel système pour sys_exit
    xor rdi, rdi                  ;Quitter le statut
    syscall                       ;Appeler le noyau


; La réponse est TFUW pour 
