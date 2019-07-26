public with sharing class DonationsController {
    
    @AuraEnabled
    public static List<Donation__c> getDonations(){
        return [SELECT ID, Donor_Name__c, Amount__c, Donation_Date__c, Note__c FROM Donation__c ORDER BY Amount__c DESC LIMIT 5];
    }
    
    @AuraEnabled
    public static Decimal getTotalDonations(){
        List<Donation__c> totalDonation = [SELECT ID, Amount__c FROM Donation__c];
        Decimal totalAmount = 0;
        for(Donation__c donation : totalDonation){
            totalAmount += donation.Amount__c;
        }
        return totalAmount;
    }
    
    @AuraEnabled
    public static Donation__c saveDonation(Donation__c donation){
        upsert donation;
        system.debug('UPSERT SUCCESS');
        return donation;
    }
}