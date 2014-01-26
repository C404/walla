# STOPWORDS = %w{je tu il nous vous ils le la les un une des a ai et
#   est ayons ayez ça http j'ai https bonjour pouvez pouvoir
#   aider aide peux peut possible axa}

# AXA_INDEX = Tire.index 'axa_documents' do
#   settings = {
#     analysis: {
#       analyzer: {
#         axa_analyzer: {
#           type: 'custom',
#           tokenizer: 'standard',
#           language: 'French',
#           stopwords: STOPWORDS,
#           filter: %w{lowercase stop_francais asciifolding elision}
#         },
#         snowball_fr: {
#           type: 'snowball',
#           language: 'French'
#         },
#       },
#       filter: {
#         stop_francais: {
#           type: 'stop',
#           stopwords: STOPWORDS
#         }
#       }
#     }
#   }

#   create(settings: settings,
#     mappings: {
#       axa_document: {
#         properties: {
#           url:     { type: 'string', index: 'not_analyzed' },
#           title:   { type: 'string', boost: 2.0, :analyzer => 'axa_analyzer' },
#           content: { type: 'string', analyzer: 'axa_analyzer' },
#         }
#       }
#     })
# end

class AxaDocument
  def initialize(hash)
    @data = hash
  end

  def type
    'axa_document'
  end

  def to_indexed_json
    @data.to_json
  end

  def store!
    # AXA_INDEX.store self
    # AXA_INDEX.refresh
  end

  class << self
    def recreate_index
      # AXA_INDEX.delete
    end

    def query(q)
      puts 'query'
      puts q
      q = q.gsub /(@\w*)/, ''
      # url: p[:url], title: p[:content], body: p[:body]
      begin
        result = JSON.parse RestClient.post("#{ENV['EXXO_GO_URL']}/ask", {message: q, user: 'bite42estunGo'}.to_json, :content_type => "application/json; charset=ASCII", :accept => :json)    
      rescue
        puts 'error'
        result = []
      end
      result.map do |r|
        Hashie::Mash.new r
      end
      # puts result.inspect
      # Hashie::Mash.new result
      # return [] unless q and q.present?
      # q = AXA_INDEX.analyze q, analyzer: 'axa_analyzer'
      # q = q['tokens'].map { |i| i['token' ]}.join " "
      # puts "Query is = '#{q}'"
      # return [] unless q.present?

      # Tire.search('axa_documents') do
      #   query do
      #     string q
      #   end
      # end.results
      result
    end

  end
end
