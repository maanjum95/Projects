# Fibonacci Sequence - Enter a number and have the program generate the Fibonacci sequence to that number or to the Nth number.

# Generates N number of fibonacci_sequences
# The results are stored in the array fibonacci_list provided as a reference
proc fibonacci_seq_N {fibonacci_list N} {
	upvar $fibonacci_list fib_list
	set fib_list(0) 0;
	set fib_list(1) 1;
	
	for {set i 2} {$i < $N} {incr i} {
		set fib_list($i) [expr $fib_list([expr $i-1]) + $fib_list([expr $i-2])];
	}
}

# Generates fibonacci_sequences till the number num
# The results are stored in the array fibonacci_list provided as a reference
proc fibonacci_seq_till_num {fibonacci_list num} {
	upvar $fibonacci_list fib_list
	set fib_list(0) 0
	set fib_list(1) 1
	
	set i 1
	while {$fib_list($i) < $num} {
		incr i
		set fib_list($i) [expr $fib_list([expr $i-1]) + $fib_list([expr $i-2])]; 
	}
	
	# Removing the additional number since it is greater than num
	unset fib_list($i)
}

proc print_fibonacci_seq {fibonacci_list} {
	upvar $fibonacci_list fib_list
	
	puts "The Fibonacci Series of size [array size fib_list] is as follows:"
	foreach {idx} [lsort -integer [array names fib_list]] {
		puts "[expr $idx + 1]: $fib_list($idx)"
	}
}

# CLI Interface
if {$argc != 2} {
	puts "Incorrect command usage"
	puts "Correct usage: tclsh fibonacci_sequence.tcl num/N 100"
} else {
	switch [lindex $argv 0] {
		"N" {
			puts "Generating Fibonacci Sequence of [lindex $argv 1] elements..."
			fibonacci_seq_N fibonacci_list [lindex $argv 1]
			print_fibonacci_seq fibonacci_list
		}
		"num" {
			puts "Generating Fibonacci Sequence till the number [lindex $argv 1]..."
			fibonacci_seq_till_num fibonacci_list [lindex $argv 1]
			print_fibonacci_seq fibonacci_list
		}
		default {
			puts "Incorrect option. Use either N or num".
		}
	}
}
