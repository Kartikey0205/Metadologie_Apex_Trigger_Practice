public with sharing class PositionTriggerHandler {//NOPMD
    public static void beforeInsert(List<Position__c> newList){//NOPMD
        populatePositionFields(newList, null);
    }
    
    public static void afterInsert(List<Position__c> newList){//NOPMD
    
    }
    
    public static void beforeUpdate(List<Position__c> newList , Map<Id , Position__c> oldMap){//NOPMD
    
    }
    
    public static void afterUpdate(List<Position__c> newList ,  Map<Id , Position__c> oldMap){//NOPMD
    
    }
    
    public static void beforeDelete(List<Position__c> oldList){//NOPMD
    
    }
    
    public static void afterDelete(List<Position__c> oldList){//NOPMD
    
    }

    //Upon Creation of Position (Custom Object) if it is a New Position and Open Date, Min Pay & Max Pay are not populated then populated them with below values: a. Open Date = Today’s Date b. Min Pay = 10000 c. Max Pay = 15000
    private static void populatePositionFields(List<Position__c> positionList , Map<Id, Position__c> oldMap) {//NOPMD
        for(Position__c currentPosition : positionList){
            if(currentPosition.Open_Date__c == NULL && currentPosition.Max_Pay__c == NULL && currentPosition.Min_Pay__c == NULL){
                currentPosition.Open_Date__c = System.today();
                currentPosition.Max_Pay__c = 15000;
                currentPosition.Min_Pay__c = 10000;
            }
        }
    }
}