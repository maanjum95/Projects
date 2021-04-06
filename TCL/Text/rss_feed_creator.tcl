# RSS Feed Creator - Given a link to RSS/Atom Feed, get all posts and display them.

package require http
package require tdom

proc get_rss_feed {url} {
	set handle [::http::geturl $url]
	set body [::http::data $handle]
	
	return $body
}

proc clean_description {description} {
	set description_end [string first {<} $description]
	
	return [string range $description 0 [expr $description_end - 1]]
}

proc parse_item {item} {
	set title [lindex [$item selectNode title] 0]
	set description [lindex [$item selectNode description] 0]
	set link [lindex [$item selectNode link] 0]
	set pub_date [lindex [$item selectNode pubDate] 0]

	if {[llength $title]} {dict set item_dict title [$title text]}
	if {[llength $description]} {dict set item_dict description [clean_description [$description text]]}
	if {[llength $link]} {dict set item_dict link [$link text]}
	if {[llength $pub_date]} {dict set item_dict pub_date [$pub_date text]}
	
	return $item_dict
}

proc parse_channel {channel} {	
	set title [lindex [$channel selectNode title] 0]
	set description [lindex [$channel selectNode description] 0]
	set link [lindex [$channel selectNode link] 0]
	set copyright [lindex [$channel selectNode copyright] 0]
	set pub_date [lindex [$channel selectNode pubDate] 0]
	
	set items [$channel select item]
	set item_dicts {}
	foreach item $items {	
		set item_dict [parse_item $item]
		lappend item_dicts $item_dict
	}
	
	if {[llength $title]} {dict set channel_dict title [$title text]}
	if {[llength $description]} {dict set channel_dict description [$description text]}
	if {[llength $link]} {dict set channel_dict link [$link text]}
	if {[llength $copyright]} {dict set channel_dict copyright [$copyright text]}
	if {[llength $pub_date]} {dict set channel_dict pub_date [$pub_date text]}
	if {[llength $item_dicts]} {dict set channel_dict items $item_dicts}
	
	return $channel_dict
}

proc parse_rss {body lst} {
	upvar $lst channel_lst
	set doc [dom parse $body]
	set root [$doc documentElement]
	set channels [$root selectNode /rss/channel]
	
	foreach channel $channels {
		lappend channel_lst [parse_channel $channel]
	}
}

proc print_item {item_dict} {
	set title "Sample Title"
	set description "Sample Description"
	set link "sample.link"
	set pub_date "Thurs, 01 Jan 1970 00:00:00 GMT"
	
	if {[dict exists $item_dict title]} {set title [dict get $item_dict title]}
	if {[dict exists $item_dict description]} {set description [dict get $item_dict description]}
	if {[dict exists $item_dict link]} {set link [dict get $item_dict link]}
	if {[dict exists $item_dict pub_date]} {set pub_date [dict get $item_dict pub_date]}
	
	puts "---------------------------------------------------------------------------------------"
	puts "Title: $title"
	puts "Link: $link"
	puts "Published on: $pub_date"
	if {[string length $description]} {puts "\n$description\n"}	
	puts "---------------------------------------------------------------------------------------"
}

proc print_channel {channel_dict} {
	
	set title "Sample Title"
	set description "Sample Description"
	set link "sample.link"
	set pub_date "Thurs, 01 Jan 1970 00:00:00 GMT"
	set item_dicts {}
	
	if {[dict exists $channel_dict title]} {set title [dict get $channel_dict title]}
	if {[dict exists $channel_dict description]} {set description [dict get $channel_dict description]}
	if {[dict exists $channel_dict link]} {set link [dict get $channel_dict link]}
	if {[dict exists $channel_dict copyright]} {set copyright [dict get $channel_dict copyright]}
	if {[dict exists $channel_dict pub_date]} {set pub_date [dict get $channel_dict pub_date]}
	if {[dict exists $channel_dict items]} {set item_dicts [dict get $channel_dict items]}
	
	puts "---------------------------------------------------------------------------------------"
	puts "---------------------------------------------------------------------------------------"
	puts "Channel: $title"
	puts "Copyright: $copyright"
	puts "Link: $link"
	puts "Date: $pub_date"
	puts "\"\"$description\"\""	
	puts "---------------------------------------------------------------------------------------"
	puts "---------------------------------------------------------------------------------------"
	foreach item_dict $item_dicts {
		print_item $item_dict
	}
}

proc print_rss_feed {url} {
	set rss_feed [get_rss_feed $url]
	parse_rss $rss_feed channel_lst

	foreach channel $channel_lst {
		 print_channel $channel
	 }
}

# CLI
set rss_url ""
puts -nonewline "Enter the url of RSS Feed you want to read: "
flush stdout
gets stdin rss_url

print_rss_feed $rss_url