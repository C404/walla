class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      # The alphanumerical id for this tweet (/go/3gFe4)
      t.string :key
      # The account of the customer on the plateform (twitter)
      t.string :account
      # The request/msg/question of the customer
      t.string :message
      # The url of the message on the platform (twitter)
      t.string :message_url
      # The url to display as an answer to this request/msg/question
      t.string :answer_url
      # The AXA agent assigned to this tweet
      t.string :agent_account
      # The unique id of the answer on Chatter
      t.integer :chatter_msg_id
      # The ip address of the customer
      t.string :customer_ip

      t.timestamps
    end

    add_index :tweets, :key, unique: true
  end
end
