# Pig Latin is a game of alterations played on the English language game. 
# To create the Pig Latin form of an English word the initial consonant sound is transposed to the end of the word 
# and an ay is affixed (Ex.: "banana" would yield anana-bay). 
# Read Wikipedia for more information on rules.

proc is_vowel {alphabet} {
	switch $alphabet {
		a -
		e -
		i -
		o -
		u -
		A -
		E -
		I -
		O -
		U {
			return true
		}
		default {
			return false
		}
	}
}

proc pig_latin {word} {
	for {set i 0} {$i < [string length $word]} {incr i} {
		set alpha [string index $word $i]
		
		if {[is_vowel $alpha]} {
			set init_const [string range $word 0 [expr $i - 1]]
			set rest_word [string range $word $i end]
			
			return [format "%s%say" $rest_word $init_const]
		}
	}
}

# CLI
set in_str ""
set out_str {}
puts -nonewline "Enter string to convert to Pig Latin: "
flush stdout
gets stdin in_str

foreach word $in_str {
	lappend out_str [pig_latin $word]
}

puts "\nYour text in Pig Latin is: [join $out_str " "]"
