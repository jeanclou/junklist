#!/usr/bin/env ruby

require 'active_record'
require_relative '../lib/createtopsites.rb'
require_relative '../lib/createextlinks.rb'

Dir.glob('../lib/*').each do |folder|
	Dir.glob(folder +"/*.rb").each do |file|
		require file
	end
end

ActiveRecord::Base.establish_connection(
	:adapter	=>	'sqlite3',
	:database	=>	'db/development.db'
)

CreateTopSites.new()
#CreateExtLinks.new()


