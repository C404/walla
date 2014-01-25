class AxaDocument
  INDEX = 'axa_documents'

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
    me = self
    Tire.index INDEX do
      store me
    end
  end

  class << self
    def create_index
      Tire.index AxaDocument::INDEX do
        #delete
        create mappings: {
          axa_document: {
            properties: {
              url:     { type: 'string', index: 'not_analyzed' },
              title:   { type: 'string', boost: 2.0, :analyzer => 'snowball' },
              content: { type: 'string', analyzer: 'snowball' },
            }
          }
        }
      end
    end

    def query(q)
      Tire.search(AxaDocument::INDEX) do
        query do
          string q
        end
      end.results
    end
  end
end
