public with sharing class OpportunityService {
    //  Updating Recent Opportunity on Account
    public static Account updateRecentOpportunityOnAccount(Opportunity newOpp) {//NOPMD
        Account account = new Account();
        account.Id = newOpp.AccountId;
        account.Recent_Opportunity_Amount__c = newOpp.Amount;
        return account;
    }
    
    public static Opportunity addRelatedOpportunity(Account currentAccount) {//NOPMD
        Opportunity newRelatedOpportunity = new Opportunity();
        newRelatedOpportunity.Name = 'OPP Name';
        newRelatedOpportunity.AccountId = currentAccount.Id;
        newRelatedOpportunity.CloseDate = System.today()+5;
        newRelatedOpportunity.StageName = 'Value Proposition';
        return newRelatedOpportunity;
    }


    // Case - 7
    public static Task createTask(Opportunity currentOpportunity){
        Task task = new Task();
        task.WhatId = currentOpportunity.Id;
        task.Status = 'Not Started';
        task.OwnerId = UserInfo.getUserId();
        return task;
    }
}