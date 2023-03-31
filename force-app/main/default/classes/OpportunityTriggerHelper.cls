public class OpportunityTriggerHelper { //NOPMD
    public static void beforeInsert(List<Opportunity> newList) {//NOPMD
      updateDescriptionOnValidAmount(newList, null);
      populatingDescription(newList, null);
    }
  
    public static void afterInsert(List<Opportunity> newList) {//NOPMD
      insertRecentOpportunityAmount(newList, null);
      populateOpportunityAmountOnAccount(newList , null);
    }
  
    public static void beforeUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {//NOPMD
      populatingDescription(newList, oldMap);
      populateCloseLostReason(newList, oldMap);
    }
  
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {//NOPMD
      createTaskRecord(newList, oldMap);
    }
  
    public static void beforeDelete(List<Opportunity> oldList) {//NOPMD
      preventOpportunityDeleteOnClosed(oldList,null);
    }
  
    public static void afterDelete(List<Opportunity> oldList) {//NOPMD
  
    }

    //Upon Opportunity Creation if the Amount is not null and is greater than 100000 then populate ‘Hot Opportunity’ in the description field.

    private static void updateDescriptionOnValidAmount(List<Opportunity> opportunityList, Map<Id, Opportunity> oldMap) {//NOPMD
      for (Opportunity oppList : opportunityList) {
        if (oppList.Amount != null && oppList.Amount > 100000) {
          oppList.Description = 'Hot Opportunity';
        }
      }
    }

    //Scenario 5	Account records should have a field named ‘Recent Opportunity Amount’. It should contain the opportunity amount of the latest created opportunity on the account.

    private static void insertRecentOpportunityAmount(List<Opportunity> opportunityList, Map<Id, Opportunity> oldMap) {//NOPMD
      List<Account> relatedAccList = new List<Account>();
      for (Opportunity opp : opportunityList) {
        relatedAccList.add(OpportunityService.updateRecentOpportunityOnAccount(opp));
      }
      if (!relatedAccList.isEmpty()) {
        update relatedAccList;
      }
    }

    // Scenario 2	If opportunity Stage is updated upon its creation or update then update description as either 'Opp is Closed Lost' or 'Opp is Closed Won' or 'Opp is Open'.
    private static void populatingDescription(List<Opportunity> opportunityList, Map<Id, Opportunity> oldMap) {//NOPMD
     for (Opportunity opp : opportunityList) {
      if (oldMap != null) { // Updated Case
        if(opp.StageName != oldMap.get(opp.Id).StageName){
          if(opp.StageName == 'Closed Lost'){
            opp.Description = 'Opp is Closed Lost';
          }else if(opp.StageName == 'Closed Won'){
            opp.Description = 'Opp is Closed Won';
          }else{
            opp.Description = 'Opp is Open';
          }
        }
      } else { // insertion Case
        if(opp.StageName == 'Closed Lost'){
          opp.Description = 'Opp is Closed Lost';
        }else if(opp.StageName == 'Closed Won'){
          opp.Description = 'Opp is Closed Won';
        }else{
          opp.Description = 'Opp is Open';
        }
      }
     }
    }

    // Case - 7
    // Scenario 7	When a Opportunity Stage (field) is changed, create a Task record on Opportunity and assign it to Logged In User/Opportunity Owner / Any User.
    private static void createTaskRecord(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOpportunityMap) {//NOPMD
      List<Task> task = new List<Task>();
      for (Opportunity opportunity : opportunityList) {
        if(opportunity.StageName != oldOpportunityMap.get(opportunity.Id).StageName){
          task.add(OpportunityService.createTask(opportunity));
        }
      }
      if(!task.isEmpty()){
        insert task;
      }
    }

    // Scenario 12	When an opportunity is updated to Closed Lost and Closed Lost Reason (field) is not populated then throw validation error that 'Please populate Closed Lost Reason' on opportunity. [before update]
    private static void populateCloseLostReason(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOpportunityMap){
      if(oldOpportunityMap != NULL){
        for (Opportunity opportunity : opportunityList) {
          if(opportunity.StageName == 'Closed Lost' && opportunity.StageName != oldOpportunityMap.get(opportunity.Id).StageName){
            if(String.isBlank(opportunity.Closed_Lost_Reason__c)){
              opportunity.addError('Please update closed Lost reason also');
            }
          }
        }
      }
    }
    
    //Scenario 14	If an opportunity is closed then, no one should be able to delete it except the user having a System Administrator profile.

    private static void preventOpportunityDeleteOnClosed(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOpportunityMap){
      Id profileId = UserInfo.getProfileId();
      Profile profileName = [SELECT Name FROM Profile where id =: profileId];
      for (Opportunity opportunity : opportunityList) {
        if(opportunity.StageName == 'Closed Lost' && profileName.Name != 'System Administrator'){
            opportunity.addError('Only Sytem Administrator can delete closed Opportunity');
        }
      }
    }
    
    //Scenario 23	When any Opportunity is created with amount populated
    // or Opportunity Amount is updated 
    //then populate total Amount on Account Level for all related opportunities in Annual Revenue Field. (Annual Revenue field mein total amount dalna h account k and each opportunity k total amount mein annual revenue field dalna h )
    //If opportunity is deleted or undeleted then update Amount on Account as well. (Hint: rollup summary)
    private static void populateOpportunityAmountOnAccount(List<Opportunity> opportunityList, Map<Id, Opportunity> oldOpportunityMap){
      Set<Id> accountId = new Set<Id>();
      for (Opportunity opportunity : opportunityList) {
        if(opportunity.Amount != NULL && opportunity.AccountId != NULL){
          accountId.add(opportunity.AccountId);
        }
      }

      if(!accountId.isEmpty()){
        Map<Id,Account> accountMap = new Map<Id,Account> ( [SELECT Id, AnnualRevenue FROM Account WHERE Id In :accountId] );
        List<Opportunity> oppList= [SELECT Id,AccountId,Amount FROM opportunity WHERE Id = :opportunityList];
        List<Account> accounts = new List<Account>();
        for(Opportunity opportunity : oppList) {
            if(accountMap.get(opportunity.AccountId).AnnualRevenue == null) {
                accounts.add(new Account(ID = opportunity.AccountId,AnnualRevenue = opportunity.Amount));
            }
           	else {	
                accounts.add(new Account(ID = opportunity.AccountId , AnnualRevenue = (accountMap.get(opportunity.AccountId).AnnualRevenue)+opportunity.Amount));
            }
        }
        update accounts;

      }
    }
}
