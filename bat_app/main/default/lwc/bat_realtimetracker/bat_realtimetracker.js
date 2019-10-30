import { track, LightningElement } from 'lwc';
import { subscribe, unsubscribe } from 'lightning/empApi';

const columns = [
    { label: 'Job ID', fieldName: 'JobId'},
    { label: 'Start time', fieldName: 'StartTimeMillis', type: 'date-local'},
    { label: 'End time', fieldName: 'EndTimeMillis', type: 'date-local'},
    { label: 'Duration', fieldName: 'Duration', type: 'number'}
]

export default class Bat_realtimetracker extends LightningElement {

    @track data = []
    @track columns = columns

    channelName = '/event/BatchChunk__e'
    subscription = {}

    get title() {
        return `Batch Tracker (live) (${this.data.length})`
    }

    handleSubscribe() {
        const messageCallback = (res) => {
            let payload = res.data.payload
            this.data = [ {
                id: res.data.event.replayId,
                StartTimeMillis: new Date(payload.StartTimeMillis__c),
                EndTimeMillis: new Date(payload.EndTimeMillis__c),
                JobId: payload.JobId__c,
                Duration: `${(payload.EndTimeMillis__c - payload.StartTimeMillis__c)}ms`
            }, ...this.data]
        }
        subscribe(this.channelName, -1, messageCallback).then(response => {
            this.subscription = response
        })
    }

    handleUnsubscribe() {
        // eslint-disable-next-line no-unused-vars
        unsubscribe(this.subscription, response => {
            //console.log('unsubscribed')
        })
    }

    connectedCallback() {
        this.handleSubscribe()
    }

    disconnectedCallback() {
        this.handleUnsubscribe()
    }
}