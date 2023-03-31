public with sharing class CaseTriggerHandler { //NOPMD
    public static void beforeInsert(List<Case> newList) {//NOPMD
      
    }
    
    public static void afterInsert(List<Case> newList) {//NOPMD
          insertLatestCaseNumberOnAccount(newList, null);
          populatingTotalNumberCaseOnAccount(newList, null);
    }
    
    public static void beforeUpdate(List<Case> newList, Map<Id, Case> oldMap) {//NOPMD
    
    }
    
    public static void afterUpdate(List<Case> newList, Map<Id, Case> oldMap) {//NOPMD
    
    }
    
    public static void beforeDelete(List<Case> oldList) {//NOPMD
    
    }
    
    public static void afterDelete(List<Case> oldList) {//NOPMD
    
    }
  
    //Scenario 4	When a Case is created on any Account, put the latest case number on the Account in the ‘Latest Case Number’ field.
    // 1 st direct 2nd syd may be by SOQL on Account
    
    private static void insertLatestCaseNumberOnAccount(List<Case> caseList, Map<Id, Case> oldMap) {//NOPMD
        //   List<Account> relatedAccountList = new List<Account>();
        //   for (Case currentCase : caseList) {
        //       relatedAccountList.add(CaseService.updateLatestCaseNumberOnAccount(currentCase));
        //   }
        //   if (!relatedAccountList.isEmpty()) {
        //       update relatedAccountList;
        //   }
        Map<Id,String> accountIdToCaseNumberMap = new Map<Id,String>();
        for(Case newCase : caseList){
            if(newCase.AccountId != NULL){
                accountIdToCaseNumberMap.put(newCase.accountId,newCase.CaseNumber);
            }
        }
        if(!accountIdToCaseNumberMap.isEmpty()){
            List<Account> accounts = CaseService.createAccount(accountIdToCaseNumberMap);
            if(!accounts.isEmpty()){
                update accounts;
            }
        }
    }

    //Scenario 22	Create two record types named as "Partner Case" and "Customer Case" on Case Object. On creation of Case, as per the record type populate the total number of Partner Case or Customer Case on Account object. Create Custom Fields on Account to have total number
    private static void populatingTotalNumberCaseOnAccount(List<Case> caseList, Map<Id, Case> oldMap){
        Set<Id> partnerRecordTypeAccountId = new Set<Id>();
        Set<Id> customerRecordTypeAccountId = new Set<Id>();
        Set<Id> allRecordAccountId = new Set<Id>();

        RecordType recordTypeId = [Select id from RecordType WHERE Name ='Partner Case'];
        // Id recordTypeId = [Select id from RecordType WHERE Name ='Partner Case'].Id;
        RecordType recordTypeCustomerId = [Select id from RecordType WHERE Name ='Customer Case'];

        for(Case curCase : caseList) {
            if(curCase.RecordTypeId != NULL){
                if(curCase.RecordTypeId == recordTypeId.Id){
                    allRecordAccountId.add(curCase.AccountId);
                }else if(curCase.RecordTypeId == recordTypeCustomerId.Id){
                    allRecordAccountId.add(curCase.AccountId);
                }
            }
        }

        // allRecordAccountId.addAll(partnerRecordTypeAccountId);
        // allRecordAccountId.addAll(customerRecordTypeAccountId);

        Map<Id , Account> accountsToUpdate = new Map<Id , Account>();
        for (AggregateResult resultArray : [SELECT AccountId accId, RecordType.Name recName, COUNT(Id) countCase FROM Case WHERE AccountId IN : allRecordAccountId
        GROUP BY AccountId , RecordType.Name]) {
            if(resultArray.get('accId') !=  NULL){
                if(resultArray.get('recName') == 'Partner Case'){
                    accountsToUpdate.put((Id)resultArray.get('accId') , new Account(
                        Id = (Id)resultArray.get('accId'),
                        TotalNumberPartnerCase__c = (Integer)resultArray.get('countCase')
                        ));
                }else{
                    accountsToUpdate.put((Id)resultArray.get('accId'), new Account(
                        Id = (Id)resultArray.get('accId'),
                        TotalNumberCustomerCase__c = (Integer)resultArray.get('countCase')
                        ));
                }
             
            }
        }
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate.values();
        }

    }

}