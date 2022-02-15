import { LightningElement, api, track } from 'lwc';
import getResults from '@salesforce/apex/QuoteContactController.getResults';
import createQuoteContact from '@salesforce/apex/QuoteContactController.createQuoteContact';
import addReference from '@salesforce/apex/QuoteContactController.addReference';
import addReferenceNew from '@salesforce/apex/QuoteContactController.addReferenceNew';

export default class SearchContactForm extends LightningElement {
    @api iconName = 'action:new_contact';
    @api recordId;
    @track searchRecords = [];
    
    searchContact(event){
        var currentText = event.target.value;

        var sth = addReferenceNew({quoteId: this.recordId});
        console.log(sth);
        getResults({value:currentText, recordId:this.recordId})
        .then(result => {
            this.searchRecords = result;
        })
        .catch(error => {
            console.log(error);
        });
    };

    setSelectedContact(event){
        var contactId = event.currentTarget.dataset.id;
        var quoteId = this.recordId;
        //create QuoteContactRecord with ContactId 
        //QuoteRecordId, ContactId 를 보내줘야..
        //console.log('quoteId insert: ', this.recordId);
        //console.log('contactId insert: ', contactId);
        console.log('반영됨');
        // var controllercalled = addReference({quoteId:quoteId}).then(result => {
        //     console.log(result);
        // }).catch(error => {
        //     console.log(error);
        // });
        // console.log(controllercalled);
        createQuoteContact({recordId: this.recordId, contactId: contactId})
        .then(result => {
            console.log(result);
            console.log('hello ' , quoteId);
            var referenceName = addReference({quoteId:quoteId}).then(resultAddRef => {
                console.log(resultAddRef);
            }).catch(errorAddRef => {
                console.log(errorAddRef);
            });
            console.log(referenceName);
        }).catch(error => {
            console.log(error);
        });
        
        this.template.querySelectorAll('lightning-input').forEach(each => {
            each.value = '';
        }); 
        this.searchRecords = []; //MVVM 패턴.. binding되어있기 때문
    };

}