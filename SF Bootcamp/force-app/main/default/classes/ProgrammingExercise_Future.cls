public class ProgrammingExercise_Future {
    
    @future
    public static void ProgrammingExercise_Future(){
        List<Account> accountList = new List<Account>();
        List<Account> updatedAccounts = new List<Account>();
        accountList = [SELECT ID, Name, Total_Budget__c, Budget__c, IsParent__c, (SELECT ID, Name, Budget__c FROM Accounts__r) FROM Account WHERE IsParent__c = true];
        for(Account parentAcc : accountList){
            parentAcc.Total_Budget__c = parentAcc.Budget__c;
            for(Account childAcc : parentAcc.Accounts__r){
                parentAcc.Total_Budget__c += childAcc.Budget__c;
            }
            updatedAccounts.add(parentAcc);
        }
        
        update updatedAccounts;
        //System.enqueueJob(new ProgrammingExercise_Sched());
        
        String CRON_exp = '0 37 16 15 7 ? 2019';
        String jobID = system.schedule('TEST', CRON_exp, new ProgrammingExercise_Sched());
    }
}