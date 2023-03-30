public with sharing class CaseTriggerHandler { //NOPMD
    public static void beforeInsert(List<Case> newList) {//NOPMD
      
    }
    
    public static void afterInsert(List<Case> newList) {//NOPMD
          insertLatestCaseNumberOnAccount(newList, null);
        //   populatingTotalNumberCaseOnAccount(newList, null);
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
    // private void populatingTotalNumberCaseOnAccount(List<Case> caseList, Map<Id, Case> oldMap){
   
    // }

}