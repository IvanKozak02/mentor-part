trigger OutreachTrigger on Outreach__c (before insert, after insert, before update, after update,
                                        before delete, after delete, after undelete) {
    new OutreachTriggerHandler().run();
}