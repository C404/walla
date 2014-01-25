class Tweet < ActiveRecord::Base

  def set_user_ip remote_ip
    self.customer_ip = remote_ip
    self.save!
  end

  def full_name
    client = Twitter::REST::Client.new do |config|
      config.consumer_key         = ENV['TWITTER_API_KEY']
      config.consumer_secret      = ENV['TWITTER_API_SECRET']
      config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret  = ENV['TWITTER_ACCESS_SECRET']
    end

    begin
      client.user(self.account).name.underscore.gsub('_', ' ')
    rescue
      ""
    end
  end
end
