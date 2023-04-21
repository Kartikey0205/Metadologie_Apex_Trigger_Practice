public with sharing class ObjectBTriggerHandler {
    public static void beforeInsert(List<Object_B__c> newList) {//NOPMD
      
    }
    
    public static void afterInsert(List<Object_B__c> newList) {//NOPMD

    }
    
    public static void beforeUpdate(List<Object_B__c> newList, Map<Id, Object_B__c> oldMap) {//NOPMD
    
    }
    
    public static void afterUpdate(List<Object_B__c> newList, Map<Id, Object_B__c> oldMap) {//NOPMD
        //updateStartDateOnA(newList, oldMap);
    
    }
    
    public static void beforeDelete(List<Object_B__c> oldList) {//NOPMD
    
    }
    
    public static void afterDelete(List<Object_B__c> oldList) {//NOPMD
    
    }

    // When B record is Creation then create A as well via C
    // When B record is updated then upadte A as well via C
    public static void updateStartDateOnA(List<Object_B__c> newList , Map<Id, Object_B__c> oldMap){
        Set<Id> updatedObjectBId = new Set<Id>();
        for (Object_B__c objB : newList) {
            if(objB.Start_Date__c != oldMap.get(objB.Id).Start_Date__c){
                updatedObjectBId.add(objB.Id);
            }
        }
        //System.debug('Id are - ' +updatedObjectBId);
        if(!updatedObjectBId.isEmpty()){
            List<Object_A__c> objectAToUpdateList = ObjectBService.objectAtoUpdate(updatedObjectBId);
            //System.debug('Final B is - ' + objectBToUpdateList);
            if(!objectAToUpdateList.isEmpty()){
                update objectAToUpdateList;
            }
        }
    }
    // When B record is deleted then delete A as well via C ---> NO BECAUSE IF PARENT DELETED THEN CHILD IS ALSO DELETED


}