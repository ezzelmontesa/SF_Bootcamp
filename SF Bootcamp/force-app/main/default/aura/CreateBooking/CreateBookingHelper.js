({
    finalizeBooking : function(component, returnValue, flightID) { 
        var action = component.get("c.finalizeBooking");
        action.setParams({
            "passengerID" : returnValue,
            "flightID" : flightID,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                this.redirectToRecord(returnValue);
                this.showToast(returnValue);
                this.sendEmail(component, returnValue);
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function (component, event, returnValue){
        var toastEvent = $A.get("e.force:showToast");
        if(returnValue == "ERROR"){            
            toastEvent.setParams({
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                title: 'ERROR',
                message: 'Please enter valid values.'
            });
            toastEvent.fire();
        }else{
            toastEvent.setParams({
                duration:' 5000',
                key: 'info_alt',
                type: 'success',
                title: 'Success!',
                message: 'You have successfully booked your flight!'
            });
            toastEvent.fire();
        }
        
    },
    
    redirectToRecord : function (returnValue) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": returnValue,
            "slideDevName": "Detail"
        });
        navEvt.fire();
    },
    
    sendEmail : function (component, returnValue){
        console.log("SENDING...");
        var sendEmail = component.get("c.sendEmail");
        sendEmail.setParams({
            "bookingID" : returnValue
        });
        sendEmail.setCallback(this, function(response){
            var state = response.getState();
            console.log(state + " State");
            if(state === "SUCCESS"){
                console.log("SENT");
            }	
        });
        $A.enqueueAction(sendEmail);
        
    }
    
})