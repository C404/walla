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
  class << self
    def query(q)
      # Removing user mentions from query :)
      q = q.gsub /(@\w*)/, ''

      begin
        result = JSON.parse RestClient.post("#{ENV['WALLASE_URL']}/ask", {message: q, user: 'bite42estunGo'}.to_json, :content_type => "application/json; charset=ASCII", :accept => :json)
        result['recommended'].map do |r|
          Hashie::Mash.new r
        end
      rescue
        Rails.logger.error "Rescue from exception in AxaDocument.query: #{$!}. Stacktrace: "
        Rails.logger.error $!.backtrace.join("\n")
        Array.new
      end
    end

  end
end
