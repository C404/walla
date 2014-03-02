module Salesforce::Searchable
  extend ActiveSupport::Concern

  included do
    puts "Included !"
  end

  module ClassMethods
    def analyzed_search(text)
      analyzed = Api::Analyzer.analyze(text)
      analyzed ||= text

      query = "FIND {*#{analyzed}*} " +
        "RETURNING #{self.name.demodulize}__kav" +
        "(Id WHERE PublishStatus='Online' AND Language='fr')"
      Rails.logger.debug "Executing query : #{query}"
      Salesforce.client.search query
    end
  end
end
