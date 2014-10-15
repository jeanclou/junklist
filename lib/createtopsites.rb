require 'socket'
require 'open-uri'
require 'nokogiri'
require_relative 'topsites.rb'

include Socket::Constants

PAGES = [ "" ]#, ";1", ";2", ";3", ";4", ";5", ";6", ";7", ";8", \
#";9", ";10", ";11"]
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
			url = self.get_protocol(self.get_domain(line.downcase))
			# search for entry
			top = TopSites.where("url = ?", url)
			if top.blank?
				# add entry
				puts "Add " + url + " in database"
				uri = URI.parse(url)
				top = TopSites.new
				top.url = url
				top.scheme = uri.scheme
				top.host = uri.host
				top.path = uri.path
				top.query = uri.query
				# should catch exception
				top.save
			else
				puts "Site " + url + " already in database"
			end
		end
	end

	def get_protocol(domain)
		begin
			socket = Socket.new( AF_INET, SOCK_STREAM )
			sockaddr = Socket.pack_sockaddr_in( 443, domain )
			socket.connect( sockaddr )
			socket.close()
			p = 'https://' + domain
		rescue Exception => e
			begin
				socket = Socket.new( AF_INET, SOCK_STREAM )
				sockaddr = Socket.pack_sockaddr_in( 80, domain )
				socket.connect( sockaddr )
				socket.close()
				p = 'http://' + domain
			rescue Exception => e
				puts "CRITICAL: can\'t open socket for #{domain}"
				puts "#{e}"
			end
		end
		return p
	end

	def get_domain(domain)
		begin
			Socket.getaddrinfo(domain, nil)
		rescue Exception => e
			return domain
		end
		return 'www.' + domain
	end
end



