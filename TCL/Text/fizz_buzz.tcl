# Write a program that prints the numbers from 1 to 100. 
# But for multiples of three print “Fizz” instead of the number and for the multiples of five print “Buzz”. 
# For numbers which are multiples of both three and five print “FizzBuzz”.

proc fizz_buzz {} {
	for {set i 1} {$i <= 100} {incr i} {
		if {$i % 3 == 0 && $i % 5 == 0} {
			puts "FizzBuzz"
		} elseif {$i % 3 == 0} {
			puts "Fizz"
		} elseif {$i % 5 == 0} {
			puts "Buzz"
		} else {
			puts $i
		}
	}
}

fizz_buzz