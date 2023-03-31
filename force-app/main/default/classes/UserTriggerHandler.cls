public with sharing class UserTriggerHandler {
    public static void beforeInsert(List<User> newList){//NOPMD

    }
    
    public static void afterInsert(List<User> newList){//NOPMD
        setUserToPublic(newList, null);
    
    }
    
    public static void beforeUpdate(List<User> newList , Map<Id , User> oldMap){//NOPMD
    
    }
    
    public static void afterUpdate(List<User> newList ,  Map<Id , User> oldMap){//NOPMD
    
    }
    
    public static void beforeDelete(List<User> oldList){//NOPMD
    
    }
    
    public static void afterDelete(List<User> oldList){//NOPMD
    
    }

    // Scenario 29	Whenever a new User having profile "System Administrator" is inserted and is Active, add the user to the public group "Admins". Create a public group named Admins.
    private static void setUserToPublic(List<User> userList , Map<Id, User> oldMap){
        List<GroupMember> groupMembers = new List<GroupMember>();
        Group adminGroup = [SELECT Id FROM Group WHERE DeveloperName = 'Admins' AND Type = 'Regular' LIMIT 1];
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        for (User user : userList) {
            if(user.ProfileId == profileId.Id && user.IsActive == true){
                groupMembers.add(
                    new GroupMember(
                        GroupId = adminGroup.Id, 
                        UserOrGroupId = user.Id
                        ));
            }
            if(!groupMembers.isEmpty()){
                insert groupMembers;
            }
        }
    }
}