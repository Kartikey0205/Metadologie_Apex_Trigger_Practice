trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            ContactTriggerHelper.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {
            ContactTriggerHelper.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            ContactTriggerHelper.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            ContactTriggerHelper.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        when BEFORE_DELETE {
            ContactTriggerHelper.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE {
            ContactTriggerHelper.afterDelete(Trigger.old);
        }
    }
}