# board.s ... Game of Life on a 10x10 grid

   .data

N: .word 11  # gives board dimensions

board:
   .byte 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 
   .byte 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1
   .byte 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1
   .byte 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1
   .byte 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1
   .byte 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1
   .byte 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1
   .byte 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
   .byte 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
   .byte 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1
   .byte 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1


newBoard: .space 121
