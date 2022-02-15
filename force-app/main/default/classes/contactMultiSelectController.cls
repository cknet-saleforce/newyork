public with sharing class contactMultiSelectController {
    public contactMultiSelectController() {

    }
    @AuraEnabled(cacheable=true)
    public static List<SObJectResult> getResults(String ObjectName, String fieldName, String phone, String value, List<String> selectedRecId) {
        List<SObJectResult> sObjectResultList = new List<SObJectResult>();
        system.debug(fieldName+'-------------'+ObjectName+'---++----------'+value+'====='+selectedRecId);
        if(selectedRecId == null)
            selectedRecId = new List<String>();

        if(String.isNotEmpty(value)) {
            String query = 'Select Id, '+fieldName+', '+phone+' FROM '+ObjectName+' WHERE '+fieldName+' LIKE \'%' + value.trim() + '%\' and ID NOT IN: selectedRecId';
            system.debug(query);
            for(sObject so : Database.Query(query)) {
                String fieldvalue = (String)so.get(fieldName);
                String phoneNum = (String)so.get(phone);
                sObjectResultList.add(new SObjectResult(fieldvalue, so.Id, phoneNum));
            }
            system.debug(sObjectResultList);
        }

        return sObjectResultList;
    }
    
    public class SObjectResult {
        @AuraEnabled
        public String recName;
        @AuraEnabled
        public Id recId;
        @AuraEnabled
        public String recPhone;
        
        public SObJectResult(String recNameTemp, Id recIdTemp, String recPhone) {
            recName = recNameTemp;
            recId = recIdTemp;
            recPhone = recPhone;
        }
        public SObJectResult() {
          
        }
    }
}