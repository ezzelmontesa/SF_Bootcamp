global class myFirstBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator('SELECT ID, Name FROM Account');
    }
    global void execute(Database.BatchableContext bc, List<Account> result){
        for(Account acct : result){
            system.debug(acct.Name);
        }
    }
    global void finish(Database.BatchableContext bc){
        system.debug('I am finish');
    }
}