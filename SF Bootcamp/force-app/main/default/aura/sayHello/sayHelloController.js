({
	sayHello : function(component, event, helper) {
        var inputMessage = component.get('v.inputMessage');
		helper.pleaseSayHello(component, inputMessage);
	}
})