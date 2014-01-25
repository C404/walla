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


while($running) do

  stream.user do |object|
    case object
    when Twitter::Tweet
      puts "It's a tweet!"
      puts "--> #{object.text}"
    when Twitter::DirectMessage
      puts "It's a direct message!"
      puts "--> #{object.text}"
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
