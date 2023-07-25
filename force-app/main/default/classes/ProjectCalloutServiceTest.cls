@isTest
private class ProjectCalloutServiceTest {

   @testSetup static void testSetupdata(){

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test opportunity';
        opportunity.Type = 'New Project';
        opportunity.Amount = 100;
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Submitted Project';
        insert opportunity;

        Opportunity opportunity2 = new Opportunity();
        opportunity2.Name = 'Test opportunity2';
        opportunity2.Type = 'New Project';
        opportunity2.Amount = 200;
        opportunity2.CloseDate = Date.today();
        opportunity2.StageName = 'Resubmit Project';
        insert opportunity2;

        ServiceTokens__c servToken = new ServiceTokens__c();
        servToken.Name = 'ProjectServiceToken';
        servToken.Token__c = 'testestetestestestes';
        insert servToken;
    }
  
  @isTest
  static void testSuccessMessage(){
      Opportunity opportunity = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test opportunity' Limit 1];
      List<Id> lstOfOppIds = new List<Id>();
      lstOfOppIds.add(opportunity.Id);
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
      Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(lstOfOppIds);
      Test.stopTest(); 
      opportunity = [SELECT StageName FROM Opportunity WHERE id =: opportunity.Id];
      System.assertEquals('Submitted Project',opportunity.StageName);     
  }
  
  @isTest
  static void testFailureMessage(){
      Opportunity opportunity = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test opportunity2' Limit 1];
      List<Id> lstOfOppIds = new List<Id>();
      lstOfOppIds.add(opportunity.Id);
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
      Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(lstOfOppIds);
      Test.stopTest();   
      opportunity = [SELECT StageName FROM Opportunity WHERE id =: opportunity.Id];
      System.assertEquals('Resubmit Project',opportunity.StageName);
  }
}