global with sharing class NeedAttentionLeadsBatch implements Database.Batchable<SObject>, Database.stateful {
    
    List<Lead> leadsNeedAttention = new List<Lead>();

    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, isConverted, CreatedDate, Need_Attention__c, (SELECT Id, Outcome__c FROM Outreaches__r) FROM Lead';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Lead> leads) {
        // Get successful Outcome statuses from Custom metadata type
        Set<String> outreachSuccessfulStatusesNames = NeedAttentionLeadsHelper.getSuccessfulOutcomeStatuses();
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead lead : leads) {
            if (lead.Outreaches__r.isEmpty() && !lead.IsConverted) {
                NeedAttentionLeadsHelper.processLeadWithoutOutreaches(lead, leadsToUpdate, leadsNeedAttention);
            } else {
                NeedAttentionLeadsHelper.processLeadWithOutreaches(lead, outreachSuccessfulStatusesNames, leadsToUpdate, leadsNeedAttention);
            }
        }
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {UserInfo.getUserEmail()};
        String body = EmailSenderHelper.getEmailBody(leadsNeedAttention);
        mail.setTargetObjectId( UserInfo.getUserId() );
        mail.setSaveAsActivity( false );
        mail.setToAddresses(toAddresses);
        mail.setSubject('Leads Needing Attention: Batch Job Completed');
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}