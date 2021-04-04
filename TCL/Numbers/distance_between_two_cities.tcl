# Calculates the distance between two cities and allows the user to specify a unit of distance. 
# This program may require finding coordinates for the cities like latitude and longitude.

package require http
package require json

proc to_rad {deg} {
	set pi 3.1415926535897931
	return [expr $deg * $pi / 180]
}

proc calc_distance {coord_a coord_b R} {
	set lat_a [to_rad [dict get $coord_a lat]]
	set lng_a [to_rad [dict get $coord_a lng]]
	
	set lat_b [to_rad [dict get $coord_b lat]]
	set lng_b [to_rad [dict get $coord_b lng]]
	
	set diff_lat [expr $lat_a - $lat_b]
	set diff_lng [expr $lng_a - $lng_b]
	
	set a [expr sin(($diff_lat)/2)**2 + cos($lat_a) * cos($lat_b) * sin($diff_lng/2)**2]
	set c [expr 2 * atan2(sqrt($a), sqrt(1-$a))]
	
	set x [expr $diff_lng * cos(($lat_a + $lat_b)/2)]
	set y  $diff_lat
	
	set pythagoran_dist [expr $R * sqrt($x**2 + $y**2)]
	set haversine_dist [expr $R * $c]
	
	dict set distance pythagoran $pythagoran_dist
	dict set distance haversine $haversine_dist
	return $distance
}

proc open_cage_api {city} {

	set key "4146c071b0124894bb52148d0d6eee17"
	set query_str "http://api.opencagedata.com/geocode/v1/json?key=$key&q=$city&pretty=1"
	
	set handle [::http::geturl $query_str]
	set body [::http::data $handle]
	
	return $body
}

proc get_coord {city} {
	puts "Getting Geo-cordinates for the city of $city..."
	
	set json [::json::json2dict [open_cage_api $city]]
	set results [dict get $json results]
	
	# if we get some results for the city
	if {[llength $results] > 0} {
		set result [lindex $results 0]
		set geometry [dict get $result geometry]
	
		set lat [dict get $geometry lat]
		set lng [dict get $geometry lng]
	
		dict set coord lat $lat
		dict set coord lng $lng
	
		puts "The city of $city is located at $lat latitude, $lng longitude."
		return $coord
	} else {
		puts "Invalid city: $city"
		return false
	}
}

# CLI
if {$argc != 2 && $argc != 3} {
	puts "Incorrect usage!"
	puts "Correct usage: tlcsh distance_between_two_cities.tcl CityA CityB \[km/m/mil/ft\] "
} else {
	if {$argc == 3} {
		set units [lindex $argv 2]
	} else {
		set units "km"
	}
	set city_a [lindex $argv 0]
	set city_b [lindex $argv 1]
	
	set city_a_coord [get_coord $city_a]
	set city_b_coord [get_coord $city_b]
	set R 0.0
	
	switch $units {
		"m" {
			set R 6371.0E3
		}
		"mil" {
			set R 3958.8
		}
		"ft" {
			set R 20.902E6
		}
		"km" {
			set R 6371.0
		}
		default {
			puts "Units of the type $units are not supported!"
			puts "Calculating with km instead"
			set R 6371.0
			set units "km"
		}
	}
	
	set distance [calc_distance $city_a_coord $city_b_coord $R]
	set pythagoran_dist [dict get $distance pythagoran]
	set haversine_dist [dict get $distance haversine]
	
	puts "$city_a and $city_b have a distance of: Pythagoran $pythagoran_dist $units and Haversine $haversine_dist $units"
}
