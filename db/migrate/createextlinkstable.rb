
class CreateExtLinksTable < ActiveRecord::Migration
	        def up
			create_table :ext_links do |t|
				t.string :url
				t.string :path
				t.int	 :topsite_id
			end
			puts 'ran up method'

		end

		def down
			drop_table :ext_links
			puts 'ran down method'
		end

end

