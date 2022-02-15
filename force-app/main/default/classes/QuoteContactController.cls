public with sharing class QuoteContactController {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getResults(String value, Id recordId){
        try {
            List<Contact> contactResultList = new List<Contact>();
            String searchString = '%'+value+'%';
            if(String.isNotEmpty(value)){
                contactResultList = [SELECT Id, Name FROM Contact WHERE Name LIKE :searchString AND Id NOT IN (SELECT ContactId__c FROM QuoteContact__c WHERE QuoteId__c =: recordId)];
            }
            return  contactResultList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createQuoteContact(Id recordId, Id contactId){
        try {
            QuoteContact__c QCobject = new QuoteContact__c();
            QCobject.Name = [SELECT Name FROM Contact WHERE Id =: contactId].Name;
            QCobject.QuoteId__c = recordId;
            QCobject.ContactId__c = contactId;
            //system.debug('recordId는 ' + recordId);
            insert QCobject;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String addReference(Id quoteId){

            system.debug('quoteId는 '+ quoteId);
            String QuoteRef = '';
            List<QuoteContact__c> referenceList = [SELECT Name FROM QuoteContact__c WHERE QuoteId__c =: quoteId];
            // String QuoteRef= 'hello world...';
            // for(QuoteContact__c reference : referenceList){
            for(int i=0; i< referenceList.length; i++){
                QuoteRef += reference.Name;
                if (i === (referenceList.length - 1)) {
                    QuoteRef += '';
                } else {
                    QuoteRef += ', ';
                }
                system.debug('refName은 '+ reference.Name);
            }
            //String referenceName = String.join(quoteList, ', ');
            system.debug(QuoteRef);
            Quote quote = [SELECT Reference__c FROM QUOTE WHERE ID =: quoteId];
            system.debug(quote.ID);
            quote.Reference__c = QuoteRef;
            update quote;

            return QuoteRef;
        /*} catch (Exception e) {
            system.debug(e);
            throw new AuraHandledException(e.getMessage());
        }*/
    }

    @AuraEnabled
    public static string addReferenceNew(Id quoteId){
        try {
            system.debug('quoteId는 '+ quoteId);
            string sth = 'hello'; 
            return sth;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}