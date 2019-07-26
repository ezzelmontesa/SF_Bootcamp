({
    fetchData : function(component, event, helper) {
        var params = event.getParams();
        var flightFrom = params.flightFrom;
        var flightTo = params.flightTo;
        var departDate = params.departDate;
        console.log(flightFrom + ' ' + flightTo + ' ' + departDate);
        
        if(flightFrom == null || flightTo == null || departDate == null){
            this.showToast(component, event);
        }else{
            component.set("v.column", [
                {label: 'Flight Number', fieldName: 'Flight_Number__c', type: 'text'},
                {label: 'Depart/Arrive', fieldName: 'Depart_Arrive__c', type: 'text'},
                {label: 'Departure Date', fieldName: 'Departure_Date__c', type: 'date'},
                {label: 'Departure Time', fieldName: 'Departure_Time__c', type: 'date', typeAttributes: {hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true}},
                {label: 'Arrival Time', fieldName: 'Arrival_Time__c', type: 'date', typeAttributes: {hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true}},
                {label: 'Price', fieldName: 'Flight_Price__c', type: 'currency', typeAttributes: { currencyCode: 'USD', maximumSignificantDigits: 5}},
                {label: 'Seats Available', fieldName: 'Seats_Available__c', type: 'number'}
            ]);
            
            var action = component.get("c.getFlightwithFilters");
            action.setParams({
                "origin" : flightFrom,
                "destination" : flightTo,
                "departure" : departDate
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log(state);
                if (state === "SUCCESS") {
                    component.set("v.flightList", response.getReturnValue());
                    if(response.getReturnValue() == 0){
                        component.set("v.hasNoResults", true);	
                    }else{
                        component.set("v.hasNoResults", false);
                    }
                    console.log(response.getReturnValue());	
                }
            });
            $A.enqueueAction(action);
        }
        
        
        
    },
    
    initData : function(component, event, helper){
        component.set("v.column", [
            {label: 'Flight Number', fieldName: 'Flight_Number__c', type: 'text'},
            {label: 'Depart/Arrive', fieldName: 'Depart_Arrive__c', type: 'text'},
            {label: 'Departure Date', fieldName: 'Departure_Date__c', type: 'date'},
            {label: 'Departure Time', fieldName: 'Departure_Time__c', type: 'date', typeAttributes: {hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true}},
            {label: 'Arrival Time', fieldName: 'Arrival_Time__c', type: 'date', typeAttributes: {hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true}},
            {label: 'Price', fieldName: 'Flight_Price__c', type: 'currency', typeAttributes: { currencyCode: 'USD', maximumSignificantDigits: 5}},
            {label: 'Available Seats', fieldName: 'Seats_Available__c', type: 'number'}
        ]);
        
        var action = component.get("c.getFlights");
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                component.set("v.flightList", response.getReturnValue());
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast : function (component, event, returnValue){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            title: 'ERROR',
            message: 'Please enter valid values.'
        });
        toastEvent.fire();        
    }
})