trigger AccountTrigger on Account(before insert, before update, before delete, after insert, after update, after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            AccountTriggerHelper.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {
            AccountTriggerHelper.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            AccountTriggerHelper.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            AccountTriggerHelper.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        when BEFORE_DELETE {
            AccountTriggerHelper.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE {
            AccountTriggerHelper.afterDelete(Trigger.old);
        }
    }
}