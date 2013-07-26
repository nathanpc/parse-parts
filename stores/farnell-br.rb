#!/usr/bin/env ruby -wKU

# farnell-br.rb
# Newark Farnell Brazil handler.
#
# Nathan Campos <nathanpc@dreamintech.net>

require 'rubygems'
require 'term/ansicolor'

class Farnell
	def initialize(input, output)
		@invoice = File.read(input)
		@output_file = output
	end

	private:
		def parse_html
			# Create a Document and get the correct table.
			doc = Nokogiri::HTML(File.read("farnell\ 2.html"))
			table = doc.css("table.border_right_left_verde > tbody")[0]

			table.css("tr").each do |row|
				puts row + "\n\n\n"
			end
		end

	public:
		#
end