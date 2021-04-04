#Implement two types of sorting algorithms: Merge sort and bubble sort.

proc swap {lst a b} {
	upvar $lst arr
	
	set tmp [lindex $arr $a]
	lset arr $a [lindex $arr $b]
	lset arr $b $tmp
}

proc quick_sort {lst {s_i 0} {e_i -1}} {
	upvar $lst arr
	
	if {$e_i == -1} {set e_i [expr [llength $arr] - 1]}
	
	set lst_len [expr $e_i - $s_i + 1]
	if {$lst_len < 2} {
		return
	}
	
	set pivot [expr int((rand() * $lst_len)) + $s_i]
	set pivot_val [lindex $arr $pivot]
	
	# Swapping the pivot point to start of the arr
	swap arr $s_i $pivot
	set diff_pt $s_i
	
	# Doing one pass swaps to create a boundary of greater and smaller values than pivot value
	for {set i [expr $s_i + 1]} {$i <= $e_i} {incr i} {
		if {[lindex $arr $i] < $pivot_val} {
			incr diff_pt
			swap arr $diff_pt $i
		}
	}
	# Swapping back pivot point to the point of difference
	swap arr $diff_pt $s_i
	
	# Recursively calling on the two halves of the array
	quick_sort arr $s_i [expr $diff_pt - 1]
	quick_sort arr [expr $diff_pt + 1] $e_i
}

proc bubble_sort {lst} {
	upvar $lst arr
	set did_swap true
	
	while {$did_swap} {
		set did_swap false
		for {set i 0} {$i < [expr [llength $arr] - 1]} {incr i} {
			# swapping two numbers if earlier index is bigger
			if {[lindex $arr $i] > [lindex $arr [expr $i + 1]]} {
				swap arr $i [expr $i + 1]
				set did_swap true
			}
		}
	}
}

set test {8 5 90 8 30 29}
quick_sort test
puts $test