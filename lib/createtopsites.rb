require 'open-uri'
require 'nokogiri'
require_relative 'topsites.rb'

PAGES = [ "", ";1", ";2", ";3", ";4", ";5", ";6", ";7", ";8", \
";9", ";10", ";11"]
BASE_URL="http://www.alexa.com/topsites/countries"
COUNTRY = "FR"


class CreateTopSites
	def initialize
		table = []

		# il faudra au final un objet source pour
		# etre independant des changements alexa
		# et pouvoir ajouter d'autres sources
		PAGES.each do |page|
			url = BASE_URL + page + "/" + COUNTRY
			doc = Nokogiri::HTML(open(url))
			sites = doc.css("p.desc-paragraph")
			table.concat( sites.inner_text.split("\n"))
		end

		# Clean the table
		table = table.reject { |a| a == "" }

		table.each do |line|
			url = self.get_protocol(line.downcase) + line.downcase
			# search for entry
			top = TopSites.where("url = ?", url)
			if top.blank?
				# add entry
				puts "Add " + url + " in database"
				top = TopSites.new
				top.url = url
				# should catch exception
				top.save
			else
				puts "Site " + url + " already in database"
			end
		end
	end

	# Hack up pourri pour contourner les problemes
	# de redirections et de ports tcp
	def get_protocol(domain)
		# should try dns request on www before
		p = 'https://'

		begin
			u = open(p + domain)
			# should close u
		rescue Exception => e
			p = 'http://'
		end
		return p
	end
end



