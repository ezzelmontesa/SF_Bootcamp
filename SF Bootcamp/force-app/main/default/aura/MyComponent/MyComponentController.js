({
	doInit : function(component, event, helper) {
		var action = component.get('c.getAccounts');
        action.setCallback(this, function(response){
            if(response.getState() === 'SUCCESS'){
                component.set('v.accounts', response.getReturnValue());
                console.log('accountList: ' + response.getReturnValue());
            }else{
                alert('FAILED TO GET ACCOUNTS');
            }
        });
        $A.enqueueAction(action);
	}
})