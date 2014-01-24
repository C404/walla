class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :customer_account
      t.string :customer_msg
      t.string :msg_url
      t.string :service_page
      t.string :agent_account
      t.string :bitly
      t.integer :chatter_id
      t.string :customer_ip
      t.string :answered_url

      t.timestamps
    end
  end
end
