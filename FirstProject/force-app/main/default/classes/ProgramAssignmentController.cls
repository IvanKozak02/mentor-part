public with sharing class ProgramAssignmentController {
    @AuraEnabled
    public static List<Program_Assignment__c> getProgramAssignmentsByContact(String contactId, String objectName, String fieldSetName){
        System.debug(contactId);
        List<String> fields = new List<String>();
        for (Schema.FieldSetMember field : ServiceDeliveryController.getFieldSet(objectName, fieldSetName)) {
            fields.add(field.getFieldPath());
        }
        String queryStr = 'SELECT ' + String.join(fields, ', ') + ', Id, Program__r.Name, Contact__r.Name FROM Program_Assignment__c WHERE Contact__c = \'' + contactId + '\'';
        return Database.query(queryStr);
    }
}