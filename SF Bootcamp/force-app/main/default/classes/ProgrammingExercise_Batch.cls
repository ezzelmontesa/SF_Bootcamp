global class ProgrammingExercise_Batch implements Database.Batchable<SObject>{
	
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator('SELECT ID, Name, IsParent__c FROM Account WHERE IsParent__c = true');
    }
    global void execute(Database.BatchableContext bc, List<Account> result){
        List<Account> childAccounts = new List<Account>();
        for(Account acct : result){
            for(Integer i = 1; i <= 5; i++){
                Account childAccount = new Account(Name = acct.Name + ' - Child ' + i, Parent_Account__c = acct.ID);
                childAccounts.add(childAccount);
            }
        }
        insert childAccounts;
    }
    global void finish(Database.BatchableContext bc){
        system.debug('Done making children');
        System.enqueueJob(new ProgrammingExercise_Queueable(100000.00, 300000.00));
    }
}