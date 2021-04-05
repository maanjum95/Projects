# A happy number is defined by the following process. Starting with any positive integer, 
# replace the number by the sum of the squares of its digits, and repeat the process until the number equals 1 (where it will stay), 
# or it loops endlessly in a cycle which does not include 1. 
# Those numbers for which this process ends in 1 are happy numbers, while those that do not end in 1 are unhappy numbers. 
# Display an example of your output here. Find first 8 happy numbers.

# Computes wether the given number is a happy number
proc calc_sq_sum {num} {
	set sum 0
	for {set i 0} {$i < [string length $num]} {incr i} {
		set digit [string range $num $i $i]
		set digit_sq [expr $digit**2]
		set sum [expr $sum + $digit_sq]
	}
	return $sum
}

proc happy_num {num args} {
	if {[llength $args] > 0} {
		upvar [lindex $args 0] calc_list
	}
	lappend calc_list $num
	set calc_num [calc_sq_sum $num]
	
	# keep running till we get the sq sum to be 1
	# or we find a new number which was not previously calculated
	while {$calc_num != 1 && [expr [lsearch $calc_list $calc_num] == -1]} {
		lappend calc_list $calc_num
		set calc_num [calc_sq_sum $calc_num]
	}
	
	# Return true is the loop quit and the calculated number is 1
	# Other wise we are going in a loop with the calculation
	if {$calc_num == 1} {
		return true
	} else {
		return false
	}
}

# Calculating the first N happy numbers starting for 1
proc list_happy_num {list_happy {N 8}} {
	upvar $list_happy list_num
	set list_len 0
	set num 1
	
	while {$list_len < $N} {
		if {[happy_num $num]} {
			lappend list_num $num
			incr list_len
		}
		incr num
	}
}


# CLI
puts "Calculating the first 8 happy numbers..."
list_happy_num happy_list
puts "The first 8 happy numbers are: $happy_list"

set num 1
while {$num} {
	set list {}
	
	puts -nonewline "\n\nEnter a number to check if it is happy \[Enter 0 to exit\]: "
	flush stdout
	gets stdin num
	
	if {[happy_num $num list]} {
		puts "Your number $num is a happy number, with calculations: $list"
	} else {
		puts "Sadly! Your number $num is not happy, with calculations: $list"
	}
}