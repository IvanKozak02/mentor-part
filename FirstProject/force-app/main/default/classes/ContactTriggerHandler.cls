public with sharing class ContactTriggerHandler extends TriggerHandler {

    List<Contact> newContacts;
    Map<Id, Contact> oldContactsMap;

    public ContactTriggerHandler() {
        newContacts = (List<Contact>) Trigger.new;
        oldContactsMap = (Map<Id, Contact>) Trigger.oldMap;

    }

    public override void afterUpdate(){
        Set<Id> contactIdsPAToUpdate = new Set<Id>();
        for (Contact c : newContacts) {
            Contact oldContact = oldContactsMap.get(c.Id);
            if (oldContact.FirstName != c.FirstName || oldContact.LastName != c.LastName) {
                contactIdsPAToUpdate.add(c.Id);
            }
        }
        if (!contactIdsPAToUpdate.isEmpty()) {
            ProgramAssignmentHelper.updateRelatedProgramAssignments(contactIdsPAToUpdate, 'Contact__c');            
        }

    }
}