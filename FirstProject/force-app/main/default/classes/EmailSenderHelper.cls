public with sharing class EmailSenderHelper {
    
    public static String getEmailBody(List<Lead> leads){
        Integer countLeadNeedAttention = leads.size();
        String emailBody = '<h1>Hello ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + '</h1>';
        emailBody += '<p>We have successfully processed the batch job, and here are the results:   ' + countLeadNeedAttention + '</p>';
        emailBody += '<h2>List of leads that need attention: </h2>';
        emailBody += '<ul style="padding-top: 30px;">' + getLeadList(leads) + '</ul>';
        return emailBody;
    }

    private static String getLeadList(List<Lead> leads){
        String leadListStr = '';
        for (Lead lead : leads) {
            leadListStr += '<li>' + lead.Id + ' - ' + lead.Name + '</li>';
        }
        return leadListStr;
    }
}