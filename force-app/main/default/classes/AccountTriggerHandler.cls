public with sharing class AccountTriggerHandler {

    public static void sendforapproval(Boolean isInsert , List <Account> AccList ){
        for (Account a : AccList) {
            Approval.ProcessSubmitRequest AppReq = new Approval.ProcessSubmitRequest();
            AppReq.setComments('Account Approval Submission');
            AppReq.setObjectId(a.Id);
            Approval.ProcessResult approvalResult = Approval.process(AppReq);
            System.debug('offer submitted for approval successfully: '+approvalResult.isSuccess());
        }
    }

    public static void createContactSameNameAsAccount(Boolean isInsert , List<Account> AList){

        for(Account a:AList) {
            Contact c = new Contact();
            c.LastName = a.Name;
            c.AccountId = a.Id;
            c.password__c = 'Test@123';
            insert c;
        }
    }

    public static void DeleteOldAccountWithSameName(Boolean isInsert , List<Account> AccList){
        for(Account a:AccList) {
            List<Account> oldAcc = [SELECT Id FROM Account WHERE Name = :a.Name AND Id != :a.Id];
            delete oldAcc;
        }
    }

    // public static void task14(Boolean isUpdate , List<Account> AccList){
    //     User users = [SELECT Id FROM User WHERE Username = 'viditshah342@gmail.com' LIMIT 1];
    //     System.debug(users);
    //     AccountShare share = new AccountShare();
    //     List<AccountShare> Shareit = new List<AccountShare>();          
    //     for(Account a:AccList) {
    //         if(a.Rating == 'Hot') {
    //                 share.AccountId = a.Id;
    //                 share.RowCause = 'Manual';
    //                 share.UserOrGroupId = users.Id;
    //                 share.AccountAccessLevel = 'Read';
    //                 share.OpportunityAccessLevel = 'Read';
    //                 share.CaseAccessLevel = 'Read';
    //                 share.ContactAccessLevel = 'Read';
    //                 shareit.add(Share);
    //         }
    //     }
    //         insert shareit;
    // }

    public static void Task6_Handler(List<Account> AccList , List<Account> AccOldList ) {

        //store the account name of the account in old list
        String oldaccountname ; 
        EmailTemplate et = [SELECT id FROM EmailTemplate WHERE developername='Accountnamechange'];
        // select account where name is changed
        List<Contact> contacts = new List<Contact>();
        Set<Id> AcccIds = new Set<Id>();            
        for(Account a : AccOldList) {
            oldaccountname = a.Name;
            if(a.Name != oldaccountname && a.Name != null && oldaccountname != null) {
                AcccIds.add(a.Id);
            }
        }
        contacts = [SELECT Id,Email FROM Contact WHERE AccountId IN :AcccIds];
        for (Contact contact : contacts) {
            if (contact.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(contact.Id);
                mail.setTemplateId(et.Id);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }   
    }
}
