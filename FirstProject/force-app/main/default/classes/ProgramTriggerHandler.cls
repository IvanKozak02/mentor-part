public with sharing class ProgramTriggerHandler extends TriggerHandler {

    List<Program__c> newPrograms;
    List<Program__c> oldPrograms;
    Map<Id, Program__c> oldProgramsMap;

    public ProgramTriggerHandler() {
        newPrograms = (List<Program__c>) Trigger.new;
        oldPrograms = (List<Program__c>) Trigger.old;
        oldProgramsMap = (Map<Id, Program__c>) Trigger.oldMap;
    }


    public override void afterUpdate(){
        Set<Id> programIdsPAToUpdate = new Set<Id>();
        for (Program__c p : newPrograms) {
            Program__c oldProgram = oldProgramsMap.get(p.Id);
            if (oldProgram.Name != p.Name) {
                programIdsPAToUpdate.add(p.Id);
            }
        }
        if (!programIdsPAToUpdate.isEmpty()) {
            ProgramAssignmentHelper.updateRelatedProgramAssignments(programIdsPAToUpdate, 'Program__c');            
        }
    }


    public override void beforeDelete() {
        Set<Id> programIds = oldProgramsMap.keySet();
        List<Program_Assignment__c> programRelatedPAs = SOQLHelper.getRelatedProgramAssignments(programIds,'Program__c');
        List<Program_Assignment__c> pasToDelete = new List<Program_Assignment__c>();

        for (Program_Assignment__c pa : programRelatedPAs) {
            if (pa.Status__c != 'Denied' && pa.Status__c != 'Applied') {
                Program__c pr = oldProgramsMap.get(pa.Program__c);
                pr.addError('Cannot Delete Program because it has PAs with Status ' + pa.Status__c);
            }else {
                pasToDelete.add(pa);
            }
        }
        if (!pasToDelete.isEmpty()) {
            delete pasToDelete;
        }
        
    }



}