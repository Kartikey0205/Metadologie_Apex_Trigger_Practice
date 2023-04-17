public with sharing class EmailSenderHandler {
    public static void checkBirthday() {
        List<User> birthdayUsers = [SELECT Id, NAME, EMAIL FROM USER WHERE IsActive = true AND isBirthday__c = true];
        System.debug(birthdayUsers);
        sendEmail(birthdayUsers);
    }

    public static void sendEmail(List<User> birthdayUsers){
        List<User> restUsers = [SELECT Id, NAME, EMAIL FROM USER WHERE IsActive = true];
        // List<User> restUsers = [SELECT Id, NAME, EMAIL FROM USER WHERE IsActive = true AND (EMAIL = 'training.testing2231@gmail.com' OR EMAIL = 'kartikey.19bcon015@jecrcu.edu.in')];
        System.debug('all user '+ restUsers);
        List<Messaging.SingleEmailMessage> mail = new List<Messaging.SingleEmailMessage>();
        Id emailTemplateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Birthday_Template'].Id; 
        List<String> recipents = new List<String>();

        for(User currentUser : restUsers){
            if(currentUser.Email != NULL && Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', currentUser.Email)){
                System.debug('currentUser.Email >> '+ currentUser.Email);
                recipents.add(currentUser.Email);
            }
        }


        for(User currentUser: birthdayUsers)
        {
         Messaging.SingleEmailMessage maileach = new Messaging.SingleEmailMessage();
         maileach.setTemplateId(emailTemplateId);
         maileach.setTargetObjectId(currentUser.Id);
         maileach.setCcAddresses(recipents);
         maileach.setSaveAsActivity(false);
         mail.add(maileach);
        }
        System.debug(mail);
        Messaging.SendEmailResult[]  result  = Messaging.sendEmail(mail);
    }
}