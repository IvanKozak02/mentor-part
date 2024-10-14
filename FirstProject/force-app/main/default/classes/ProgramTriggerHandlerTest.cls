@isTest
private class ProgramTriggerHandlerTest {

    @isTest
    static void testAfterUpdate() {
        Contact testContact = TestDataFactory.createContacts(1)[0];
        Program__c initialProgram = TestDataFactory.createPrograms(1)[0];

        List<Program_Assignment__c> pas = TestDataFactory.createMultipleProgramAssignments(testContact.Id, initialProgram.Id,'Applied', 10);

        initialProgram.Name = 'Updated Program';
        testContact.LastName = 'Updated Contact';
        update initialProgram;
        update testContact;

        pas = [SELECT Id, Name FROM Program_Assignment__c WHERE Program__c = :initialProgram.Id AND Contact__c = :testContact.Id];

        String expectedName = 'Updated Contact' + ' - ' + 'Updated Program' + ' : ' + Date.Today().format();
        for (Program_Assignment__c pa : pas) {
            System.assertEquals(expectedName, pa.Name, 'The Program Assignment name should reflect updated program name and contact name.');            
        }
    }

    @isTest
    public static void testBeforeDeleteProgramsWithAssignmentsStatusNotAllowed(){
        Contact testContact = TestDataFactory.createContacts(1)[0];
        Program__c testProgram = TestDataFactory.createPrograms(1)[0];

        List<Program_Assignment__c> pasDenied = TestDataFactory.createMultipleProgramAssignments(testContact.Id, testProgram.Id, 'Completed', 5);

        Test.startTest();
        try {
            delete testProgram;
            System.assert(false, 'Expected a DMLException to be thrown due to assignments with non-allowed statuses.');
        } catch (DmlException e) {
            System.debug(e.getMessage());
            System.assert(e.getMessage().contains('Cannot Delete Program because it has PAs with Status Completed'));
        }
        Test.stopTest();

    }

    @isTest
    public static void testBeforeDeleteProgramsWithAllowedAssignmentsStatus(){
        Contact testContact = TestDataFactory.createContacts(1)[0];
        Program__c testProgram = TestDataFactory.createPrograms(1)[0];

        List<Program_Assignment__c> pasApplied = TestDataFactory.createMultipleProgramAssignments(testContact.Id, testProgram.Id, 'Applied', 5);

        Test.startTest();
        delete testProgram;
        Test.stopTest();

        List<Program_Assignment__c> pasRelatedToProgram = [SELECT Id FROM Program_Assignment__c WHERE Program__c = :testProgram.Id];

        System.assert(pasRelatedToProgram.isEmpty(), 'All related Program Assignments have to be deleted.');

    }
}