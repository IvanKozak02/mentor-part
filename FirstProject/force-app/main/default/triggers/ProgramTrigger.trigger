trigger ProgramTrigger on Program__c (before insert, after insert, before update, after update,
                                    before delete, after delete, after undelete) {
    new ProgramTriggerHandler().run();
}