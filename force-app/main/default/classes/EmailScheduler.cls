global with sharing class EmailScheduler implements Schedulable{
    global void execute(SchedulableContext con){
        EmailSenderHandler.checkBirthday();
    }
}