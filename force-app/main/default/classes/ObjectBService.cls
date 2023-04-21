public with sharing class ObjectBService {
    public static List<Object_A__c> objectAtoUpdate(Set<Id> updatedObjectBId) {//NOPMD
        List<Object_C__c> objectCData = ObjectCSelector.fetchObjectC(updatedObjectBId);
        List<Object_A__c> objectAToUpdateList = new List<Object_A__c>();
        for (Object_C__c objC : objectCData) {
            Object_A__c objA = new Object_A__c();
            objA.Id = objC.Object_A__c;
        // System.debug('Object B Id - ' + objA.Id);
            
            objA.Start_Date__c = objC.Object_A__r.Start_Date__c;
            // System.debug('Object A date - ' + objC.Object_A__r.Start_Date__c);
        // System.debug('Object B date - ' + objA.Start_Date__c);


            objectAToUpdateList.add(objA);
        }
        // System.debug('Object B Data are - ' + objectBToUpdateList);

        return !objectAToUpdateList.isEmpty() ? objectAToUpdateList : NULL;
    }
}