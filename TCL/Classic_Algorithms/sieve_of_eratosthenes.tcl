# The sieve of Eratosthenes is one of the most efficient ways to find all of the smaller primes (below 10 million or so).

proc range {from to} {
   if {$to>$from} {concat [range $from [incr to -1]] $to}
}

proc sieve_of_Eratosthenes {num p_lst} {
	upvar $p_lst primes
	set num_lst [range 2 $num]
	set factors {}
	
	# enumerating over all the multiples of p
	# till num
	foreach p $num_lst {
		# if current p is in factors list continue
		if {[lsearch $factors $p] != -1} {
			continue
		}
		
		# else append this to the primes and calculate its factors
		lappend primes $p
		set fact 2
		set mult 1
		
		# Calculating the factors of p
		while {$mult < $num} {
			set mult [expr $p * $fact]
			lappend factors $mult
			incr fact
		}
	}
	
}

# CLI
set num 1
while {$num} {
	set primes {}
	
	puts -nonewline "\nEnter a number till which to calculate the primes \[Enter 0 to exit\]: "
	flush stdout
	gets stdin num
	
	if {$num} {
		sieve_of_Eratosthenes $num primes
		puts "The primes till $num are: $primes\n"
	}
}