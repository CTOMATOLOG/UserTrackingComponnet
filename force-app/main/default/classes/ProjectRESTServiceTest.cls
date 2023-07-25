@isTest
private class ProjectRESTServiceTest {
    @testSetup
    static void loadServiceData(){
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.DeliveryInstallationStatus__c = 'In progress';
        opportunity.CloseDate = (Date.today()).addDays(20);
        opportunity.StageName = 'Submitted Project';
        insert opportunity;
        
        Project__c project = new Project__c();
        project.ProjectRef__c = 'ProjectRef';
        project.Name = 'Test';
        project.Opportunity__c = opportunity.Id;
        project.Start_Date__c = Date.today();
        project.End_Date__c = (Date.today()).addDays(10);
        project.Billable_Amount__c = 1000;
        project.Status__c = 'Running';
        insert project;
    }
    
    @isTest    
    static void testProjectRESTService(){
        Project__c project = [SELECT Id, ProjectRef__c, Name, Opportunity__c, Start_Date__c, End_Date__c, Billable_Amount__c, Status__c FROM Project__c LIMIT 1];
        Test.startTest();
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        System.assertEquals(1,[SELECT count() FROM Opportunity]);                          
        String returnMessage = ProjectRESTService.postProjectData('ProjectRef', 'Test', String.valueOf(opportunity.Id),  Date.today(), Date.today(), 1000, 'Running');                          
        Test.stopTest();
    }
}