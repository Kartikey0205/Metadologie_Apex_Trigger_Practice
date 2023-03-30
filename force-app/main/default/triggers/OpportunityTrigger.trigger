trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert,  after update, after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT{
            OpportunityTriggerHelper.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT{
            OpportunityTriggerHelper.afterInsert(Trigger.new);
        }
        when BEFORE_UPDATE{
            OpportunityTriggerHelper.beforeUpdate(Trigger.new , Trigger.oldMap);
        }
        when AFTER_UPDATE{
            OpportunityTriggerHelper.afterUpdate(Trigger.new , Trigger.oldMap);
        }
        when BEFORE_DELETE{
            OpportunityTriggerHelper.beforeDelete(Trigger.old);
        }
        when AFTER_DELETE{
            OpportunityTriggerHelper.afterDelete(Trigger.old);
        }
    }
}