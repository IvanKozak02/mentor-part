public with sharing class PDFServiceDeliveriesGenerator {
    @AuraEnabled
    public static String generateAndAttachPdf(String programAssignmentId, String startDateString, String endDateString, Boolean includeNonBillable) {
        Date startDate = Date.valueOf(startDateString);
        Date endDate = Date.valueOf(endDateString);
        Program_Assignment__c pa = [SELECT Id, Hour_Rate__c FROM Program_Assignment__c WHERE Id =:programAssignmentId LIMIT 1];

        Decimal hourRate = 0;
        if (pa.Hour_Rate__c != null) {
            hourRate = pa.Hour_Rate__c;
        }

        PageReference pdfPage = Page.InvoicePDF;
        pdfPage.getParameters().put('programAssignmentId', programAssignmentId);
        pdfPage.getParameters().put('paHourRate', String.valueOf(hourRate));
        pdfPage.getParameters().put('startDate', startDateString);
        pdfPage.getParameters().put('endDate', endDateString);
        pdfPage.getParameters().put('includeNonBillable', String.valueOf(includeNonBillable));

        Blob pdfBlob = pdfPage.getContentAsPDF();

        // Save the PDF to Files
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'Invoice_' + programAssignmentId;
        contentVersion.PathOnClient = 'Invoice.pdf';
        contentVersion.VersionData = pdfBlob;
        contentVersion.FirstPublishLocationId = programAssignmentId;
        insert contentVersion;

        return 'PDF generated and attached successfully';
    }
}