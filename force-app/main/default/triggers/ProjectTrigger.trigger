trigger ProjectTrigger on Project__c (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        for(Project__c project : Trigger.new){
            if(project.Status__c != null && project.Status__c.equals('Billable')){
                BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
            }
        }
    }
}