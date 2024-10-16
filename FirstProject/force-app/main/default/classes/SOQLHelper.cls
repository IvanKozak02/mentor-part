public with sharing class SOQLHelper {

    public static List<Program_Assignment__c> getRelatedProgramAssignments(Set<Id> Ids, String fieldName){
        String query = 'SELECT Id, Name, Start_Date__c, Status__c, Contact__r.Name, Program__r.Name, Program__c, Contact__c FROM Program_Assignment__c WHERE ' + fieldName + ' IN :ids AND Autoname__c = true';
        return Database.query(query);
    }

    public static Map<Id, Contact> getPAContacts(Set<Id> contactIds){
        Map<Id, Contact> paContacts = new Map<Id,Contact>([SELECT Id, Name FROM Contact WHERE Id IN :contactIds]);
        return paContacts;
    }

    public static Map<Id, Program__c> getPAPrograms(Set<Id> programIds){
        Map<Id, Program__c> paPrograms = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c WHERE Id IN :programIds]);
        return paPrograms;
    }

}