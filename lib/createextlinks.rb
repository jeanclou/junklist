require 'open-uri'
require 'nokogiri'

require_relative 'extlinks.rb'
require_relative 'topsites.rb'


class CreateExtLinks
	def initialize
		TopSites.all.each do |top|
			#url = "https://" +  top.url
			puts "PARSE " + top.url + " with id=" + top.id.to_s
			begin
				page = Nokogiri::HTML(open(top.url))
				links = page.xpath("//@href")
				links.each do |link|
					begin
						uri = URI.parse(link)
						puts "LINK " + link
						print " scheme=" + uri.scheme if uri.scheme != nil
						print " host=" + uri.host if uri.host != nil
						print " path=" + uri.path if uri.path != nil
						print " query=" + uri.query if uri.query != nil
						puts "\n"
						# est-ce une url?
						if uri.scheme != nil
							# is external link?
							if /#{top.host}/.match(uri.host)
								ext = ExtLinks.new
								ext.top_id = top.id
								ext.host = uri.host
								ext.path = uri.path
								ext.scheme = uri.scheme
								ext.save
							end
						end
					rescue URI::InvalidURIError => e
						puts "URI " + link + " is considered as invalid"
						puts "error: #{e}"
					end
				end
			rescue
				puts "URL " + top.url + "cannot be parsed"
			end
		end
	end

end

