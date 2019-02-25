({
    executeAction: function(cmp, action, callback) {

        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {

                var state = response.getState();

                if (state === "SUCCESS") {
                    var retVal=response.getReturnValue();
                    resolve(retVal);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            reject(Error("Error message: " + errors[0].message));
                        }
                    }
                    else {
                        reject(Error("Unknown error"));
                    }
                }
            });
            $A.enqueueAction(action);
        });
    },

    doInit : function(cmp, event, helper) {
        alert('The Opportunity Record ID is: ' + cmp.get("v.recordId"));
    },

    shareRecord : function(cmp, event, helper) {
        
        var action = cmp.get('c.manualRecordShare');
        var rId = cmp.get("v.value");
        alert('testing: ' + rId);

        debugger;
        action.setParams(
            { 
                recordId : cmp.get("v.recordId"),
                userOrGroupId : rId
            }
        );

        var p = helper.executeAction(cmp, action);
        p.then(
            $A.getCallback( function(response) {
                alert(JSON.parse(response));
                cmp.set('v.contact', response);
                return response;
            })
        ).catch(
            $A.getCallback(function(error) {
                alert('Error retrieving user list:  ' + error.message);
            })
        )
    }
})
