({
    doInit : function(component, event, helper){
        
        var action = component.get('c.getDonations');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.donationList", response.getReturnValue()); 
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
        
        var action2 = component.get('c.getTotalDonations');
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.totalDonation", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action2);
    },
    
    setInputs : function(component, event, helper) {        
        
        var validDonation = component.find('donationForm').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(validDonation) {
            var newDonation = component.get('v.newDonation'); 
            var initEvent = component.getEvent("updateList");
            console.log("Create Donation: " + JSON.stringify(newDonation));
            helper.createDonation(component, newDonation);
            initEvent.fire();      
        }
    }
})