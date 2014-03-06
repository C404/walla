Salesforce::Private.const_set 'User', Salesforce.client.materialize('User')

class Salesforce::User < Salesforce::Private::User
end
