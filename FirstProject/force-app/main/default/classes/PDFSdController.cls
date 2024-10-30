public with sharing class PDFSdController {

    public String startDateFormat { get; set; }
    public String endDateFormat { get; set; }
    public List<ServiceDeliveryWrapper> serviceDeliveriesData {get; set;}
    public String totalServiceDeliveriesPriceCurrency {get; set;}

    public PDFSdController() {

        String programAssignmentId = ApexPages.currentPage().getParameters().get('programAssignmentId');
        Date startDate = Date.valueOf(ApexPages.currentPage().getParameters().get('startDate'));
        Date endDate = Date.valueOf(ApexPages.currentPage().getParameters().get('endDate'));
        Boolean includeNonBillable = Boolean.valueOf(ApexPages.currentPage().getParameters().get('includeNonBillable'));
        Decimal paHourRate = Decimal.valueOf(ApexPages.currentPage().getParameters().get('paHourRate'));
        Decimal totalServiceDeliveriesPrice = 0;

        startDateFormat = startDate.format();
        endDateFormat = endDate.format();

        if (startDate != null && endDate != null) {     
            String query = 'SELECT Name, Contact__r.Name, Service_Name__c, Service_Date__c, Duration__c, Short_Description__c, Billable__c ' +
                'FROM Service_Delivery__c ' +
                'WHERE Program_Assignment__c = :programAssignmentId ' +
                'AND Service_Date__c >= :startDate ' +
                'AND Service_Date__c <= :endDate ';

            if (!includeNonBillable) {
                query += 'AND (Billable__c = true)';
            }

            List<Service_Delivery__c> serviceDeliveries = (List<Service_Delivery__c>) Database.query(query);

            serviceDeliveriesData = new List<ServiceDeliveryWrapper>();
            for (Service_Delivery__c sd : serviceDeliveries) {

                if (sd.Billable__c && sd.Duration__c != null) {
                    Decimal sdPrice = (sd.Duration__c / 60) * paHourRate;
                    totalServiceDeliveriesPrice += sdPrice;
                    serviceDeliveriesData.add(new ServiceDeliveryWrapper(sd, sdPrice.setScale(2, RoundingMode.CEILING)));

                }else if (sd.Billable__c && sd.Duration__c == null) {
                    serviceDeliveriesData.add(new ServiceDeliveryWrapper(sd, 0));

                }else if (!sd.Billable__c && includeNonBillable) {
                    serviceDeliveriesData.add(new ServiceDeliveryWrapper(sd, 0));
                }
                
            }
            totalServiceDeliveriesPriceCurrency = '$' + totalServiceDeliveriesPrice.setScale(2, RoundingMode.CEILING);
        } 

    }

}
