public with sharing class ProgramAssignmentHelper {

public static void generatePAName(Program_Assignment__c pa, String contactName, String programName){
    if (pa.Start_Date__c != null) {
        String formatStartDate = pa.Start_Date__c.format();
        pa.Name = contactName + ' - ' + programName + ' : ' + formatStartDate;
    } else {
        pa.Name = contactName + ' - ' + programName;
    }
    
}

public static void updateRelatedProgramAssignments(Set<Id> Ids, String fieldName){
    if (ids.isEmpty()) {
        return; 
    }

    List<Program_Assignment__c> pas = SOQLHelper.getRelatedProgramAssignments(ids, fieldName);

    for (Program_Assignment__c pa : pas) {
        String contactName = pa.Contact__r != null ? pa.Contact__r.Name : null;
        String programName = pa.Program__r != null ? pa.Program__r.Name : null;
        generatePAName(pa, contactName, programName);
    }

    TriggerHandler.bypass('ProgramAssignmentTriggerHandler');       // to prevent beforeUpdate() method in ProgramAssignmentTriggerHandler being invoked
    if (!pas.isEmpty()) {
        update pas;
    }
    TriggerHandler.clearBypass('ProgramAssignmentTriggerHandler');

}


}