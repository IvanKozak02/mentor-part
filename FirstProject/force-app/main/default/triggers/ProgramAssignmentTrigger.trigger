trigger ProgramAssignmentTrigger on Program_Assignment__c (before insert, after insert, before update, after update,
                                            before delete, after delete, after undelete) {
    new ProgramAssignmentTriggerHandler().run();
}