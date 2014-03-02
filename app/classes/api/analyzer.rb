# Use ElasticSearch Analyzer to process strings
# Can be use to send query to search engine on which we can't control analyze
class Api::Analyzer
  class << self
    def analyzer
      ENV['ES_ANALYZER']
    end

    def client
      @client ||= Faraday.new(:url => ENV['ES_URL']) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter Faraday.default_adapter   # make requests with Net::HTTP
      end
    end

    def analyze(text)
      begin
        response = client.get do |req|
          req.url "/_analyze", analyzer: analyzer
          req.body = text
        end
        data = JSON.parse response.body
        data['tokens'].map { |t| t['token'] }.join("* *")
      rescue
        nil
      end
    end
  end
end
