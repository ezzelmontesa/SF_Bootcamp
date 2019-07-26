({
	myAction : function(component, event, helper) {
		
	},
    
    searchFlight : function(component, event, helper) {
        var flightFrom = component.get("v.flightFrom");
        var flightTo = component.get("v.flightTo");
        var departDate = component.get("v.departDate");
        
        var searchEvent = $A.get("e.c:FlightSearchEvent");
        searchEvent.setParams({
            flightFrom : flightFrom,
            flightTo : flightTo,
            departDate : departDate
        });
        searchEvent.fire();
	}
})