public with sharing class ServiceDeliveryController {


    @AuraEnabled(cacheable=true)
    public static String getFields(String objectName, String fieldSetName){
        List<Schema.FieldSetMember> fieldSetObject = getFieldSet(objectName, fieldSetName);
        return JSON.serialize(fieldSetObject);
    }

    @AuraEnabled(cacheable=true)
    public static List<Service_Delivery__c> getServiceDeliveryData(String recordId, String objectName, String fieldSetName){
        List<String> fields = new List<String>();
        for (Schema.FieldSetMember field : getFieldSet(objectName, fieldSetName)) {
            if (field.getFieldPath() == 'Contact__c') {
                fields.add('Contact__r.Name');
                continue;                
            }
            fields.add(field.getFieldPath());
        }

        String queryStr = 'SELECT ' + String.join(fields, ', ') + ' FROM Service_Delivery__c WHERE Program_Assignment__c = \'' + recordId + '\'';
        return Database.query(queryStr);
    }

    @AuraEnabled
    public static string updateServiceDeliveries(Object data) {
        List<Service_Delivery__c> sdForUpdate = (List<Service_Delivery__c>) JSON.deserialize(
            JSON.serialize(data),
            List<Service_Delivery__c>.class
        );
        try {
            if (!sdForUpdate.isEmpty()) {
                update sdForUpdate;
                return 'Success: SD updated successfully';
            }
            return 'No update';
        }
        catch (Exception e) {
            return 'The following exception has occurred: ' + e.getMessage();
        }
    }
    
    @AuraEnabled
    public static string createServiceDeliveries(Object data) {
        List<Service_Delivery__c> sdToInsert = (List<Service_Delivery__c>) JSON.deserialize(
            JSON.serialize(data),
            List<Service_Delivery__c>.class
        );

        try {
            if (!sdToInsert.isEmpty()) {
                insert sdToInsert;
                return 'Success: Service Delivaries were created successfully.';
            }
            return 'Sorry, cannot create service deliveries...';
        }
        catch (Exception e) {
            return 'The following exception has occurred: ' + e.getMessage();
        }
    }

    public static List<Schema.FieldSetMember> getFieldSet(String objectName, String fieldSetName){
        Schema.DescribeSObjectResult describeSobjectResultObj = Schema.getGlobalDescribe().get(objectName).getDescribe();
        System.debug(describeSobjectResultObj.fieldsets.getMap().get(fieldSetName));
        List<Schema.FieldSetMember> fieldSetObject = describeSobjectResultObj.fieldsets.getMap().get(fieldSetName).getFields();
        return fieldSetObject;
    }
}