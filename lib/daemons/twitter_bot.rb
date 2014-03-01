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

while($running) do

  begin
    puts "Creating Bot::Walla and Clients"
    client = TwitterFactory.create_client
    stream = TwitterFactory.create_streaming_client
    bot    = Bot::Walla.new(client)

    puts "Listening to stream..."
    stream.user do |object|
      bot.on_event(object)
    end
  rescue
    Rails.logger.error "We got an exception #{$!} of class #{$!.class}"
    Rails.logger.error "--> Here the trace:\n#{$!.backtrace.join("\n")}"
  end

  Rails.logger.info "This daemon is still running at #{Time.now}.\n"

  sleep 5
end
