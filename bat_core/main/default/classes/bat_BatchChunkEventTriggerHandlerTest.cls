@IsTest
private class bat_BatchChunkEventTriggerHandlerTest {

    @IsTest
    static void run() {
        Test.startTest();
        bat_BatchTracking.init(bat_IDGenerator.generate(Schema.AsyncApexJob.getSObjectType()));
        bat_BatchTracking.report();
        Test.stopTest();

        List<BatchChunkLog__c> logs = [SELECT Id FROM BatchChunkLog__c];
        System.assertNotEquals(0, logs.size(), 'Should have inserted a log record');
    }
}
