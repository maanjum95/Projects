# Takes in a credit card number from a common credit card vendor (Visa, MasterCard, American Express, Discoverer) 
# and validates it to make sure that it is a valid number (look into how credit cards use a checksum).

# The validation algorithm is based on Luhn algorithm also known as module 10 algorithm.
# The algorithm is as follows:

# 1. From the rightmost digit (excluding the check digit) and moving left, double the value of every second digit. 
# The check digit is neither doubled nor included in this calculation; the first digit doubled is the digit located immediately left of the check digit. 
# If the result of this doubling operation is greater than 9 (e.g., 8 × 2 = 16), 
# then add the digits of the result (e.g., 16: 1 + 6 = 7, 18: 1 + 8 = 9) or, 
# equivalently, subtract 9 from the result (e.g., 16: 16 − 9 = 7, 18: 18 − 9 = 9).
# 2. Take the sum of all the digits (including the check digit).
# 3. If the total modulo 10 is equal to 0 (if the total ends in zero) then the number is valid according to the Luhn formula; otherwise it is not valid.

proc luhn_algo {num} {
	set sum 0
	set skip true
	for {set i [expr [string length $num] - 1]} {$i > -1} {incr i -1} {
		set digit [string range $num $i $i]
		
		# double every second digit
		if {!$skip} {
			set digit [expr ($digit * 2)]
			if {$digit > 9} {set digit [expr $digit - 9]}
			set skip true
		} else {
			set skip false
		}
		set sum [expr $sum + $digit]
	}
	return [expr $sum % 10]
}

proc credit_card_validator {num} {
	if {[expr [luhn_algo $num] == 0]} {
		return true
	} else {
		return false
	}
}

if {$argc != 1} {
	puts "Incorrect usage!"
	puts "Correct usage: tclsh $argv0 [card_number]"
} else {
	if {[credit_card_validator [lindex $argv 0]]} {
		puts "Your credit card information is correct."
	} else {
		puts "Your credit card information is incorrect!"
	}
}