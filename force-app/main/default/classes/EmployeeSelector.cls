public with sharing class EmployeeSelector {
    // case - 17
  public static List<Account> fetchAccountEmployee(Set<Id> employeeId) {
    //NOPMD
    List<Account> accountList = [SELECT Id ,Left_Employee_Count__c ,(SELECT Id FROM Employees__r) FROM Account WHERE Id =:employeeId];
    return !accountList.isEmpty() ? accountList : null;
  }
}