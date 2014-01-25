#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development" # "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do
  $running = false
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key         = ENV['TWITTER_API_KEY']
  config.consumer_secret      = ENV['TWITTER_API_SECRET']
  config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret  = ENV['TWITTER_ACCESS_SECRET']
end

stream = Twitter::Streaming::Client.new do |config|
  config.consumer_key         = ENV['TWITTER_API_KEY']
  config.consumer_secret      = ENV['TWITTER_API_SECRET']
  config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret  = ENV['TWITTER_ACCESS_SECRET']
end

api = Faraday.new(:url => 'http://localhost:3000') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter Faraday.default_adapter   # make requests with Net::HTTP
  #faraday.adapter :rack
end

me = client.user(skip_status: true)

while($running) do

  puts "Listening to stream..."
  stream.user do |object|
    case object
    when Twitter::Tweet
      unless object.user.screen_name == me.screen_name
        api.post '/tweets.json', tweet: {
          customer_account: object.user.screen_name,
          customer_msg:     object.text,
          msg_url:          object.url
        }
        client.update("@#{object.user.screen_name} Thank you for tweeting me #{rand 999999}",
          in_reply_to_status: object)
      end
    when Twitter::DirectMessage
      puts "It's a direct message!"
      puts "--> #{object.text}"
      puts object.sender.screen_name
    when Twitter::Streaming::StallWarning
      warn "Falling behind!"
    else
      puts object.class
    end
  end

  # Replace this with your code
  Rails.logger.auto_flushing = true
  Rails.logger.info "This daemon is still running at #{Time.now}.\n"

  sleep 5
end
