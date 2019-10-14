@IsTest
private class bat_BatchTrackingTest {

    @IsTest
    static void run() {
        Id jobId = bat_IDGenerator.generate(Schema.AsyncApexJob.getSObjectType());

        bat_BatchTracking.init(jobId);
        System.assertNotEquals(null, bat_BatchTracking.evt, 'platform event object must be created');
        System.assertNotEquals(null, bat_BatchTracking.evt.Start__c, 'platform event must have its start date/time initialized');

        bat_BatchTracking.report();

        System.assertNotEquals(null, bat_BatchTracking.evt.End__c, 'platform event must have its end date/time initialized');
        System.assertNotEquals(null, bat_BatchTracking.evt.RuntimeMillis__c, 'platform event must have its duration initialized');

        Test.getEventBus().deliver();

        BatchChunkLog__c log = [SELECT
            Id,
            JobId__c,
            Start__c,
            End__c,
            RuntimeMillis__c,
            StartTimeMillis__c,
            EndTimeMillis__c
            FROM BatchChunkLog__c
        ];

        BatchChunkLog__c logCopy = log.clone(false, true, false, false);
        logCopy.StartTimeMillis__c += 1000;
        logCopy.EndTimeMillis__c += 1000;
        insert logCopy;

        bat_BatchTracking.normalize(jobId);
    }
}
