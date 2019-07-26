({
	init : function(component, event, helper) {
        component.set("v.isFlightSelected", true);
        component.set("v.hasNoResults", true);
	},
    
    handleSearchFlights : function(component, event, helper) {   
        helper.fetchData(component, event, helper);
	},
    
    openModal : function(component, event, helper) {
		var compModal = component.find('createBookingModal');
        component.set("v.isModalOpen", true);
        var selectedFlight = component.get("v.selectedFlight");
        var sendFlightDetails = $A.get("e.c:SendFlightDetailsEvent");
        sendFlightDetails.setParams({
            flightDetails : selectedFlight
        });
        sendFlightDetails.fire();
        
	},
    
    closeModalHandler : function(component, event, helper){
        component.set("v.isModalOpen", false);
    },
    
    getSelectedFlight : function(component, event, helper){
        component.set("v.isFlightSelected", false);
        var getFlight = event.getParam('selectedRows');
        component.set("v.selectedFlight", getFlight);
        var selectedFlight = component.get("v.selectedFlight");   
        console.log(selectedFlight[0].Flight_Number__c); 
    }
})