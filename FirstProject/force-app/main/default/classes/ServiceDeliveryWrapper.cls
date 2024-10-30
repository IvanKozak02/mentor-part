public class ServiceDeliveryWrapper {
    public Service_Delivery__c serviceDelivery {get; set;}
    public String price {get; set;}
    
    public ServiceDeliveryWrapper(Service_Delivery__c sd, Decimal sdPrice) {
        serviceDelivery = sd;
        price = '$' + sdPrice;
    }
}