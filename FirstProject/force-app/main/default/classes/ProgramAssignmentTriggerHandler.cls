public with sharing class ProgramAssignmentTriggerHandler extends TriggerHandler {
    
    List<Program_Assignment__c> newProgramAssignments;
    Map<Id,Program_Assignment__c> newProgramAssignmentsMap;
    Map<Id, Program_Assignment__c> oldProgramAssignmentsMap;

    public ProgramAssignmentTriggerHandler() {
        newProgramAssignments = (List<Program_Assignment__c>) Trigger.new;
        oldProgramAssignmentsMap = (Map<Id, Program_Assignment__c>) Trigger.oldMap;
    }


    public override void beforeInsert(){
        
        Set<Id> paContactIds = new Set<Id>();
        Set<Id> paProgramIds = new Set<Id>();

        for (Program_Assignment__c pa : newProgramAssignments) {
            if (pa.Contact__c != null) {
                paContactIds.add(pa.Contact__c);
            }
            if (pa.Program__c != null) {
                paProgramIds.add(pa.Contact__c);                
            }
         }

         Map<Id, Contact> paContacts = SOQLHelper.getPAContacts(newProgramAssignments);
         Map<Id, Program__c> paPrograms = SOQLHelper.getPAPrograms(newProgramAssignments);

        for (Program_Assignment__c pa : newProgramAssignments) {
             if(pa.Autoname__c){
                String contactName = paContacts.get(pa.Contact__c) != null ? paContacts.get(pa.Contact__c).Name : '';
                String programName = paPrograms.get(pa.Program__c) != null ? paPrograms.get(pa.Program__c).Name : '';
                ProgramAssignmentHelper.generatePAName(pa,contactName, programName);
             }
         }
     }

    public override void beforeUpdate(){
        Map<Id, Contact> paContacts = SOQLHelper.getPAContacts(newProgramAssignments);
        Map<Id, Program__c> paPrograms = SOQLHelper.getPAPrograms(newProgramAssignments);


        for (Program_Assignment__c pa : newProgramAssignments) {
            Program_Assignment__c oldPA = oldProgramAssignmentsMap.get(pa.Id);
            
            String paContactName = paContacts.get(pa.Contact__c) != null ? paContacts.get(pa.Contact__c).Name : '';
            String paProgramName = paPrograms.get(pa.Program__c) != null ? paPrograms.get(pa.Program__c).Name : '';

            if (!oldPA.Autoname__c && pa.Autoname__c) {
                ProgramAssignmentHelper.generatePAName(pa, paContactName, paProgramName);
                return;
            }
            if (oldPA.Start_Date__c != pa.Start_Date__c && pa.Autoname__c) {
                ProgramAssignmentHelper.updatePAStartDate(pa);
            }
            if (oldPA.Contact__c != pa.Contact__c && pa.Autoname__c) {
                ProgramAssignmentHelper.updatePAContactName(pa, paContactName);
            }
            if (oldPA.Program__c != pa.Program__c && pa.Autoname__c) {
                ProgramAssignmentHelper.updatePAProgramName(pa, paProgramName);
            }
        }
    }
}