public with sharing class EmployeeTriggerHelper {
    public static void beforeInsert(List<Employee__c> newList) {//NOPMD

    }

    public static void afterInsert(List<Employee__c> newList) {//NOPMD
        populateEmployeeCountOnAccount(newList, null);
    }
    
    public static void beforeUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) {//NOPMD
        
    }

    public static void afterUpdate(List<Employee__c> newList, Map<Id, Employee__c> oldMap) {//NOPMD

    }

    public static void beforeDelete(List<Employee__c> oldList) {//NOPMD

    }
    
    public static void afterDelete(List<Employee__c> oldList) {//NOPMD
        updateLeftEmployeeCountOnAccount(oldList, null);
        populateEmployeeCountOnAccount(oldList, null);

    
    }
    public static void afterUndelete(List<Employee__c> newList) {//NOPMD
        undeletingEmployeeSetActive(newList, null);
        updateLeftEmployeeCountOnAccount(newList, null);
        populateEmployeeCountOnAccount(newList, null);

    }

  
    //Scenario 17	When the Employee record is deleted then update 'Left Employee Count' on Account.
    // Scenario 19	When the Employee record is undeleted then update 'Left Employee Count' on Account.

    private static void updateLeftEmployeeCountOnAccount(List<Employee__c> employeeList , Map<Id, Employee__c> oldEmployeeMap){
        Set<Id> employeeId = new Set<Id>();
        for (Employee__c employee : employeeList) {
            if(employee.Employee_Username__c != null){
                employeeId.add(employee.Employee_Username__c);
            }
            
        }
        // if(!employeeId.isEmpty()){
        //     List<Account> account = [SELECT Id ,Left_Employee_Count__c ,(SELECT Id FROM Employees__r) FROM Account WHERE Id =:employeeId];
        //     if(!account.isEmpty()){
        //         update account;
        //     }
        // }

        List<Account> accountsToUpdate = new List<Account>();
        
        for (AggregateResult resultArray : [SELECT Employee_Username__c accId, COUNT(Id) countEmployee FROM Employee__c
            WHERE Employee_Username__c IN :employeeId GROUP BY Employee_Username__c]) {
            accountsToUpdate.add(new Account(
                Id = (Id)resultArray.get('accId'),
                Left_Employee_Count__c = (Integer)resultArray.get('countEmployee')
            ));
        }
        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }


    }

    // Scenario 18	Undelete Employee record and set Active as true. 
    private static void undeletingEmployeeSetActive(List<Employee__c> employeeList , Map<Id, Employee__c> oldEmployeeMap){
        List<Employee__c> employeeToUpdated = new List<Employee__c>();
        for (Employee__c employee : employeeList) {
            employeeToUpdated.add(EmployeeService.setActiveToEmployee(employee));
            
        }
        if(!employeeToUpdated.isEmpty()){
            update employeeToUpdated;
        }
    }


    // Scenario 20	When the Employee record is inserted, deleted and undeleted then update 'Present Employee Count' on related Account. [Parent-Child SOQL] not able to use Parent Child SOQL
    private static void populateEmployeeCountOnAccount(List<Employee__c> employeeList , Map<Id, Employee__c> oldEmployeeMap){
        Set<Id> employeeId = new Set<Id>();
        for (Employee__c employee : employeeList) {
            if(employee.Employee_Username__c != null){
                employeeId.add(employee.Employee_Username__c);
            }
            
        }
        if(!employeeId.isEmpty()){
            List<Account> updatedAccountEmployee = EmployeeService.getAccountSoql(employeeId);
            if(!updatedAccountEmployee.isEmpty()){
                update updatedAccountEmployee;
            }
        }
    }
}