trigger ObjectATrigger on Object_A__c (before insert, before update, before delete, after insert, after update, after delete ) {
    switch on Trigger.operationType {
        when BEFORE_INSERT{
            ObjectATriggerHandler.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT{
            ObjectATriggerHandler.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE{
            ObjectATriggerHandler.beforeUpdate(Trigger.new , Trigger.oldMap);
        }
        when AFTER_UPDATE{
            ObjectATriggerHandler.afterUpdate(Trigger.new , Trigger.oldMap);
        }when BEFORE_DELETE{
            ObjectATriggerHandler.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE{
            ObjectATriggerHandler.afterDelete(Trigger.old);
        }
    }
}