/**
 * @description Account Trigger Handle Class
 */
public with sharing class AccountTriggerHandler {
  public static void beforeInsert(List<Account> newList) {// NOPMD
    //updatePhone(newList , null);
  }
  public static void afterInsert(List<Account> newList) {// NOPMD

  }
  public static void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap) {// NOPMD

  }
  /**
   * @description AFTER UPDATE METHOD
   * @param List of Account  , Map of account id as a key with Account as String value
   */
  public static void afterUpdate(List<Account> newList, Map<Id, Account> oldMap) {//NOPMD
    updateRelatedContactPhone(newList, oldMap);
  }
  public static void beforeDelete(List<Account> oldList) {// NOPMD

  }
  public static void afterDelete(List<Account> oldList) {// NOPMD

  }

  private static void updatePhone(List<Account> accounts, Map<Id, Account> accountMap) {//NOPMD
    for (Account account : accounts) {
      account.Phone = '65356';
    }
  }

  // update Account Phone -> contacts Phone update
  private static void updateRelatedContactPhone(List<Account> accounts, Map<Id, Account> accountMap) {//NOPMD
    Map<Id, String> accountIdToPhoneMap = new Map<Id, String>();
    for (Account account : accounts) {
      if (account.Phone != accountMap.get(account.Id).Phone) {
        accountIdToPhoneMap.put(account.id, account.Phone);
      }
    }
    if (!accountIdToPhoneMap.isEmpty()) {
      List<Contact> contacts = AccountService.updateContactsPhone(accountIdToPhoneMap);
      if (!contacts.isEmpty()) {
        update contacts;
      }
    }
  }
}