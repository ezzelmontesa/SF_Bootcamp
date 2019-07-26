global class ProgrammingExercise_Sched implements Schedulable{
    
    List<String> email = new List<String>{'emontesa@deloitte.com'};
        String htmlBody = '<table border = "1" ><th>Account Name<th><th>Account Total Budget<th>';
    
    global void execute(SchedulableContext sc){
        List<Account> parentAccList = new List<Account>();
        parentAccList = [SELECT ID, Name, Total_Budget__c, IsParent__c FROM Account WHERE IsParent__c = true AND Total_Budget__c > 1000000];      
        
        for(Account parentAcc : parentAccList){
            htmlBody += '<tr><td>' + parentAcc.Name + '</td><td>' + parentAcc.Total_Budget__c + '</td></tr>';
        }
        htmlBody += '</table>';
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(email);
        mail.setSubject('Ezzel : Account Budget');
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}