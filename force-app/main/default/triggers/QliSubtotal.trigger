trigger QliSubtotal on QuoteLineItem (after insert) {
    if (Trigger.isAfter){
        if (Trigger.isInsert) {
            Id quoteId = Trigger.New[0].QuoteId;
            List <QuoteLineItem> qliNewList = Trigger.New;
            System.debug(qliNewList);
            List<QuoteLineItem> qliList = [SELECT id, Quantity, MM__c, UnitPrice, Subtotal__c, Product2Id FROM QuoteLineItem WHERE QuoteId =: quoteId AND id IN :trigger.new];
            for (QuoteLineItem qli: qliList) {
            	Product2 p = [SELECT id, Family FROM Product2 WHERE id =: qli.Product2Id];
        
                if (p.Family == 'product') {
                    qli.Subtotal__c = qli.Quantity * (qli.MM__c / 365) * qli.UnitPrice;
                }
                if (p.Family == 'humanResource') {
                    qli.Subtotal__c = qli.Quantity * qli.MM__c * qli.UnitPrice;
                }
                update qli;
                }
        }

         	
     }
    
}