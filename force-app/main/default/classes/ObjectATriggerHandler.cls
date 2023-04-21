public with sharing class ObjectATriggerHandler {
    public static void beforeInsert(List<Object_A__c> newList) {//NOPMD
      
    }
    
    public static void afterInsert(List<Object_A__c> newList) {//NOPMD
        // insertStartDateOnB(newList, null);
    }
    
    public static void beforeUpdate(List<Object_A__c> newList, Map<Id, Object_A__c> oldMap) {//NOPMD
    
    }
    
    public static void afterUpdate(List<Object_A__c> newList, Map<Id, Object_A__c> oldMap) {//NOPMD
        updateStartDateOnB(newList, oldMap);
    
    }
    
    public static void beforeDelete(List<Object_A__c> oldList) {//NOPMD
    
    }
    
    public static void afterDelete(List<Object_A__c> oldList) {//NOPMD
        
    }

    // When A record is Creation then create B as well via C
    public static void insertStartDateOnB(List<Object_A__c> newList , List<Object_A__c> oldList){
     
        
    }
    // When A record is updated then upadte B as well via C
    public static void updateStartDateOnB(List<Object_A__c> newList , Map<Id, Object_A__c> oldMap){
        Set<Id> updatedObjectAId = new Set<Id>();
        for (Object_A__c objA : newList) {
            if(objA.Start_Date__c != oldMap.get(objA.Id).Start_Date__c){
                updatedObjectAId.add(objA.Id);
            }
        }
        System.debug('Id are - ' +updatedObjectAId);
        if(!updatedObjectAId.isEmpty()){
            List<Object_B__c> objectBToUpdateList = ObjectAService.objectBtoUpdate(updatedObjectAId);
            System.debug('Final B is - ' + objectBToUpdateList);
            if(!objectBToUpdateList.isEmpty()){
                update objectBToUpdateList;
            }
        }
    }
    // When A record is deleted then delete B as well via C ---> NO BECAUSE IF PARENT DELETED THEN CHILD IS ALSO DELETED


}