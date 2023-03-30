public with sharing class ContactTriggerHelper {
    public static void beforeInsert(List<Contact> newList) {//NOPMD
        sendingEmail(newList, null);
    }

    public static void afterInsert(List<Contact> newList) {//NOPMD

    }
    
    public static void beforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {//NOPMD

    }

    public static void afterUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {//NOPMD

    }

    public static void beforeDelete(List<Contact> oldList) {//NOPMD
    
    }
    
    public static void afterDelete(List<Contact> oldList) {//NOPMD
    
    }
    // Scenario 21	Upon contact creation an email should be sent to email populated on Contact with specified template.
    private static void sendingEmail(List<Contact> contactList , Map<Id, Contact> oldContactMap){
        List<Messaging.Email> emailList = new List<Messaging.Email>();
        for(Contact contact : contactList) {
            if(String.isNotBlank(contact.Email)) {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                String[] toAddress = new String[] {contact.Email};
                message.setToAddresses(toAddress);
                message.setSubject('Hello ' + contact.FirstName + contact.LastName);
                message.plainTextBody = 'Your Contact has been succesfully created';
                emailList.add(message);
            }
        }
        Messaging.sendEmail(emailList);
    }
}