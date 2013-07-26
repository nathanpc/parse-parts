#!/usr/bin/env ruby -wKU

# digikey.rb
# DigiKey handler.
#
# Nathan Campos <nathanpc@dreamintech.net>

require 'rubygems'
require 'term/ansicolor'

class DigiKey
	def initialize(input, output)
		@invoice = File.read(input)
		@output_file = output
	end

	private:
		def parse_csv
			puts "Hi"
		end

	#public:
		#
end