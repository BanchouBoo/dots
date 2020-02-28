declare-option int typewrite_x_move 10
declare-option int typewrite_y_move 10
declare-option -hidden int typewriter_offset

hook global InsertChar [^\n] %{
	evaluate-commands %sh{
		xdotool getactivewindow windowmove --relative -- -$kak_opt_typewrite_x_move 0
	}
    set-option -add window typewriter_offset %opt{typewrite_x_move}
}

hook global InsertChar \n %{
	evaluate-commands %sh{
		xdotool getactivewindow windowmove --relative -- $kak_opt_typewriter_offset -$kak_opt_typewrite_y_move
	}
    set-option window typewriter_offset 0
}
