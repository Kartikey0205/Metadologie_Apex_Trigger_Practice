public with sharing class ObjectCSelector {
    public static List<Object_C__c> fetchObjectC(Set<Id> updatedObjectId) {
        //NOPMD
        List<Object_C__c> objectCData = [
                SELECT Object_B__c,Object_A__c, Object_A__r.Start_Date__c, Object_B__r.Start_Date__c
                FROM Object_C__c
                WHERE Object_A__c IN :updatedObjectId
            ];
            System.debug('Object C Data are - ' + objectCData);
        return !objectCData.isEmpty() ? objectCData : null;
      }
}
/*bjectATrigger: execution of AfterUpdate caused by: System.SObjectException: 
 * SObject row was retrieved via SOQL without querying the requested field:
 *  Object_C__c.Object_B__r Class.ObjectAService.objectBtoUpdate: line 7, column 1 Class.ObjectATriggerHandler.updateStartDateOnB: 
line 42, column 1 Class.ObjectATriggerHandler.afterUpdate: line 15, column 1 Trigger.ObjectATrigger: line 13, column 1*/