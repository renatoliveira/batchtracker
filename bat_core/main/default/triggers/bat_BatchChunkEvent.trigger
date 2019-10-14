trigger bat_BatchChunkEvent on BatchChunk__e (after insert) {
    new bat_BatchChunkEventTriggerHandler(Trigger.new);
}