@isTest
public class TestDataFactory {
    public static List<Contact> createContacts(Integer count){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < count; i++){
            contacts.add(new Contact(LastName='Test Contact ' + i));
        }
        insert contacts;
        
        return contacts;
    }
    
    public static List<Program__c> createPrograms(Integer count){
        List<Program__c> programs = new List<Program__c>();
        for(Integer i = 0; i < count; i++){
            programs.add(new Program__c(Name='Test Program ' + i, Type__c='Skill', Status__c='Active'));
        }
        insert programs;
        
        return programs;
    }
    public static Program_Assignment__c createTestProgramAssignment(Id contactId, Id programId, Date startDate, String status, Boolean autoName) {
        Program_Assignment__c testPA = new Program_Assignment__c(
            Contact__c = contactId,
            Program__c = programId,
            Start_Date__c = startDate,
            Status__c = status,
            Autoname__c = autoName
        );
        return testPA;
    }
    public static List<Program_Assignment__c> createMultipleProgramAssignments(Id contactId, Id programId, String status, Integer count) {
        List<Program_Assignment__c> programAssignments = new List<Program_Assignment__c>();
        for (Integer i = 0; i < count; i++) {
            programAssignments.add(new Program_Assignment__c(
                Contact__c = contactId,
                Program__c = programId,
                Status__c = status,
                Start_Date__c = Date.today(),
                Autoname__c = true
            ));
        }
        insert programAssignments;
        return programAssignments;
    }
    
}