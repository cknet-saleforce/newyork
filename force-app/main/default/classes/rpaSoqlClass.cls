public class rpaSoqlClass {
	public static String quoteId {get; set;}
    public static Pagereference addRpaProducts() {
        quoteId = ApexPages.CurrentPage().getparameters().get('recordId');
        List<Product2> pdList = [SELECT id, Business__c, Description, Family, Name FROM Product2 WHERE Business__c = 'RPA' AND Family = 'product'];
        List<QuoteLineItem> quoteList = new List<QuoteLineItem>();
        List<String> prdId = new List<String>();
        for (Product2 pr : pdList) {
            prdId.add(pr.id);
        }
        
        // Pricebook2 pbBookId = [SELECT ID FROM Pricebook2 WHERE Business = 'RPA'];
        List<PricebookEntry> pre = [SELECT id, name, Pricebook2.Name, Product2Id, UnitPrice, Pricebook2Id 
                                    FROM PricebookEntry WHERE Product2Id IN : prdId ];
        
        System.debug(pre.size());
        System.debug(pdList.size());

        for (integer i=0; i<pre.size(); i++) {
            QuoteLineItem qli = new QuoteLineItem();
            qli.QuoteId = quoteId;
            qli.Product2Id = pdList.get(i).ID;
            qli.Quantity = 1;
			quoteList.add(qli);           
        }
        
        System.debug('pdList : ' + pdList);
        System.debug('quoteId : ' + quoteId);
        System.debug('quoteList : ' + quoteList);

        List<Database.SaveResult> dsList = Database.insert(quoteList, false);
        for(Database.SaveResult sr : dsList){
            if(!sr.isSuccess()){
                for(Database.Error err : sr.getErrors()) {
                    System.debug('err.getMessage() : ' + err.getMessage());
                    System.debug('err.getFields() : ' + err.getFields());
                }
            }
        }
        
        Pagereference pg = new Pagereference (Url.getOrgDomainUrl().toExternalForm()+'/lightning/r/Quote/'+ quoteId +'/view');
        pg.setRedirect (true);
        return pg;
        
    }
}