/**
 * @File Name          : ManualRecordShare_controller.cls
 * @Description        : 
 * @Author             : phUser@phDomain.com
 * @Group              : 
 * @Last Modified By   : phUser@phDomain.com
 * @Last Modified On   : 2/23/2019, 2:21:05 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2/23/2019, 1:19:07 AM   phUser@phDomain.com     Initial Version
**/
public with sharing class ManualRecordShare_controller {

    @AuraEnabled
    public static Boolean manualRecordShare(Id recordId, Id userOrGroupId){

      // Create new sharing object for the custom object Job.
      OpportunityShare recShr  = new OpportunityShare();
   
      // Set the ID of record being shared.
      recShr.OpportunityId = recordId;
        
      // Set the ID of user or group being granted access.
      recShr.UserOrGroupId = userOrGroupId;
        
      // Set the access level.
      recShr.OpportunityAccessLevel = 'Edit';
        
      // Set rowCause to 'manual' for manual sharing.
      // This line can be omitted as 'manual' is the default value for sharing objects.
      //recShr.RowCause = Schema.OpportunityShare.RowCause.Manual;
        
      // Insert the sharing record and capture the save result. 
      // The false parameter allows for partial processing if multiple records passed 
      // into the operation.
      Database.SaveResult sr = Database.insert(recShr,false);

      // Process the save results.
      if(sr.isSuccess()){
         // Indicates success
         return true;
      }
      else {
         // Get first save result error.
         Database.Error err = sr.getErrors()[0];
         
         // Check if the error is related to trival access level.
         // Access level must be more permissive than the object's default.
         // These sharing records are not required and thus an insert exception is acceptable. 
         if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  &&  
                  err.getMessage().contains('AccessLevel')){
            // Indicates success.
            return true;
         }
         else{
            // Indicates failure.
            return false;
         }
       }
   }

   @AuraEnabled
   public static List<User> getUsers(String location){
      //return JSON.serialize([SELECT ID, Name, User_Location__c from User where User_Location__c =: location Limit 10]);
      return [SELECT ID, Name, User_Location__c from User where User_Location__c =: location Limit 10];
   }
   
}
