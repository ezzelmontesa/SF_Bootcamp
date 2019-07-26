({
    init : function(component, event, helper) {
        var modal = component.find("exampleModal");
    },
    
    getFlightDetails : function(component, event, helper) {
        var params = event.getParams();
        var flightDetails = params.flightDetails;
        console.log(flightDetails[0].Id + " YEY");
        component.set("v.flightBookedID", flightDetails[0].Id );
        
        var action = component.get("c.getFlightSelected");
        action.setParams({
            "flightID" : flightDetails[0].Id
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set("v.flightBooked", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    hideModal : function(component, event, helper) {
        var modalEvt = $A.get("e.c:OpenCloseModal");
        modalEvt.setParams({
            "isModalOpen" : false
        });
        modalEvt.fire();
    },
    
    checkBooking : function(component, event, helper){
        var passengerFName = component.get("v.passangerFirstName");
        var passengerLName = component.get("v.passangerLastName");
        var passengerEmail = component.get("v.passangerEmail");
        var returnValue = "ERROR";
        if(passengerEmail == null || passengerFName == null || passengerLName == null){
            helper.showToast(component, event, returnValue);
        }else{
            var action = component.get("c.checkContact");
            action.setParams({
                "fName" : passengerFName,
                "lName" : passengerLName,
                "passEmail" : passengerEmail
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log(state);
                if (state === "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    var flightID = component.get("v.flightBookedID");
                    helper.finalizeBooking(component, returnValue, flightID);
                    console.log(returnValue);
                }
            });
            $A.enqueueAction(action);
        }
        
    }
})