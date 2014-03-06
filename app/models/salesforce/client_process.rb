Salesforce::Private.const_set 'ClientProcess', Salesforce.client.materialize('ClientProcess_kav')

class Salesforce::ClientProcess < Salesforce::Private::ClientProcess
  include Salesforce::Searchable
end
