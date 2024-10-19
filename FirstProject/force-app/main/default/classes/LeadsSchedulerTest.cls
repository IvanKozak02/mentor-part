@isTest
private with sharing class LeadsSchedulerTest {

    @isTest
    private static void testLeadScheduler_LeadHasNoOutreaches(){
       List<Lead> leads = TestDataFactory.createMultipleLeadsWithPresetNeedAttention(5, false);
       insert leads;
       for (Lead lead : leads) {
           Test.setCreatedDate(lead.Id, DateTime.now().addDays(-4));
       }
               
        String jobId = System.schedule('Test Scheduled Batch', '0 0 0 * * ?', new LeadsScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals('0 0 0 * * ?', ct.CronExpression);

        Test.startTest();
        Database.executeBatch(new NeedAttentionLeadsBatch());
        Test.stopTest();

        List<Lead> updatedLead = [SELECT Id, Name, Need_Attention__c FROM Lead];
        for (Lead l : updatedLead) {
            System.assert(l.Need_Attention__c, 'Leads must have Need_Attention__c field true');

        }
    }

    @isTest
    private static void testLeadScheduler_LeadHasUnsuccessfulOutreaches(){
        List<Lead> leads = TestDataFactory.createMultipleLeadsWithPresetNeedAttention(5, false);
        insert leads;
        List<Outreach__c> testOutreaches = new List<Outreach__c>();
        for (Integer i = 0; i < 5; i++) {
            testOutreaches.add(new Outreach__c(Outcome__c='Not Responded', 
                                              Lead__c=leads[i].Id, 
                                              Communication_Method__c='Email'));
        }
        
        insert testOutreaches;

        Test.startTest();
        Database.executeBatch(new NeedAttentionLeadsBatch());
        Test.stopTest();

        List<Lead> updatedLead = [SELECT Id, Name, Need_Attention__c FROM Lead];
        for (Lead l : updatedLead) {
            System.assert(l.Need_Attention__c, 'Leads must have Need_Attention__c field true');
        }

    }

    @isTest
    private static void testLeadScheduler_LeadHasSuccessfulOutreachesAndNeedAttentionChecked(){
        List<Lead> leads = TestDataFactory.createMultipleLeadsWithPresetNeedAttention(5, true);
        insert leads;
        List<Outreach__c> testOutreaches = new List<Outreach__c>();
        for (Integer i = 0; i < 5; i++) {
            testOutreaches.add(new Outreach__c(Outcome__c='Responded', 
                                              Lead__c=leads[i].Id, 
                                              Communication_Method__c='Email'));
        }
        insert testOutreaches;

        Test.startTest();
        Database.executeBatch(new NeedAttentionLeadsBatch());
        Test.stopTest();

        List<Lead> updatedLeads = [SELECT Id, Name, Need_Attention__c FROM Lead];
        for (Lead l : updatedLeads) {
            System.assert(!l.Need_Attention__c, 'Leads must have Need_Attention__c field false');
        }

    }


}