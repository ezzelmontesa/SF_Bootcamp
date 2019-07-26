({
    createDonation : function(component, newDonation) {
        var action = component.get('c.saveDonation');
        action.setParams({
            "donation" : newDonation
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                var donations = component.get("v.donationList");
                donations.push(response.getReturnValue());   
                component.set("v.newDonation.Donor_Name__c", "" );
                component.set("v.newDonation.Amount__c", "1" );
                component.set("v.newDonation.Donation_Date__c", "" );
                component.set("v.newDonation.Note__c", "" );
            }
        });
        $A.enqueueAction(action);
    }   
    
})