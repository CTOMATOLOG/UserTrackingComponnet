public with sharing class UserService {
   
    public static List<User> obtainAllUsers() {
        List<User> userList = [SELECT Id, Name, Alias, IsActive FROM User];   
        return userList;
    }

    public static void changeUserStatus(Boolean status, Id accountId) {
        Id userId = UserInfo.getUserId();
        User_Status_Event__e userStatusChange = new User_Status_Event__e();
        userStatusChange.isUserOnline__c = status;
        userStatusChange.userId__c = userId;
        if(accountId != null){
            Account account = [SELECT Name FROM Account WHERE Id =: accountId LIMIT 1];
            userStatusChange.accountId__c = accountId;
            userStatusChange.Account_Name__c = account.Name;
        }
        System.debug('Event posted');
        System.debug(userStatusChange);
        Database.SaveResult result = EventBus.publish(userStatusChange);
        if (!result.isSuccess()) {
            for (Database.Error error : result.getErrors()) {
                System.debug('Error returned: ' + error.getStatusCode() +' - '+ error.getMessage());
            }
        }
    }
}