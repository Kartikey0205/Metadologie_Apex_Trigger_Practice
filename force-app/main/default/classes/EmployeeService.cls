public with sharing class EmployeeService {
    public static Employee__c setActiveToEmployee(Employee__c employee) {
        Employee__c newEmployee = new Employee__c();
        newEmployee.Id = employee.Id;
        newEmployee.Active__c = true;
        return newEmployee;
    }


    // CASE - 20 
    public static List<Account> getAccountSoql(Set<Id> employeeId){
        List<Account> accountsToUpdate = new List<Account>();
        
        List<Account>accountToEmployeeList = AccountSelector.fetchEmployeeWithAccount(employeeId);
        for (Account account : accountToEmployeeList) {
            if(account.Employees__r != NULL){
                Account a = new Account();
                a.Id = account.Id;
                a.NumberOfEmployees = account.Employees__r.size();
                accountsToUpdate.add(a);
            }
        }
        return !accountsToUpdate.isEmpty() ? accountsToUpdate : NULL;
    }
}