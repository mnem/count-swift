#!/usr/bin/env ruby

# Tonight I'm bored, so here I am, scripting
# the poking of ipas to see if they have
# Swift libs. This is what happens when
# Windows 7 is still installing updates
# in a fresh VM after FIVE HOURS. Sigh.
#
# -- https://github.com/mnem

# Let's make a great big ugly assumption that the ipa files are in the standard place
ITUNES_APP_ROOT = File.join(ENV['HOME'], 'Music/iTunes/iTunes Media/Mobile Applications', '*.ipa')

# Grab all the ipas as a list
IPAS=Dir.glob ITUNES_APP_ROOT

# Check all the ipas for evidence of embedded swift libs
puts "Scaning #{IPAS.count} IPAs in #{ITUNES_APP_ROOT}"
swift_libs = []
swift_ipas = []
IPAS.each do |ipa|
	# Yep, we're still processing, look at the pretty dots!
	print '.'

	# List the contents of the ipa and search for some likely swift frameworks.
	libs = `unzip -l \"#{ipa}\" | grep -i 'libswift.*\.dylib'`
	if libs.length > 0
		# Has some swift
		swift_ipas << ipa

		# Store lib names in a hideously inefficient way
		libs = libs.split "\n"
		swift_libs << libs.map do |lib|
			lib_parts = lib.split ' '
			lib_parts.slice!(0..2)
			File.basename lib_parts.join(' ') 
		end
	end
end

# Output some stats
puts "\n\nUnique Swift libs found:"
swift_libs.flatten.uniq.sort.each { |lib| puts "  #{lib}" }
puts "\nIPAs containing Swift libs:"
swift_ipas.sort.each { |ipa| puts "  #{File.basename(ipa, '.ipa')}" }
puts "\nFrom #{IPAS.count} apps, #{swift_ipas.count} (#{(Float(swift_ipas.count)/IPAS.count*100.0).round}%) contain libswift*.dylib frameworks"
