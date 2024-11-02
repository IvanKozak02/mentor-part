public with sharing class PDFServiceDeliveriesGenerator {
    @AuraEnabled
    public static String generatePDFPreview(String programAssignmentId, String startDateString, String endDateString, Boolean includeNonBillable) {
        Date startDate = Date.valueOf(startDateString);
        Date endDate = Date.valueOf(endDateString);
        Program_Assignment__c pa = [SELECT Id, Hour_Rate__c FROM Program_Assignment__c WHERE Id =:programAssignmentId LIMIT 1];

        Decimal hourRate = 0;
        if (pa.Hour_Rate__c != null) {
            hourRate = pa.Hour_Rate__c;
        }
        // ...?programAssignmentId=dddd&paHourRate=dfgdfg
        PageReference pdfPage = Page.InvoicePDF;        // page url
        pdfPage.getParameters().put('programAssignmentId', programAssignmentId);
        pdfPage.getParameters().put('paHourRate', String.valueOf(hourRate));
        pdfPage.getParameters().put('startDate', startDateString);
        pdfPage.getParameters().put('endDate', endDateString);
        pdfPage.getParameters().put('includeNonBillable', String.valueOf(includeNonBillable));
        return String.valueOf(pdfPage);
    }


    @AuraEnabled
    public static String saveNewPDFFile(String pdfURL) {
    
        PageReference page = new PageReference(pdfURL);
        String paId = page.getParameters().get('programAssignmentId');
        try {
            Blob pdfBlob = page.getContentAsPDF();
            // Save the PDF to Files
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'Invoice_' + paId;
            contentVersion.PathOnClient = 'Invoice.pdf';
            contentVersion.VersionData = pdfBlob;
            contentVersion.FirstPublishLocationId = paId;
            insert contentVersion;
            return 'PDF generated and attached successfully';
        } catch (Exception e) {
            return 'Something went wrong...' + e.getMessage();
        }

    }

}