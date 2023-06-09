public class ContactSelector { //NOPMD
  public static List<Contact> fetchContactRelatedtoAccount(Set<Id> accountIds) {
    //NOPMD
    List<Contact> contacts = [
      SELECT Id, Phone, AccountId , HomePhone , MailingAddress
      FROM Contact
      WHERE AccountId IN :accountIds
    ];
    return !contacts.isEmpty() ? contacts : null;
  }
  public static List<Account> fetchContactRelatedtoAccountSoql(Set<Id> accountIds) {
    //NOPMD
    List<Account> accounts = [SELECT Id, BillingCountry, BillingCity, BillingState, BillingPostalCode, BillingStreet,
      (SELECT Id FROM Contacts)
      FROM Account
      WHERE Id IN :accountIds
    ];
    return !accounts.isEmpty() ? accounts : null;
  }

  // case - 27
  public static List<Contact> fetchContactOwnerId(Set<Id> accountIds) {
    //NOPMD
    List<Contact> contactList =     [SELECT Id, AccountId , Account.OwnerId FROM Contact WHERE AccountId IN :accountIds];
    return !contactList.isEmpty() ? contactList : null;
  }
}