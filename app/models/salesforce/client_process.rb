Salesforce.const_set 'ClientProcess', Salesforce.client.materialize('ClientProcess__kav')

class Salesforce::ClientProcess
  include Salesforce::Searchable

  def url
    "https://eu2.salesforce.com/articles/ClientProcess/#{self.UrlName}"
  end
end
