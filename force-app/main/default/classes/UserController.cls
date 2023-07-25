public with sharing class UserController {

    

    @AuraEnabled
    public static List<User> obtainAllUsers() {   
        return UserService.obtainAllUsers();
    }

    @AuraEnabled
    public static void changeUserStatus(Boolean status, Id accountId) {
       UserService.changeUserStatus(status, accountId);
    }
}