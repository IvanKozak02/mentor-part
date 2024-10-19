public with sharing class NeedAttentionLeadsHelper {
    
    public static Set<String> getSuccessfulOutcomeStatuses() {
        List<Successful_Outreach_Outcomes__mdt> allOutreachSuccessfulStatuses = Successful_Outreach_Outcomes__mdt.getAll().values();
        Set<String> outreachSuccessfulStatusesNames = new Set<String>();

        for (Successful_Outreach_Outcomes__mdt status : allOutreachSuccessfulStatuses) {
            outreachSuccessfulStatusesNames.add(status.DeveloperName);
        }

        return outreachSuccessfulStatusesNames;
    }
 
    public static void processLeadWithoutOutreaches(Lead lead, List<Lead> leadsToUpdate, List<Lead> leadsNeedAttention) {
        Date createdDate = lead.CreatedDate.date();
        Integer daysDifference = createdDate.daysBetween(Date.today());
        if (daysDifference > 3) {
            if (!lead.Need_Attention__c) {  // Only update Need_Attention__c if it is not already true
                lead.Need_Attention__c = true;
                leadsToUpdate.add(lead);
            }
            leadsNeedAttention.add(lead);
        }
    }

    
    public static void processLeadWithOutreaches(Lead lead, Set<String> outreachSuccessfulStatusesNames, List<Lead> leadsToUpdate, List<Lead> leadsNeedAttention) {
        Boolean hasOutreachWithSuccessfulOutcome = false;
        for (Outreach__c out : lead.Outreaches__r) {
            if (outreachSuccessfulStatusesNames.contains(out.Outcome__c)) {
                hasOutreachWithSuccessfulOutcome = true;
                break;
            }
        }
        if (!hasOutreachWithSuccessfulOutcome && !lead.IsConverted) {
            if (!lead.Need_Attention__c) { 
                lead.Need_Attention__c = true;
                leadsToUpdate.add(lead);
            }
            leadsNeedAttention.add(lead);
        } else if (hasOutreachWithSuccessfulOutcome && lead.Need_Attention__c) {
            lead.Need_Attention__c = false;  // Reset Need_Attention__c field if there's a successful outreach
            leadsToUpdate.add(lead);
        }
    }



}