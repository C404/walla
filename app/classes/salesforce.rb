module Salesforce
  Private = Module.new

  def self.client
    @client ||= begin
      client = Databasedotcom::Client.new client_id: ENV['SF_CONSUMER_KEY'], client_secret: ENV['SF_CONSUMER_SECRET']
      client.authenticate username: ENV['SF_USERNAME'], password: ENV['SF_PASSWORD']
      client
    end
  end
end
