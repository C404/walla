class ReplaceStatusUrlByTweetId < ActiveRecord::Migration
  def up
    add_column :tweets, :status_id, :integer
    Tweet.all.each do |tweet|
      next unless tweet.message_url
      tweet.status_id = tweet.message_url.split('/').last.to_i
      tweet.save
    end
    remove_column :tweets, :message_url
  end

  def down
    add_column :tweets, :message_url, :string
    Tweet.all.each do |tweet|
      next unless tweet.status_id
      tweet.message_url = "http://twitter.com/#{tweet.account}/status/#{tweet.status_id}"
      tweet.save
    end
    remove_column :tweets, :status_id
  end
end
