#! /usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development" # "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

client = Databasedotcom::Client.new(client_id: ENV['SF_CONSUMER_KEY'],
  client_secret: ENV['SF_CONSUMER_SECRET'] )
token = client.authenticate(username: 'julien.ballet.pro@gmail.com',
  password: 'qweasd4242')

puts client.list_sobjects.sort

Sf = Module.new
['User', 'Task'].each do |klass|
  Sf.const_set klass, client.materialize(klass)
end


