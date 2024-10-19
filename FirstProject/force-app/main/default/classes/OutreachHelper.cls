public with sharing class OutreachHelper {

    public static void calculateOutreachesPerLeads(Set<Id> leadsToUpdateIds){
        List<Lead> leadsToUpdate = [SELECT Id, Name, Count_Of_Outreaches__c, Count_of_successful_Outreaches__c,
                                    (SELECT Id, Outcome__c FROM Outreaches__r)
                                    FROM Lead 
                                    WHERE Id IN :leadsToUpdateIds];
        for (Lead lead : leadsToUpdate) {
            Integer countOfSuccessfulOutreaches = 0;
            for (Outreach__c outr : lead.Outreaches__r) {
                if (outr.Outcome__c == 'Accepted' || outr.Outcome__c == 'Responded') {
                    countOfSuccessfulOutreaches++;
                }
            }
            lead.Count_Of_Outreaches__c = lead.Outreaches__r.size();
            lead.Count_of_successful_Outreaches__c = countOfSuccessfulOutreaches;
        }
        update leadsToUpdate;
    }

}