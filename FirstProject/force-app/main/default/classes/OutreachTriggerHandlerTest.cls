@isTest
public with sharing class OutreachTriggerHandlerTest {
    @isTest
    private static void testOureachTrigger_afterInsert(){
        Lead lead = TestDataFactory.createSingleLead();
        insert lead;
        List<Outreach__c> testOutreaches = TestDataFactory.createOutreachesWithPresetLeadAndOutcome(5,lead.Id, 'Accepted');
        testOutreaches.addAll(TestDataFactory.createOutreachesWithPresetLeadAndOutcome(5, lead.Id, 'Not Responded'));
        
        Test.startTest();
        insert testOutreaches;
        Test.stopTest();

        Lead updatedLead = [SELECT Id, Count_Of_Outreaches__c, Count_of_successful_Outreaches__c FROM Lead LIMIT 1];
        System.assertEquals(10, updatedLead.Count_Of_Outreaches__c);
        System.assertEquals(5, updatedLead.Count_of_successful_Outreaches__c);
    }

    @isTest
    private static void testOureachTrigger_afterUpdate_testOutrLeadChanges(){
        Lead lead1 = TestDataFactory.createSingleLead();
        Lead lead2 = TestDataFactory.createSingleLead();
        insert new List<Lead>{lead1, lead2};


        List<Outreach__c> testOutreaches = TestDataFactory.createOutreachesWithPresetLeadAndOutcome(3,lead1.Id, 'Accepted');
        testOutreaches.addAll(TestDataFactory.createOutreachesWithPresetLeadAndOutcome(2,lead1.Id, 'Not Responded'));
        testOutreaches.addAll(TestDataFactory.createOutreachesWithPresetLeadAndOutcome(3,null, 'Accepted'));
        testOutreaches.addAll(TestDataFactory.createOutreachesWithPresetLeadAndOutcome(2,null, 'Not Responded'));
        testOutreaches.addAll(TestDataFactory.createOutreachesWithPresetLeadAndOutcome(3,lead1.Id, 'Accepted'));
        testOutreaches.addAll(TestDataFactory.createOutreachesWithPresetLeadAndOutcome(2,lead1.Id, 'Not Responded'));

        insert testOutreaches;
        for (Integer i = 0; i < 5; i++) {
            testOutreaches[i].Lead__c = null;
        }
        
        for (Integer i = 5; i < 10; i++) {
            testOutreaches[i].Lead__c = lead1.Id;
        }

        for (Integer i = 10; i < 15; i++) {
            testOutreaches[i].Lead__c = lead2.Id;
        }

        Test.startTest();
        update testOutreaches;
        Test.stopTest();

        Lead updatedLead1 = [SELECT Id, Count_Of_Outreaches__c, Count_of_successful_Outreaches__c FROM Lead WHERE Id = :lead1.Id LIMIT 1];
        Lead updatedLead2 = [SELECT Id, Count_Of_Outreaches__c, Count_of_successful_Outreaches__c FROM Lead WHERE Id = :lead2.Id LIMIT 1];
        
        System.assertEquals(5, updatedLead1.Count_Of_Outreaches__c, 'Lead 1 is supposed to have overall 5 Outreaches');
        System.assertEquals(3, updatedLead1.Count_of_successful_Outreaches__c,'Lead 1 is supposed to have 3 Successful Outreaches');

        System.assertEquals(5, updatedLead2.Count_Of_Outreaches__c, 'Lead 2 is supposed to have overall 5 Outreaches');
        System.assertEquals(3, updatedLead2.Count_of_successful_Outreaches__c,'Lead 2 is supposed to have 3 Successful Outreaches');

    }


    @isTest
    private static void testOureachTrigger_afterUpdate_testOutrOutcomeChanged(){
        Lead lead = TestDataFactory.createSingleLead();
        insert lead;

        List<Outreach__c> testOutreaches = TestDataFactory.createOutreachesWithPresetLeadAndOutcome(5,lead.Id, 'Accepted');
        testOutreaches.addAll(TestDataFactory.createOutreachesWithPresetLeadAndOutcome(5,lead.Id, 'Not Responded'));
        insert testOutreaches;

        for (Integer i = 0; i < testOutreaches.size(); i++) {
            if (i < 5) {
                testOutreaches[i].Outcome__c = 'Not Responded';
            }else {
                testOutreaches[i].Outcome__c = 'Responded';
            }
        }

        Test.startTest();
        update testOutreaches;
        Test.stopTest();
        
        Lead updatedLead = [SELECT Id, Count_Of_Outreaches__c, Count_of_successful_Outreaches__c FROM Lead LIMIT 1];
        System.assertEquals(10, updatedLead.Count_Of_Outreaches__c, 'Lead is supposed to have overall 10 Outreaches');
        System.assertEquals(5, updatedLead.Count_of_successful_Outreaches__c,'Lead is supposed to have 5 successful Outreaches');
    }

    @isTest
    private static void testOureachTrigger_afterDelete(){
        Lead lead = TestDataFactory.createSingleLead();
        insert lead;

        List<Outreach__c> testOutreaches = TestDataFactory.createOutreachesWithPresetLeadAndOutcome(5,lead.Id, 'Accepted');
        insert testOutreaches;

        Test.startTest();
        delete testOutreaches;
        Test.stopTest();
        
        Lead leadWithoutOutreaches = [SELECT Id, Count_Of_Outreaches__c, Count_of_successful_Outreaches__c FROM Lead LIMIT 1];
        System.assertEquals(0, leadWithoutOutreaches.Count_Of_Outreaches__c, 'Lead is not supposed to have Outreaches');
        
    }

}