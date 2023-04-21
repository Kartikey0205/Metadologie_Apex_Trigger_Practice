public with sharing class ObjectAService {
    public static List<Object_B__c> objectBtoUpdate(Set<Id> updatedObjectAId) {//NOPMD
        List<Object_C__c> objectCData = ObjectCSelector.fetchObjectC(updatedObjectAId);
        List<Object_B__c> objectBToUpdateList = new List<Object_B__c>();
        for (Object_C__c objC : objectCData) {
            Object_B__c objB = new Object_B__c();
            objB.Id = objC.Object_B__c;
        System.debug('Object B Id - ' + objB.Id);
            
            objB.Start_Date__c = objC.Object_A__r.Start_Date__c;
            System.debug('Object A date - ' + objC.Object_A__r.Start_Date__c);
        System.debug('Object B date - ' + objB.Start_Date__c);


            objectBToUpdateList.add(objB);
        }
        System.debug('Object B Data are - ' + objectBToUpdateList);

        return !objectBToUpdateList.isEmpty() ? objectBToUpdateList : NULL;
    }
}