trigger ObjectBTrigger on Object_B__c (before insert, before update, before delete, after insert, after update, after delete ) {
    switch on Trigger.operationType {
        when BEFORE_INSERT{
            ObjectBTriggerHandler.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT{
            ObjectBTriggerHandler.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE{
            ObjectBTriggerHandler.beforeUpdate(Trigger.new , Trigger.oldMap);
        }
        when AFTER_UPDATE{
            ObjectBTriggerHandler.afterUpdate(Trigger.new , Trigger.oldMap);
        }when BEFORE_DELETE{
            ObjectBTriggerHandler.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE{
            ObjectBTriggerHandler.afterDelete(Trigger.old);
        }
    }
}