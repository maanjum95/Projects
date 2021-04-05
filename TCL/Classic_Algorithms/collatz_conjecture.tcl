# Start with a number n > 1. 
# Find the number of steps it takes to reach one using the following process: 
# If n is even, divide it by 2. If n is odd, multiply it by 3 and add 1.

proc next_num {num} {
	if {$num % 2 == 0} {
		# if the number is even
		return [expr $num / 2]
	} else {
		return [expr $num * 3 + 1]
	} 
}

proc collatz_conjecture {num lst} {
	upvar $lst hist
	
	set next [next_num $num]
	set steps 1
	while {$next != 1} {
		lappend hist $next
		set next [next_num $next]
		incr steps
	}
	# appending the 1 not appended in loop
	lappend hist $next
	
	return $steps
}

# CLI
set num 1
while {$num} {
	set lst {}
	
	puts -nonewline "Enter a number to calculate Collatz Conjecture \[Enter 0 to exit\]: "
	flush stdout
	gets stdin num
	
	if {$num} {
		set steps [collatz_conjecture $num lst]
		puts "\nCollatz Conjecture was calculated in $steps steps: $lst\n"
	}
}
