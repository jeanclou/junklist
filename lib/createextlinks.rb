require 'open-uri'
require 'nokogiri'

require_relative 'extlinks.rb'
require_relative 'topsites.rb'


class CreateExtLinks
	def initialize
		puts "INIT"
		TopSites.all.each do |top|
			url = "http://" +  top.url
			page = Nokogiri::HTML(open(url))
			links = page.xpath("//@href")
			links.each do |link|
				uri = URI.parse(link)
				puts "scheme=" + uri.scheme if uri.scheme != nil
				puts "host=" + uri.host if uri.host != nil
				puts "path=" + uri.path if uri.path != nil
				puts "query=" + uri.query if uri.query != nil
			end
		end
	end

end

