Salesforce::Private.const_set 'Account', Salesforce.client.materialize('Account')

class Salesforce::Account < Salesforce::Private::Account
end
