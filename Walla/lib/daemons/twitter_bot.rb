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

api = Faraday.new(:url => 'http://192.168.0.20:3000') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter Faraday.default_adapter   # make requests with Net::HTTP
  #faraday.adapter :rack
end

me = client.user(skip_status: true)

while($running) do

  begin
    puts "Listening to stream..."
    stream.user do |object|
      case object
      when Twitter::Tweet
        if object.user.screen_name != me.screen_name and object.in_reply_to_status_id.nil?
          response = api.post '/tweets.json', tweet: {
            account:      object.user.screen_name,
            message:      object.text,
            message_url:  object.url
          }
          if response.status == 201
            data = JSON.parse(response.body)['tweet']
            url = "http://localhost:3000/go/#{data['id']}"
            client.update("@#{object.user.screen_name},#{rand 999}, #{url}",
              in_reply_to_status: object)
          else
            client.update("Désolé @#{object.user.screen_name},#{rand 999}, je ne sais pas comment vous aider",
              in_reply_to_status: object)
          end
        end
      when Twitter::DirectMessage
        puts "It's a direct message!"
      when Twitter::Streaming::StallWarning
        warn "Falling behind!"
      else
        Rails.logger.error "We got an #{object.class} : #{object.inspect}"
      end
    end
  rescue
    Rails.logger.error "We got an exception #{$!} of class #{$!.class}"
    Rails.logger.error "--> Here the trace:\n#{$!.backtrace.join("\n")}"
  end

  Rails.logger.info "This daemon is still running at #{Time.now}.\n"

  sleep 5
end
