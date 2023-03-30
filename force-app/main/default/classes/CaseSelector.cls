public with sharing class CaseSelector {
    // case - 16
    public static List<Case> fetchCaseWithAccount(Id accountId){
        List<Case> caseList = [
            SELECT Id
            FROM Case
            WHERE AccountId =:accountId
          ];
          return !caseList.isEmpty() ? caseList : NULL;
      }
}