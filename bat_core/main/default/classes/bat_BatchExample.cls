public class bat_BatchExample implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account WHERE UUID__c = NULL');
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        bat_BatchTracking.init(bc.getJobId());

        for (Account record : scope) {
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.ConvertTohex(b);
            String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);

            record.UUID__c = guid;
        }
        update scope;

        bat_BatchTracking.report();
    }

    public void finish(Database.BatchableContext bc) {
        System.debug(LoggingLevel.INFO, 'Finish!');
        bat_BatchTracking.normalize(bc.getJobId());
    }
}
