public with sharing class MyComponentController {
    
	@AuraEnabled
    public static List<Account> getAccounts(){
        return [SELECT Name FROM Account];
    }
}