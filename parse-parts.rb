#!/usr/bin/env ruby -wKU

# parse-parts.rb
# A awesome script to parse your parts orders and build a spreadsheet.
#
# @author Nathan Campos <nathanpc@dreamintech.net>

require 'rubygems'
require 'term/ansicolor'

# Imports all the stores.
require './stores/digikey.rb'
require './stores/farnell-br.rb'

class String
	include Term::ANSIColor
end

# Usage message.
def help
	puts "Usage:"
	puts "    parse-parts store invoice [output-file]"
end

# Run the main function.
if __FILE__ == $0
	if ARGV[1].nil?
		help() 
	else
		case ARGV[0]
			when "digikey"
				# DigiKey Order.
				digikey = DigiKey.new(ARGV[1], ARGV[2])
			when "farnell"
				# Farnell Newark Brazil.
			else
				# No need to explain.
				help()
		end
	end
end