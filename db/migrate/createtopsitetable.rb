
class CreateTopSitesTable < ActiveRecord::Migration
	def up
		create_table :top_sites do |t|
			t.string :url
		end
		puts 'ran up method'

		TopSites.create url: 'www.example.com'
	end

	def down
		drop_table :top_sites
		puts 'ran down method'
	end

end

