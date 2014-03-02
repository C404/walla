class CreateProviders < ActiveRecord::Migration
	def self.up
		create_table :providers do |t|
			t.boolean :expires
			t.datetime :expires_at
			t.integer :user_id
			t.string :token
			t.string :refresh_token
			t.string :provider
			t.string :uid
			t.string :email

			t.timestamps
		end
		add_index :providers, :user_id

	end

	def self.down
		drop_table :providers
	end
end
