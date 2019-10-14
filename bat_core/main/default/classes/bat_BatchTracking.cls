public without sharing class bat_BatchTracking {

    @TestVisible
    private static BatchChunk__e evt;

    public static BatchChunk__e init(Id jobId) {
        if (!System.isBatch() && !Test.isRunningTest()) {
            throw new bat_BatchTrackingException('Not in a batch context.');
        }
        Datetime start = System.now();
        evt = new BatchChunk__e(
            JobId__c = jobId,
            Start__c = start,
            StartTimeMillis__c = start.getTime()
        );
        return evt;
    }

    public static void report() {
        Datetime endx = System.now();
        evt.End__c = endx;
        evt.EndTimeMillis__c = endx.getTime();
        evt.RuntimeMillis__c = evt.EndTimeMillis__c - evt.StartTimeMillis__c;
        Eventbus.publish(evt);
    }

    public static void normalize(Id jobId) {
        List<BatchChunkLog__c> logs = [
            SELECT Id, Start__c
            FROM BatchChunkLog__c
            WHERE JobId__c = :jobId
            ORDER BY StartTimeMillis__c
        ];
        if (logs.size() > 1) {
            for (Integer i= 1; i < logs.size(); i++) {
                logs[i].PreviousChunkLog__c = logs[i-1].Id;
            }
            update logs;
        }
    }
}
