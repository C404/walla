class RemovesChatterIdFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :chatter_msg_id
  end
end
