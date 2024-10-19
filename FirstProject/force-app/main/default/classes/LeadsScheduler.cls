global with sharing class LeadsScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        NeedAttentionLeadsBatch nalb = new NeedAttentionLeadsBatch();
        Database.executeBatch(nalb);
     }
}