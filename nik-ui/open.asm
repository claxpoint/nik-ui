; Define segment declarations
.model small
.stack 100h

; Data segment
.data
fileName db "data.bin", 0  ; Replace with your actual file name
fileSize equ 100h           ; Adjust based on your file size (in bytes)
buffer db fileSize dup(?)  ; Buffer to hold file content (replace ? with actual data type)

; Code segment
.code
main PROC

    ; Open the file for reading
    mov ah, 3fh
    mov dx, offset fileName
    int 21h
    jc error_open

    ; Read the file content into the buffer
    mov ah, 3fh
    mov bx, ax               ; Save file handle in bx
    mov cx, fileSize          ; Number of bytes to read
    mov dx, offset buffer
    int 21h
    jc error_read

    ; Call the sorting function
    mov ax, @data
    mov ds, ax               ; Set data segment
    push fileSize            ; Push file size for sorting function
    push offset buffer        ; Push buffer address for sorting function
    call sort                 ; Call the sorting function

    ; Close the file
    mov ah, 4fh
    mov bx, ax               ; Restore file handle
    int 21h
    jc error_close

    ; (Optional) Write the sorted data back to the file (modify based on your needs)
    ; ...

    jmp exit

error_open:
    ; Handle file open error
    mov dx, offset "Error opening file"
    mov ah, 9
    int 21h
    jmp exit

error_read:
    ; Handle file read error
    mov dx, offset "Error reading file"
    mov ah, 9
    int 21h
    jmp exit

error_close:
    ; Handle file close error
    mov dx, offset "Error closing file"
    mov ah, 9
    int 21h

exit:
    ret

sort PROC
    ; Sorts the data in the provided buffer (bubble sort)
    push bp                  ; Save base pointer
    mov bp, sp                ; Set base pointer

loop_outer:
    mov cx, [bp+8] - 1       ; Get file size (minus 1 for last element)
    jle loop_end             ; Exit if no more elements to compare

loop_inner:
    mov si, [bp+10]           ; Get buffer pointer
    cmp [si], [si+2]          ; Compare current and next element
    jg loop_swap              ; Jump if greater (swap needed)
    inc si                    ; Move to next element pair
    loop loop_inner           ; Repeat inner loop for remaining elements

loop_swap:
    mov dx, [si]              ; Move first element to dx
    mov [si], [si+2]          ; Move second element to first position
    mov [si+2], dx            ; Move saved element (dx) to second position

    dec cx                    ; Decrement counter for outer loop
    jg loop_outer             ; Repeat outer loop if more elements to compare

loop_end:
    pop bp                   ; Restore base pointer
    ret                       ; Return from sort function

main ENDP
END main
