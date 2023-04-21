/**
 * @description Account Service Class
 */

public class AccountService {

    // public Account createAccount(String accountName , String accNum , String ticketSymbol){
    //     Account acc = new Account(
    //         Name = accountName,
    //         AccountNumber = accNum,
    //         TickerSymbol = ticketSymbol
    //     );
    //     return acc;
    // }
  /**
   * @description updating Contacts Phone
   * @return ContactList
   * @param Map of account id as a key with Phone Number as String value
   */
    public static List<Contact> updateContactsPhone(Map<Id, String> accountIdToPhoneMap) {//NOPMD
        List<Contact> contacts = ContactSelector.fetchContactRelatedtoAccount(accountIdToPhoneMap.keySet()); // y sare contact ki list rkha h vo vo contact jo related h account se jinki old value new updated value k equal nhi
        for (Contact contact : contacts) {
            contact.Phone = accountIdToPhoneMap.get(contact.AccountId);
        }
        return !contacts.isEmpty() ? contacts : NULL;
    }

    public static Contact addRelatedContact(Account currentAccount) {//NOPMD
        Contact newRelatedContact = new Contact();
        newRelatedContact.LastName = 'Last Name h checkbox wala';
        newRelatedContact.AccountId = currentAccount.Id;
        return newRelatedContact;
    }
    // Case -3
    public static List<Contact> getUpdateContactHomePhone(Map<Id, String> accountIdToPhoneMap) {//NOPMD
        List<Contact> contacts = ContactSelector.fetchContactRelatedtoAccount(accountIdToPhoneMap.keySet()); 
        for (Contact contact : contacts) {
            contact.HomePhone = accountIdToPhoneMap.get(contact.AccountId);
        }
        return !contacts.isEmpty() ? contacts : NULL;
    }

    // Case - 4
    public static List<Contact> updatedContactHomePhone(Set<Id> accountId) {//NOPMD
        List<Account> accounts = AccountSelector.fetchAccount(accountId); 
        List<Contact> relatedContact = new List<Contact>();
        for (Account account : accounts) {
            if(account.Contacts != NULL){
                for (Contact con : account.Contacts) {
                    con.HomePhone = account.Phone;
                    relatedContact.add(con);
                }
            }
        }
        return !relatedContact.isEmpty() ? relatedContact : NULL;
    }

    // Case - 5 
    public static List<Contact> getRelatedContacts(Map<Id, Account> accountIdToAddressMap){
        List<Contact> relatedContacts = ContactSelector.fetchContactRelatedtoAccount(accountIdToAddressMap.keySet()); 
        for (Contact contact : relatedContacts) {
            contact.MailingCity = accountIdToAddressMap.get(contact.AccountId).BillingCity;
            contact.MailingState = accountIdToAddressMap.get(contact.AccountId).BillingState;
            contact.MailingPostalCode = accountIdToAddressMap.get(contact.AccountId).BillingPostalCode;
            contact.MailingStreet = accountIdToAddressMap.get(contact.AccountId).BillingStreet;
            contact.MailingCountry = accountIdToAddressMap.get(contact.AccountId).BillingCountry;

        }
        return !relatedContacts.isEmpty() ? relatedContacts : NULL;
    }

    // Case - 6
    public static List<Contact> getContactsSoql(Set<Id> accountIds){
        List<Account> allChangedAccount = ContactSelector.fetchContactRelatedtoAccountSoql(accountIds);
        List<Contact> relatedContacts = new List<Contact>();
        for (Account account : allChangedAccount) {
            if(account.Contacts != NULL){
                for (Contact contact : account.Contacts) {
                    contact.MailingCity = account.BillingCity;
                    contact.MailingState = account.BillingState;
                    contact.MailingPostalCode = account.BillingPostalCode;
                    contact.MailingStreet = account.BillingStreet;
                    contact.MailingCountry = account.BillingCountry;
                    relatedContacts.add(contact);
                }
            }
        }
        return !relatedContacts.isEmpty() ? relatedContacts : NULL;
    }
   
    // Case - 8
    public static List<Opportunity> getAllOpportunities(Set<Id> accountIds){
        List<Opportunity> relatedOpportunity = OpportunitySelector.fetchOpportunitytoAccount(accountIds);
        if(!relatedOpportunity.isEmpty() && relatedOpportunity != NULL){

            for (Opportunity opportunity : relatedOpportunity) {
                if(opportunity.StageName != 'Closed Won'){
                    opportunity.Closed_Lost_Reason__c = 'Hardcore';
                    opportunity.StageName = 'Closed Lost';
                }
            }
        } 
        return !relatedOpportunity.isEmpty() ? relatedOpportunity : NULL;
    }

    // Case - 15
    public static List<Account> getAllRelatedOpportunity(Map<Id, Account> accountId){
        List<Account> accountHaveOpp = AccountSelector.fetchOpportunityWithAccount(accountId.keySet());
        return !accountHaveOpp.isEmpty() ? accountHaveOpp : NULL;
    }

    
    // Case - 16
    public static List<Account> getAllRelatedCases(Map<Id, Account> accountId){
        List<Account> relatedCase = AccountSelector.fetchCaseWithAccount(accountId.keySet());
        return !relatedCase.isEmpty() ? relatedCase : NULL;
    }

    // case - 17
    public static List<Account> updatedLeftEmployeeCount(Set<Id> employeeId){
        List<Account> account = EmployeeSelector.fetchAccountEmployee(employeeId);
        List<Account> updatedAccount = new List<Account>();
        for (Account acc : account) {
            acc.Left_Employee_Count__c = acc.Employees__r.size();
            updatedAccount.add(acc);
        }
        return !updatedAccount.isEmpty() ? updatedAccount: NULL;
    }

    // Case - 27
    public static List<Contact> updateOwnerId(Set<Id> accountId){
        List<Contact> contactList = ContactSelector.fetchContactOwnerId(accountId);
        List<Contact> updatedRelatedContact = new List<Contact>();
        for (Contact currentContact : contactList) {
            currentContact.OwnerId = currentContact.Account.OwnerId;
            updatedRelatedContact.add(currentContact);
        }

        return !updatedRelatedContact.isEmpty() ? updatedRelatedContact: NULL;
    }
}