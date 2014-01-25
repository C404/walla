SF_CLIENT = Databasedotcom::Client.new(client_id: ENV['SF_CONSUMER_KEY'],
  client_secret: ENV['SF_CONSUMER_SECRET'] )
SF_TOKEN = SF_CLIENT.authenticate(username: 'julien.ballet.pro@gmail.com',
  password: 'qweasd4242')

Sf = Module.new
['User', 'Task', 'Account'].each do |klass|
  Sf.const_set klass, SF_CLIENT.materialize(klass)
end
