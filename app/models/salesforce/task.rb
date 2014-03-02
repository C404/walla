Salesforce::Private.const_set 'Task', Salesforce.client.materialize('Task')

class Salesforce::Task < Salesforce::Private::Task
end
