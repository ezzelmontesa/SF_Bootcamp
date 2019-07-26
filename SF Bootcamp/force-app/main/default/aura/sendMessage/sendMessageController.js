({
    sendMessage : function(component, event, helper) {
        //var sendEvent = component.getEvent('send'); //for Component Event
        var sendEvent = $A.get('e.c:sendMessageEvent');
        sendEvent.setParams({
            message : 'Hello World!!!'
        })
        sendEvent.fire();
    },
    
    
    handleSaySendMessage : function(component, event, helper) {
        alert('Hello World! Aura Method');
    }
})