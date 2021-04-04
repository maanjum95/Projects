# The Factorial of a positive integer, n, is defined as the product of the sequence 
# n, n-1, n-2, ...1 and the factorial of zero, 0, is defined as being 1. 
# Solve this using both loops and recursion.

# Straight forward implementation of factorial
proc factorial {N} {
	if {$N < 2} {
		return 1;
	}
	
	set fact $N
	incr N -1
	
	while {$N > 0} {
		set fact [expr $fact * $N]
		incr N -1
	}
	return $fact
}

# Recursive implementation of Factorial
proc factorial_rec {N} {
	if {$N < 2} {
		return 1;
	} else {
		set fact_n_1 [factorial_rec [expr $N - 1]]
		
		return [expr $N * $fact_n_1]
	}
}

puts [factorial 0]
puts [factorial_rec 0]
puts [factorial 5]
puts [factorial_rec 6]