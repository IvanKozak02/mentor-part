public with sharing class OutreachTriggerHandler extends TriggerHandler {

    List<Outreach__c> newOutreaches;
    List<Outreach__c> oldOutreaches;
    Map<Id,Outreach__c> oldOutreachesMap;

    public OutreachTriggerHandler(){
        newOutreaches = (List<Outreach__c>) Trigger.new;
        oldOutreaches = (List<Outreach__c>) Trigger.old;
        oldOutreachesMap = (Map<Id, Outreach__c>) Trigger.oldMap;
    }

    public override void afterInsert(){
        // Outreach was inserted
        Set<Id> leadsToUpdateIds = new Set<Id>();
        for (Outreach__c outr : newOutreaches) {
            if (outr.Lead__c != null) {
                leadsToUpdateIds.add(outr.Lead__c);
            }
        }
        
        if (!leadsToUpdateIds.isEmpty()) {
            OutreachHelper.calculateOutreachesPerLeads(leadsToUpdateIds);            
        }
    }

    public override void afterUpdate(){
        // 1. Outreach Outcome was updated
        // 2. Outreach Lead was updated
        Set<Id> leadsToUpdateIds = new Set<Id>();

        for (Outreach__c outr : newOutreaches) {
            Outreach__c oldOutr = oldOutreachesMap.get(outr.Id);

            // 1. Lead was null
            if (oldOutr.Lead__c == null && outr.Lead__c != null) {
                leadsToUpdateIds.add(outr.Lead__c);
                continue;
            }

            // 2. Lead was not null and now Lead is null

            if (oldOutr.Lead__c != null && outr.Lead__c == null) {
                leadsToUpdateIds.add(oldOutr.Lead__c);
                continue;
            }

            // 3. Lead was not null and it was changed
            if (oldOutr.Lead__c != null && (outr.Lead__c != null 
                && outr.Lead__c != oldOutr.Lead__c)) {

                leadsToUpdateIds.add(oldOutr.Lead__c);
                leadsToUpdateIds.add(outr.Lead__c);
                continue;
            }

            // 4. Check if Outreach Outcome__c was changed
            if (oldOutr.Outcome__c != outr.Outcome__c 
            && (
                (oldOutr.Outcome__c != 'Accepted' && oldOutr.Outcome__c != 'Responded' 
                && (outr.Outcome__c == 'Accepted' || outr.Outcome__c == 'Responded')) 
                || (oldOutr.Outcome__c == 'Accepted' || oldOutr.Outcome__c == 'Responded'))) {
                    leadsToUpdateIds.add(outr.Lead__c);
                }
        }
        
        if (!leadsToUpdateIds.isEmpty()) {
            OutreachHelper.calculateOutreachesPerLeads(leadsToUpdateIds);            
        }
    }

    public override void afterDelete(){
        Set<Id> leadsToUpdateIds = new Set<Id>();
        for (Outreach__c outr : oldOutreaches) {
            leadsToUpdateIds.add(outr.Lead__c);
        }
        
        if (!leadsToUpdateIds.isEmpty()) {
            OutreachHelper.calculateOutreachesPerLeads(leadsToUpdateIds);            
        }
    }
}