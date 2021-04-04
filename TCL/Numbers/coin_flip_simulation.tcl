# Write some code that simulates flipping a single coin however many times the user decides. 
# The code should record the outcomes and count the number of tails and heads.

# Flip a coin N number of times
proc coin_flip_simulation {N record} {
	upvar $record flips

	for {set i 1} {$i <= $N} {incr i} {
		set rand_num  [expr rand()]
		
		if {$rand_num > 0.5} {
			lappend flips "H"
		} else {
			lappend flips "T"
		}
	}
} 

proc num_heads {record} {
	upvar $record flips
	set heads 0
	
	foreach flip $flips {
		if {$flip == "H"} {
			incr heads
		}
	}
	
	return $heads
}

proc coin_flipper {N} {
	coin_flip_simulation $N record
	set heads [num_heads record]
	set tails [expr $N - $heads]
	
	puts "The coin flip simulation of $N flips has completed."
	puts "Outcomes: $record"
	puts "Heads: $heads"
	puts "Tails: $tails"

}

if {$argc != 1} {
	puts "Incorrect usage!"
	puts "Correct usage: tclsh coin_flip_simulation.tcl \[no of flips\]"
} else {
	coin_flipper [lindex $argv 0]
}