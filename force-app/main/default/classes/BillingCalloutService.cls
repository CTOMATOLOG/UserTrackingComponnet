public class BillingCalloutService {
    @future(callout = true)
    public static void callBillingService(String projectRef, Decimal billingAmount){
        ServiceCredentials__c serviceCredential = ServiceCredentials__c.getValues('BillingServiceCredential');
                
        BillingServiceProxy.project billingProject = new BillingServiceProxy.project();
        billingProject.username = serviceCredential.Username__c;
        billingProject.password = serviceCredential.Password__c;
        billingProject.billAmount = billingAmount;
        
        BillingServiceProxy.InvoicesPortSoap11 invPortSoapInst = new BillingServiceProxy.InvoicesPortSoap11();
        String response = invPortSoapInst.billProject(billingProject);
        
        List<Project__c> projectList = new List<Project__c>();
        if(response != null && response.equalsIgnoreCase('OK')){
            List<Project__c> selectedProjectList = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = :projectRef];
            for(Project__c project_i : selectedProjectList){
                project_i.Status__c = 'Billed';
                
                projectList.add(project_i);
            }
            
            update projectList;
        }
    }
}