@isTest
private class BillingCalloutServiceTest {
  @testSetup 
  static void makeData(){
      
      Opportunity opportunity = new Opportunity();
      opportunity.Name = 'Op1';
      opportunity.CloseDate = Date.today();
      opportunity.StageName = 'Prospecting';
      insert opportunity;
      
      Project__c project = new Project__c();
      project.Name = 'Pj1';
      project.Billable_Amount__c = 1000;        
      project.ProjectRef__c = 'Reference';
      project.Status__c = 'Running';
      project.Opportunity__c = opportunity.Id;
      insert project;
      
      ServiceCredentials__c serviceCredentials = new ServiceCredentials__c();
      serviceCredentials.Name = 'BillingServiceCredential';
      serviceCredentials.Username__c = 'user';
      serviceCredentials.Password__c = 'password';
      insert serviceCredentials;
  }
  
  @isTest 
  static void testCalloutSuccess(){
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock()); 
      List<Project__c> project = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'Reference'];
      System.assertEquals(1, project.size());
      Test.startTest(); 
      project[0].Status__c = 'Billable';
      update project;
      Test.stopTest();
  }
  
  @isTest 
  static void testCalloutFailure(){
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure()); 
      List<Project__c> project = [SELECT Status__C FROM Project__c WHERE ProjectRef__c = 'Reference'];
      System.assertEquals(1, project.size());
      Test.startTest(); 
      project[0].Status__c = 'Running';
      update project;
      Test.stopTest();
  }
}
