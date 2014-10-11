require 'open-uri'
require 'nokogiri'
require_relative './topsites.rb'

PAGES = [ "", ";1", ";2", ";3", ";4", ";5", ";6", ";7", ";8", \
";9", ";10"]
BASE_URL="http://www.alexa.com/topsites/countries"
COUNTRY = "FR"


class CreateTopSites
	def initialize
		table = []

		PAGES.each do |page|
			url = BASE_URL + page + "/" + COUNTRY
			doc = Nokogiri::HTML(open(url))
			sites = doc.css("p.desc-paragraph")
			table.concat( sites.inner_text.split("\n"))
		end

		table = table.reject { |a| a == "" }

		table.each do |line|
			top = TopSites.new
			top.url = line.downcase
			top.save
		end
	end
end





#table = []

#PAGES.each do |page|
#	url = BASE_URL + page + "/" + country
#	doc = Nokogiri::HTML(open(url))
#	sites = doc.css("p.desc-paragraph")
#	table.concat( sites.inner_text.split("\n"))
#end

#table = table.reject { |a| a == "" }

#index = 0
#table.each do |line|
#	index = index.next
#	print index, " ", line.inspect.downcase, "\n"
#	sql = "insert into topsites (id,url) values (" + index.to_s \
#		+ ", " + line.inspect.downcase + ")"
#	db.execute(sql)
#end

