@isTest
private class ProgramAssignmentTriggerHandlerTest {
    
    @IsTest
    private static void testBeforeInsertTrigger() {
        Contact testContact = TestDataFactory.createContacts(1)[0];
        Program__c testProgram = TestDataFactory.createPrograms(1)[0];

        Program_Assignment__c pa1 = TestDataFactory.createTestProgramAssignment(
            testContact.Id, testProgram.Id, Date.today(), 'Applied', true
        );
        Program_Assignment__c pa2 = TestDataFactory.createTestProgramAssignment(
            testContact.Id, testProgram.Id, null, 'Applied', true
        );

        Test.startTest();
        insert pa1;
        insert pa2;
        Test.stopTest();

        Program_Assignment__c insertedPA1 = [SELECT Name, Start_Date__c FROM Program_Assignment__c WHERE Id = :pa1.Id];
        Program_Assignment__c insertedPA2 = [SELECT Name, Start_Date__c FROM Program_Assignment__c WHERE Id = :pa2.Id];

        String expectedNameForPA1 = 'Test Contact 0' + ' - ' + 'Test Program 0' + ' : ' + Date.TODAY().format();
        System.assertEquals(expectedNameForPA1, insertedPA1.Name, 'PA Name format is not correct');

        String expectedNameForPA2 = 'Test Contact 0' + ' - ' + 'Test Program 0';
        System.assertEquals(expectedNameForPA2, insertedPA2.Name, 'PA Name format is not correct');
    }
    @isTest
    private static void testBeforeUpdate_StartDateChanged() {
        Contact testContact = TestDataFactory.createContacts(1)[0];
        Program__c testProgram = TestDataFactory.createPrograms(1)[0];

        Program_Assignment__c pa1 = TestDataFactory.createTestProgramAssignment(
            testContact.Id, testProgram.Id, Date.today().addDays(-1), 'Applied',true
        );

        Program_Assignment__c pa2 = TestDataFactory.createTestProgramAssignment(
            testContact.Id, testProgram.Id, Date.today(), 'Applied',true
        );
        insert pa1;
        insert pa2;

        Test.startTest();
        pa1.Start_Date__c = Date.today();
        pa2.Start_Date__c = null;
        update pa1;
        update pa2;
        Test.stopTest();
        
        Program_Assignment__c updatedPA1 = [SELECT Name FROM Program_Assignment__c WHERE Id = :pa1.Id];
        Program_Assignment__c updatedPA2 = [SELECT Name FROM Program_Assignment__c WHERE Id = :pa2.Id];

        String expectedNameForPA1 = 'Test Contact 0' + ' - ' + 'Test Program 0' + ' : ' + Date.TODAY().format();
        System.assertEquals(expectedNameForPA1,updatedPA1.Name, 'PA 1 Name should be updated with the new Start Date');

        String expectedNameForPA2 = 'Test Contact 0' + ' - ' + 'Test Program 0';
        System.assertEquals(expectedNameForPA2, updatedPA2.Name, 'PA Name should be updated without new Start Date');
        
    }

    @isTest
    private static void testBeforeUpdate_ContactChanged() {
        List<Contact> testContacts = TestDataFactory.createContacts(2);
        Program__c testProgram = TestDataFactory.createPrograms(1)[0];
        Program_Assignment__c pa = TestDataFactory.createTestProgramAssignment(
            testContacts[0].Id, testProgram.Id, Date.today(),'Applied', true
        );
        insert pa;
        Test.startTest();
        pa.Contact__c = testContacts[1].Id;
        update pa;
        Test.stopTest();
        
        Program_Assignment__c updatedPA = [SELECT Name FROM Program_Assignment__c WHERE Id = :pa.Id];
        System.assert(updatedPA.Name.contains('Test Contact 1'), 'PA Name should be updated with the new Contact Name');
    }

    @isTest
    private static void testBeforeUpdate_ProgramChanged() {
        List<Program__c> testPrograms = TestDataFactory.createPrograms(2);
        Contact testContact = TestDataFactory.createContacts(1)[0];
        Program_Assignment__c pa = TestDataFactory.createTestProgramAssignment(
            testContact.Id, testPrograms[0].Id, Date.today(),'Applied', true
        );
        insert pa;
        Test.startTest();
        pa.Program__c = testPrograms[1].Id;
        update pa;
        Test.stopTest();
        
        Program_Assignment__c updatedPA = [SELECT Name FROM Program_Assignment__c WHERE Id = :pa.Id];
        System.assert(updatedPA.Name.contains('Test Program 1'), 'PA Name should be updated with the new Program Name');
    }

    @isTest
    private static void testBeforeUpdate_AutonameFieldChanged() {
        Contact testContact = TestDataFactory.createContacts(1)[0];
        Program__c testProgram = TestDataFactory.createPrograms(1)[0];
        Program_Assignment__c pa = TestDataFactory.createTestProgramAssignment(testContact.Id, testProgram.Id, Date.Today(), 'Applied', false);
        insert pa;

        Test.startTest();
        pa.Autoname__c = true;
        update pa;
        Test.stopTest();
        
        Program_Assignment__c updatedPA = [SELECT Name FROM Program_Assignment__c WHERE Id = :pa.Id];     

        String expectedName = 'Test Contact 0' + ' - ' + 'Test Program 0' + ' : ' + Date.Today().format();
        System.assertEquals(expectedName, updatedPA.Name, 'PA Name should be generated after Autoname was enabled');
    }
    
    
}