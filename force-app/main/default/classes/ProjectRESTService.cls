@RestResource(urlMapping = '/project/*')
global with sharing class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId,
                                       Date StartDate, Date EndDate, Double Amount, String Status){
        String resultMessage  = 'Error';
                
        SavePoint savePoint = Database.setSavePoint();
        try{
            List<Opportunity> opportunityList = new List<Opportunity>();
            
            if(OpportunityId != null && OpportunityId.trim().length() > 0){
                Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c, Discount_Percent__c FROM Opportunity WHERE Id = :OpportunityId];
                opp.DeliveryInstallationStatus__c = 'In progress';
                                
                opportunityList.add(opp);
            }
            update opportunityList;
            
            List<Project__c> projectList = new List<Project__c>();
            
            Project__c project = new Project__c();
            project.ProjectRef__c = ProjectRef;
            project.Name = ProjectName;
            project.Opportunity__c = OpportunityId;
            project.Start_Date__c = StartDate;
            project.End_Date__c = EndDate;
            project.Billable_Amount__c = Amount;
            project.Status__c = Status;
            
            projectList.add(project);
            
            upsert projectList;
            
            resultMessage = 'OK';
        }catch(Exception ex){
            Database.rollback(savePoint);
            resultMessage = ex.getMessage();
        }
        return resultMessage;
    }
}