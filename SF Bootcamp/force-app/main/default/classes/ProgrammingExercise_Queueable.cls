public class ProgrammingExercise_Queueable implements Queueable{
    
    Decimal min;
    Decimal max;
    
    public ProgrammingExercise_Queueable(Decimal min, Decimal max){
        this.min = min;
        this.max = max;
    }
    
    public void execute(QueueableContext qc){
        List<Account> accountList = new List<Account>();
        List<Account> accList = new List<Account>();
        accountList = [SELECT ID, Name, Budget__c, (SELECT ID, Name, Budget__c FROM Accounts__r) FROM Account WHERE IsParent__c = true];
        for(Account parentAcc : accountList){
            parentAcc.Budget__c = (math.random() * max - min) + min; 
            for(Account childAcc : parentAcc.Accounts__r){
                childAcc.Budget__c = (math.random() * max - min) + min; 
                accList.add(childAcc);
            }
        }
        accountList.addAll(accList);
        update accountList;
        
        ProgrammingExercise_Future.ProgrammingExercise_Future();
    }
}