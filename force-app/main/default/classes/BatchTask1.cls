global class BatchTask1 implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT ID , NAME FROM ACCOUNT]);
    }
    global void execute(Database.BatchableContext bc, List<Account> ACClIST){
        for (Account acc : ACClIST) {
            acc.Name = acc.name + '- batch update' ;
        }
        update ACClIST;
    }    
    global void finish(Database.BatchableContext bc){
        BatchTask2 BatchTask2=new BatchTask2();
        Id batchId = Database.executeBatch(BatchTask2);   
        // System.debug('Total records processed' + recordinsertcount);
    }    
}