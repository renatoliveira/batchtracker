public without sharing class bat_BatchChunkEventTriggerHandler {
    /**
     * Working with the premise that it will be one event at a time, even though this is bulkified
     * code.
     */
    public bat_BatchChunkEventTriggerHandler(List<BatchChunk__e> records) {
        List<BatchChunkLog__c> logs = new List<BatchChunkLog__c>();

        for (BatchChunk__e event : records) {
            BatchChunkLog__c log = new BatchChunkLog__c(
                Start__c = event.Start__c,
                StartTimeMillis__c = event.StartTimeMillis__c,
                EndTimeMillis__c = event.EndTimeMillis__c,
                End__c = event.End__c,
                RuntimeMillis__c = event.RuntimeMillis__c,
                JobId__c = event.JobId__c
            );
            logs.add(log);
        }
        insert logs;
    }
}
