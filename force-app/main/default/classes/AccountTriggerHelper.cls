public with sharing class AccountTriggerHelper { //NOPMD
    public static void beforeInsert(List<Account> newList) {//NOPMD
        updateRatingOnCheckingIndustry(newList, null);
        copyAccountBillingAddressIntoShippingAddress(newList, null);
        
    }

    public static void afterInsert(List<Account> newList) {//NOPMD
        createRelatedContact(newList, null);
        createRelatedContactOrOpportunityRecord(newList, null);
        createRelatedOpportunity(newList, null);
    }
    
    public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {//NOPMD
        updatingAccountBillingAddressIntoShippingAddress(newList, oldMap);
        populatingDescriptionOnPhoneUpdate(newList, oldMap);
        updateRatingOnCheckingIndustry(newList, oldMap);
        checkAccountEditable(newList, oldMap);
    }

    public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {//NOPMD
        // updatePhoneOnRelatedContact(newList, oldMap);
        updatePhoneOnRelatedContactBySoql(newList, oldMap);
        // updateContactBillingAddress(newList, oldMap);
        updateContactBillingAddressSoql(newList, oldMap);
        updateOpportunityStage(newList, oldMap);
    }

    public static void beforeDelete(List<Account> oldList) {//NOPMD
        checkAccountDeletion(oldList , null);
        preventDeletion(oldList, null);
        preventDeletionOverOpportunity(oldList, null);
        preventDeletionOverCase(oldList, null);
    }
    
    public static void afterDelete(List<Account> oldList) {//NOPMD
    
    }
  
    // Upon Account Creation, if Industry is not null and has value as ‘Media’ then populate Rating as Hot.
    // Scenario 1	Upon Account Creation or updation if Industry is not null and having value as 'Media' then populate Rating as Hot

    private static void updateRatingOnCheckingIndustry(List<Account> accountList, Map<Id, Account> oldMap) {
        for (Account currentAccount : accountList) {
            if(currentAccount.Industry != NULL){
                if (oldMap != NULL) { // update Case
                    if(currentAccount.Industry != oldMap.get(currentAccount.Id).Industry && currentAccount.Industry == 'Media'){
                        currentAccount.Rating = 'Hot';
                    }
                } else { // INSERTION
                    if (currentAccount.Industry == 'Media') {
                        currentAccount.Rating = 'Hot';
                    }
                }
            }
        }
    }
  
    //Scenario 1	When an account inserts and CopyBillingToShipping (Custom Field) checkbox is checked then automatically copy the account billing address into the account shipping address.
    private static void copyAccountBillingAddressIntoShippingAddress(List<Account> accountList, Map<Id, Account> oldMap) {
        for (Account currentAccount : accountList) {
            if (currentAccount.CopyBillingToShipping__c) {
                if (String.isNotBlank(currentAccount.BillingCity)) {
                    currentAccount.ShippingCity = currentAccount.BillingCity;
                }
                if (String.isNotBlank(currentAccount.BillingStreet)) {
                    currentAccount.ShippingStreet = currentAccount.BillingStreet;
                }
                if (String.isNotBlank(currentAccount.BillingPostalCode)) {
                    currentAccount.ShippingPostalCode = currentAccount.BillingPostalCode;
                }
                if (String.isNotBlank(currentAccount.BillingState)) {
                    currentAccount.ShippingState = currentAccount.BillingState;
                }
                if (String.isNotBlank(currentAccount.BillingCountry)) {
                    currentAccount.ShippingCountry = currentAccount.BillingCountry;
                }
            }
        }
    }
  
    // 5th case 
    private static void updatingAccountBillingAddressIntoShippingAddress(List<Account> accountList, Map<Id, Account> oldAccountMap) {
        for (Account currentAccount : accountList) {
            if (currentAccount.CopyBillingToShipping__c) {
                if(currentAccount.BillingCity != oldAccountMap.get(currentAccount.Id).BillingCity){
                    currentAccount.ShippingCity = currentAccount.BillingCity;
                }
                if(currentAccount.BillingStreet != oldAccountMap.get(currentAccount.Id).BillingStreet){
                    currentAccount.ShippingStreet = currentAccount.BillingStreet;
                }
                if(currentAccount.BillingPostalCode != oldAccountMap.get(currentAccount.Id).BillingPostalCode){
                    currentAccount.ShippingPostalCode = currentAccount.BillingPostalCode;
                }
                if(currentAccount.BillingState != oldAccountMap.get(currentAccount.Id).BillingState){
                    currentAccount.ShippingState = currentAccount.BillingState;
                }
                if(currentAccount.BillingCountry != oldAccountMap.get(currentAccount.Id).BillingCountry){
                    currentAccount.ShippingCountry = currentAccount.BillingCountry;
                }
            }
        }
    }
    //Scenario 3	Create a related Contact when an Account is created.
    private static void createRelatedContact(List<Account> accountList, Map<Id, Account> oldMap) {
        List<Contact> conList = new List<Contact>();
        for (Account currentAccount : accountList) {
            conList.add(AccountService.addRelatedContact(currentAccount));
        }
        if (!conList.isEmpty()) {
            insert conList;
        }
    }

    //Scenario 1	On Account creates two checkbox fields labeled Contact and Opportunity. Now when a new Account record is created and if a particular Contact or Opportunity checkbox is checked then create that related record. Also, an Opportunity record should be created only if the Account record Active picklist is populated with a Yes.
    private static void createRelatedContactOrOpportunityRecord(List<Account> accountList, Map<Id, Account> oldMap) {
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();

        for (Account currentAccount : accountList) {
            if(currentAccount.Contact__c){
                conList.add(AccountService.addRelatedContact(currentAccount));
            }
            if(currentAccount.Opportunity__c && currentAccount.Active__c == 'Yes'){
                oppList.add(OpportunityService.addRelatedOpportunity(currentAccount));
            }
        }
        if (!conList.isEmpty()) {
            insert conList;
        }
        if (!oppList.isEmpty()) {
            insert oppList;
        }
    }

    // Create a related Opportunity when an Account is created.
    private static void createRelatedOpportunity(List<Account> accountList, Map<Id, Account> oldMap) {
        List<Opportunity> oppList = new List<Opportunity>();

        for (Account currentAccount : accountList) {
            oppList.add(OpportunityService.addRelatedOpportunity(currentAccount));
        }
        if (!oppList.isEmpty()) {
            insert oppList;
        }
    }

    // If the Account phone is updated then populate below message in description. Description = Phone is Updated! Old Value : XXX & New Value : XXX
    private static void populatingDescriptionOnPhoneUpdate(List<Account> accountList, Map<Id, Account> oldMap) {
       for (Account account : accountList) {
        if(account.Phone != oldMap.get(account.Id).Phone){
            account.Description = ' Phone is Updated! ' + 'Old Value : ' +oldMap.get(account.Id).Phone + ' & New Value :' + account.Phone;
        }
       } 
    }

    // Scenario 3	If the Account phone is updated then populate the phone number on all related Contacts (Home Phone field). [Using Map]
    private static void updatePhoneOnRelatedContact(List<Account> accountList, Map<Id, Account> accountMap) {
        Map<Id, String> accountIdToPhoneMap = new Map<Id, String>();
        for (Account account : accountList) {
            if (account.Phone != accountMap.get(account.Id).Phone) {
                accountIdToPhoneMap.put(account.Id, account.Phone);
            }
        }

        if(!accountIdToPhoneMap.isEmpty()){
            List<Contact> relatedContactList = AccountService.getUpdateContactHomePhone(accountIdToPhoneMap);
            if(!relatedContactList.isEmpty()){
                update relatedContactList;
            }
        }
    }
    
    // Scenario 4	If the Account phone is updated then populate the phone number on all related Contacts (Home Phone field). [Using Parent-Child SOQL]
    private static void updatePhoneOnRelatedContactBySoql(List<Account> accountList, Map<Id, Account> accountMap) {
        Set<Id> accountId = new Set<Id>();
        for (Account account : accountList) {
            if (account.Phone != accountMap.get(account.Id).Phone) {
                accountId.add(account.Id);
            }
        }

        if(!accountId.isEmpty()){
            List<Contact> relatedContactList = AccountService.updatedContactHomePhone(accountId);
            if(!relatedContactList.isEmpty()){
                update relatedContactList;
            }
        }
    }


    //Scenario 5	If the Account billing address is updated then update related contacts mailing address. [Using Map]
    private static void updateContactBillingAddress(List<Account> accountList, Map<Id, Account> oldAccountMap) {
        if(oldAccountMap != NULL){
            Map<Id, Account> accountIdToBillingAddressMap = new Map<Id, Account>();
            for (Account account : accountList) {
                if (
                    account.BillingCity != oldAccountMap.get(account.Id).BillingCity ||
                    account.BillingCountry != oldAccountMap.get(account.Id).BillingCountry ||
                    account.BillingState != oldAccountMap.get(account.Id).BillingState ||
                    account.BillingStreet != oldAccountMap.get(account.Id).BillingStreet||
                    account.BillingPostalCode != oldAccountMap.get(account.Id).BillingPostalCode

                ) {
                    accountIdToBillingAddressMap.put(account.Id, account);
                }
            }
            if(!accountIdToBillingAddressMap.isEmpty()){
                List<Contact> relatedContactList = AccountService.getRelatedContacts(accountIdToBillingAddressMap);
                if(!relatedContactList.isEmpty()){
                    update relatedContactList;
                }
            }
        }
    }
    
    // Scenario 6	If the Account billing address is updated then update related contacts mailing address. [Using Parent-Child SOQL]
    private static void updateContactBillingAddressSoql(List<Account> accountList, Map<Id, Account> oldAccountMap) {
        if(oldAccountMap != NULL){
            Set<Id> updatedAddressIdSet = new set<Id>();
            for (Account account : accountList) {
                if (
                    account.BillingCity != oldAccountMap.get(account.Id).BillingCity ||
                    account.BillingCountry != oldAccountMap.get(account.Id).BillingCountry ||
                    account.BillingState != oldAccountMap.get(account.Id).BillingState ||
                    account.BillingStreet != oldAccountMap.get(account.Id).BillingStreet||
                    account.BillingPostalCode != oldAccountMap.get(account.Id).BillingPostalCode

                ) {
                    updatedAddressIdSet.add(account.Id);
                }
            }
            if(!updatedAddressIdSet.isEmpty()){
                List<Contact> relatedContactList = AccountService.getContactsSoql(updatedAddressIdSet);
                if(!relatedContactList.isEmpty()){
                    update relatedContactList;
                }
            }
        }
    }
    

    // Scenario 8	Write a trigger on Account when Account Active field is updated from 'Yes' to 'No' then check all opportunities associated with the account. Update all Opportunities Stage to close lost if stage not equal to close won.
    private static void updateOpportunityStage(List<Account> accountList, Map<Id, Account> oldAccountMap) {
        if(oldAccountMap != NULL){
            Set<Id> accountIdSet = new set<Id>();
            for (Account account : accountList) {
                if (account.Active__c == 'No' && account.Active__c != oldAccountMap.get(account.Id).Active__c) {
                    accountIdSet.add(account.Id);
                }
            }
            if(!accountIdSet.isEmpty()){
                List<Opportunity> relatedOpportunityList = AccountService.getAllOpportunities(accountIdSet);
                if(!relatedOpportunityList.isEmpty() && relatedOpportunityList != NULL) {
                    update relatedOpportunityList;
                }
            }
        }
    }

    // Scenario 9	Account records cannot be deleted if active is Yes.
    private static void checkAccountDeletion(List<Account> accountList , Map<Id, Account> oldAccountMap){
        for (Account account : accountList) {
            if(account.Active__c == 'Yes'){
                account.addError('Account is active so cannot be delete');
            }
        }
    }

    // Scenario 10	Prevent account record from being edited if the record is created 7 days back.
    // Scenario 11	Prevent account record from being edited if the record is created 7 days back.
    private static void checkAccountEditable(List<Account> accountList , Map<Id, Account> oldAccountMap){
        for (Account account : accountList) {
            if(account.CreatedDate < System.today() - 7){
                account.addError('Account cannot be edited as it is created within 7 days');
            }
        }
    }

    // Scenario 13	Write a trigger on Account and check only System Administrator profile users should be able to delete an account
    private static void preventDeletion(List<Account> accountList , Map<Id, Account> oldAccountMap){
        Id profileId = UserInfo.getProfileId();
        Profile profileName = [SELECT Name FROM Profile where Id =:profileId];
        for (Account account : accountList) {
            if(profileName.Name != 'System Administrator'){
                account.addError('Only System Administartor can delete an account');
            }
        }
    }

    // Scenario 15	Prevent deletion of an account if there is any opportunity related to that account.
    private static void preventDeletionOverOpportunity(List<Account> accountList , Map<Id, Account> oldAccountMap){
        // Map<Id, Account> accountMap = new Map<Id, Account>();
        // for (Account account : accountList) {
        //     accountMap.put(account.Id , account);
        // }
        // if(!accountMap.isEmpty()){
        //    List<Account> accountHavingOpportunity = AccountService.getAllRelatedOpportunity(accountMap);
        //     if(!accountHavingOpportunity.isEmpty()){
        //         for (Account acc : accountHavingOpportunity) {
        //             if(!acc.Opportunities.isEmpty()){
        //                 // acc.addError('Account cannot be deleted as it has related Opportunity');
        //             }
        //         }
                
        //     }
        // }
        List<Opportunity> opportunities = [SELECT AccountId FROM Opportunity];
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opportunity : opportunities) {
            accountIds.add(opportunity.AccountId);
        }
        for(Account account : accountList) {
            if(accountIds.contains(account.Id)) {
                account.addError('Opportunity Exists so account cannot delete');
            }
        }

    }

    //Scenario 16	Prevent deletion of an account if there is any case related to that account.
    private static void preventDeletionOverCase(List<Account> accountList , Map<Id, Account> oldAccountMap){
    
        // Map<Id, Account> accountMap = new Map<Id, Account>();
        // for (Account account : accountList) {
        //     accountMap.put(account.Id , account);
        // }
        // if(!accountMap.isEmpty()){
        //    List<Account> accountHavingCases = AccountService.getAllRelatedCases(accountMap);
        //     if(!accountHavingCases.isEmpty()){
        //         for (Account acc : accountHavingCases) {
        //             if(!acc.Cases.isEmpty()){
        //                 acc.addError('Account cannot be deleted as it has related Cases');
        //             }
        //         }
                
        //     }
        // }
        List<Case> cases = [SELECT AccountId FROM Case];
        Set<Id> accountIds = new Set<Id>();
        for(Case currCase : cases) {
            accountIds.add(currCase.AccountId);
        }
        for(Account account : accountList) {
            if(accountIds.contains(account.Id)) {
                account.addError('Case Exists so account cannot delete');
            }
        }
    }
   
}