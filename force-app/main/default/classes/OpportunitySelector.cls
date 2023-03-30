public with sharing class OpportunitySelector {
    
    public static List<Opportunity> fetchOpportunitytoAccount(Set<Id> accountIds) {
        //NOPMD
        List<Opportunity> opportunity = [
          SELECT Id, StageName
          FROM Opportunity
          WHERE AccountId IN :accountIds
        ];
        return !opportunity.isEmpty() ? opportunity : NULL;
    }
  
}