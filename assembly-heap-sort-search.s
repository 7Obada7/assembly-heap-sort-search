		AREA veri,DATA,READWRITE
negative_max equ -2147483647		
unsorted_array	DCD 12,6,7,9,19,18,negative_max
sorted_array	space 24
min_heap space 24	
		AREA ORNEK,CODE,READONLY
		ENTRY
		EXPORT main
			
main	PROC
	LDR	R0, = unsorted_array
	LDR R1, = min_heap
	BL build 
	; Now R0 contains the address of the first element of the sorted list
	LDR R0, =7; Load value to search
    LDR R1, =min_heap       ; Load pointer to heap
    BL find                 ; Call find procedure
    ; Now R0 contains 1 if found, 0 otherwise
    ; If found, R1 contains the address of the found element
	

	
son		B son	

	
build	
    ; Initialize pointers
    MOV R2, R0      ; R2 = list (pointer to list of integers)
    MOV R3, R1      ; R3 = heap (pointer to heap data structure)

    ; Initialize heap size
    MOV R4, #0      ; R4 = index for heap size
    MOV R5, #1      ; R5 = index for inserting into heap array (start from index 1)
	

loop
    ; Load next integer from the list
    LDR R6, [R2], #4   ; R6 = *R2, R2 = R2 + 4 (move to next integer)
	
	LDR R7 , = negative_max
    ; Check for termination condition (-MAXINT)
    CMP R6, R7   ; Check if R6 == -MAXINT
    BEQ done               ; Exit loop if termination value encountered

    ; Insert integer into the heap array
    STR R6, [R3, R5, LSL #2]    ; heap[R5] = R6 (store integer in heap array)
    ADD R4, R4, #1              ; Increment heap size
    ADD R5, R5, #1              ; Increment insert index for heap array

    B loop      ; Repeat until termination value is encountered

done
    STR R4, [R3]    ; heap[0] = heap size (number of elements)

    ; Perform heapify to establish min-heap property
	MOV R8, #0 ; init i for loop
loop_heapify
	CMP R8, #2
	BEQ loop_heapify_end
	; Set the size of the heap
    LDR R10, =min_heap    ; heap[0] = heap size (number of elements)
	LDR R4, [R10]
	PUSH {LR}
    BL heapify      ; Call heapify subroutine
	POP {LR}
	ADD R8, R8, #1
	B loop_heapify
loop_heapify_end
    BX LR           ; Return from procedure

heapify
    ; Implement heapify operation here
    ; This subroutine ensures that the min-heap property is maintained
    ; after insertion of elements
    ; R3 = heap (pointer to heap data structure)
    ; R4 = heap size

    MOV R0, R4          ; R0 = heap size

    CMP R0, #1          ; If heap size <= 1, no need to heapify
    BLT end_heapify

    MOV R1, R3          ; R1 = heap (pointer to heap data structure)
	ADD R1, #4
	
    MOV R2, R4          ; R2 = heap size

    MOV R0, R2, LSR #1  ; R0 = heap size / 2 (index of last parent node)

heapify_loop
    SUB R0, R0, #1      ; Decrement parent index
	PUSH {LR}
    BL heapify_down     ; Call heapify_down on each parent node
	POP {LR}
    CMP R0, #0          ; Loop until all parent nodes are processed
    BGT heapify_loop

end_heapify
	
    BX LR               ; Return from subroutine

heapify_down
    ; This subroutine ensures that the min-heap property is maintained
    ; after deletion of elements
    ; R0 = parent index
    ; R1 = heap first element address
    ; R2 = heap size value

    MOV R3, R0          ; R3 = parent index
    LSL R3, R3, #2      ; Convert to byte index
    ADD R3, R1, R3      ; R3 = address of parent node

    MOV R4, R0          ; R4 = parent index
    ADD R4, R4, R4, LSL #1  ; R4 = 2*parent + 1 (index of left child)
    ADD R4, #1          ; R4 = index of right child

    CMP R4, R2          ; If right child index >= heap size, check left child
    BGE check_left_child

    LSL R4, R4, #2      ; Convert to byte index
    ADD R4, R1, R4      ; R4 = address of right child

    LDR R5, [R3]        ; R5 = value of parent node
    LDR R6, [R4]        ; R6 = value of right child

    CMP R5, R6          ; If parent value < right child value, check left child
    BLT check_left_child

    ; If parent value >= right child value, swap parent and right child
    STR R6, [R3]
    STR R5, [R4]

check_left_child
    SUB R4, R4, #4      ; R4 = address of left child

    LDR R5, [R3]        ; R5 = value of parent node (possibly swapped)
    LDR R6, [R4]        ; R6 = value of left child

    CMP R5, R6          ; If parent value < left child value, end heapify_down
    BLT end_heapify_down

    ; If parent value >= left child value, swap parent and left child
    STR R6, [R3]
    STR R5, [R4]

end_heapify_down
    BX LR               ; Return from subroutine
	
find
    ; Input: R0 = value to find, R1 = heap (pointer to heap data structure)
    ; Output: R0 = 1 if found, 0 otherwise; R1 = address if found, unchanged otherwise

    ; Save registers
    PUSH {R2-R5, LR}

    ; Initialize variables
    MOV R2, R1      ; R2 = heap (pointer to heap data structure)
    LDR R1, [R2]    ; Load heap size
    MOV R3, #1      ; Start index for search
    MOV R4, R0      ; Copy search value to R4

search_loop
    CMP R3, R1      ; Compare current index with heap size
    BGE search_end  ; If index >= heap size, exit loop

    ; Calculate address of current element in heap
    LSL R5, R3, #2  ; Multiply index by 4 to get byte offset
    ADD R5, R2, R5  ; Add offset to heap base address

    ; Load value from heap
    LDR R0, [R5]

    ; Compare value with search value
    CMP R0, R4
    BEQ found       ; If found, branch to found label

    ; Increment index
    ADD R3, R3, #1

    ; Continue loop
    B search_loop

found
    MOV R0, #1      ; Set result to 1 (found)
    MOV R1, R5      ; Set R1 to address of found element

search_end
    ; Restore registers and return
    POP {R2-R5, PC}
	




		ENDP
		END