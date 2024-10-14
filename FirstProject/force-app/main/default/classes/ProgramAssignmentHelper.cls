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

        if (fieldName == 'Contact__c') {
            updatePAContactName(pa, contactName); 
        } else if (fieldName == 'Program__c') {
            updatePAProgramName(pa, programName);
        }
    }

    if (!pas.isEmpty()) {
        update pas;
    }
}


public static void updatePAStartDate(Program_Assignment__c pa){
    String contactAndProgramNames = pa.Name.split(':')[0].trim();
    if (pa.Start_Date__c != null) {
        String startDateToUpdate = pa.Start_Date__c.format();
        pa.Name = contactAndProgramNames + ' : ' + startDateToUpdate;
    } else {
        pa.Name = contactAndProgramNames.trim();            
    }
}
public static void updatePAContactName(Program_Assignment__c pa, String newContactName){
    // update contact name
    String programNameAndStartDate = pa.Name.split(' - ')[1].trim();
    if (pa.Contact__c != null) {
        pa.Name = newContactName + ' - ' + programNameAndStartDate;
    } else {
        pa.Name = programNameAndStartDate.trim();            
    }
}
public static void updatePAProgramName(Program_Assignment__c pa, String newProgramName){
    String contactName = pa.Name.split(' - ')[0].trim();
    String startDate = pa.Start_Date__c != null ? pa.Start_Date__c.format() : '';
    String nameSuffix = startDate != '' ? ' : ' + startDate : '';

    if (pa.Program__c != null) {
        pa.Name = contactName + ' - ' + newProgramName + nameSuffix;
    } else {
        pa.Name = contactName + nameSuffix;      
    }
}


}