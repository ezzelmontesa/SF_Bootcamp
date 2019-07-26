({
	handleSend : function(component, event, helper) {
		var params = event.getParams();
        var messages = params.message;
        
        alert('Received message: ' + messages);
	},
    
    doGreet: function(component, event, helper){
        component.find('greeter').saySendMessage();
    }
})