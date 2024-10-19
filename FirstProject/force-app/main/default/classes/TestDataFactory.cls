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

    public static List<Outreach__c> createOutreachesWithPresetLeadAndOutcome(Integer countOfOutreaches, Id leadId, String outcome){
        List<Outreach__c> testOutreaches = new List<Outreach__c>();
        
        for (Integer i = 0; i < countOfOutreaches; i++) {
            testOutreaches.add(new Outreach__c(
                Outcome__c=outcome, 
                Lead__c=leadId, 
                Communication_Method__c='Email'));
        }

        return testOutreaches;
    }

    public static Lead createSingleLead(){
        return new Lead(
            LastName = 'Test Lead 1',
            Company = 'Test Company',
            Need_Attention__c = false,
            Status = 'New'
        );
    }

    public static List<Lead> createMultipleLeadsWithPresetNeedAttention(Integer countOfLeads,Boolean needAttention){
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < countOfLeads; i++) {
            testLeads.add(new Lead(
                LastName = 'Test Lead ' + i,
                Company = 'Test Company',
                Need_Attention__c = needAttention,
                Status = 'New'
            ));
        }
        return testLeads;
    }
    
}