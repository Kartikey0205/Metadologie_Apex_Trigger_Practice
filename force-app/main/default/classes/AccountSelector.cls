public with sharing class AccountSelector {
   // CASE 4
   public static List<Account> fetchAccount(Set<Id> accountIds) {
    //NOPMD
    List<Account> accounts = [SELECT Id, Phone,
      (SELECT HomePhone FROM Contacts)
      FROM Account
      WHERE Id IN :accountIds
    ];
    return !accounts.isEmpty() ? accounts : null;
  }

    // Case -15
    public static List<Account> fetchOpportunityWithAccount(Set<Id> accountId){
      List<Account> account = [
          SELECT Id ,(SELECT Id FROM Opportunities WHERE AccountId In:accountId)
          FROM Account
        ];
        return !account.isEmpty() ? account : NULL;
    }


     // case - 16
     public static List<Account> fetchCaseWithAccount(Set<Id> accountId){
      List<Account> caseList = [
          SELECT Id,(SELECT Id FROM Cases WHERE AccountId In:accountId)
          FROM Account
        ];
        return !caseList.isEmpty() ? caseList : NULL;
    }

    // Case - 20
    public static List<Account> fetchEmployeeWithAccount(Set<Id> employeeId){
      List<Account> accountToEmployeeList = [
        SELECT Id ,
        NumberOfEmployees, 
        (SELECT Employee_Username__c FROM Employees__r)
        FROM Account
        WHERE ID IN :employeeId
        ];
      return !accountToEmployeeList.isEmpty() ? accountToEmployeeList : NULL;
    }
}