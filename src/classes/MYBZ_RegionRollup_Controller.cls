/*
 *@ Class Name                                                    : MYBZ_RegionRollup_Controller
 *@ Description                                                   : Class for retrieving salesforce data in the form of a string and returning as a JSON object via a remote action.
 *@ CreatedBy                                                     : Gaurav Suri
 *@ CreatedOn                                                     : 09-30-2014
 *@ Modification Log                                              :
 */
global with sharing class MYBZ_RegionRollup_Controller
{
  /* 
         * @Method Name                    :  mysampledata
         * @Description                    :  JavaScript remoting to allow mysampledata method to be called in a javascript controller and return data 
                                              retrieved from Salesforce in the form of a JSON object. 
         * @Return Type                    :  object
         * @Param                          :  abc
                                           
   */
  
    
    global static String targetGoalDistrictName {get;set;}
    
    global static String productTrendRegionName {get;set;}
    global static String productTrendDistrictName {get;set;}
    global static String productTrendTerritoryName {get;set;}
    
    global static String marketShareRegionName {get;set;}
    global static String marketShareDistrictName {get;set;}
    global static String marketShareTerritoryName {get;set;}
    
   
    global static String pickerRegionName{get;set;}
    global static String pickerDistrictName{get;set;}
    global static String pickerTerritoryName{get;set;}
    
    global static Id UserId;
    global static String Role{get;set;}
    global static String GlobalId{get;set;}
    global static String uname{get;set;}
    global static String regPassed {get;set;}
    global static String disPassed {get;set;}
    global static String terPassed {get;set;}
    
    global MYBZ_RegionRollup_Controller(){
        UserId = UserInfo.getUserId();
        User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        uname=userObj.name;
        pickerDistrictName = '';
    }
    public static void test(){
    system.debug('regPassed--'+regPassed);
    system.debug('disPassed--'+disPassed);
    system.debug('terPassed--'+terPassed);
    
    }
    public static void TerritoryPicker(){
        
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        system.debug('Role---'+Role);
        system.debug('pickerDistrictName--'+pickerDistrictName);
        if(Role == 'Major Marketing Manager' && pickerDistrictName !=null && pickerDistrictName !=''){}
            //TargetGoal();
        
    }
    @RemoteAction 
    global static Object RegionRollup()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        JSONGenerator gen;
        
        MYBZ_IHS_Division__c divisionObj = [SELECT Name FROM MYBZ_IHS_Division__c LIMIT 1];
        
        Set<Id> regionIds = new Set<Id>();
        Set<Id> districtIds = new Set<Id>();
        String firstRegionName;
        
        Map<String, Map<String, List<MYBZ_Region__c>>> RegionNameAndRegionListMap = new Map<String, Map<String, List<MYBZ_Region__c>>>();
        Map<String, Set<String>> RegionNameAndDistrictMap = new Map<String, Set<String>>();
        Map<String, Map<String, List<MYBZ_District__c>>> DistrictNameAndDistrictListMap = new  Map<String, Map<String, List<MYBZ_District__c>>>();
        Map<String, Set<String>> DistrictNameAndTerritoryMap = new Map<String, Set<String>>();
        Map<String, Map<String, List<MYBZ_Territory__c>>> TerritoryNameAndTerritoryListMap = new Map<String, Map<String, List<MYBZ_Territory__c>>>();
        Map<String, Map<String, DateTime>> DateNameAndDatesMap = new Map<String, Map<String, DateTime>>();
        
        List <MYBZ_Region__c> regionList = [SELECT Name, Range__c, TRxStartDates__c, NRxStartDates__c, OpexStartDates__c, GrossMarginStartDates__c, NetProfitStartDates__c, Global_Id__c, Parent__c, Product__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_Region__c WHERE Parent__c =: divisionObj.id];
        if(!regionList.isEmpty()){
            firstRegionName = regionList[0].Name;
            for(MYBZ_Region__c regionObj : regionList){
                if(!RegionNameAndRegionListMap.containsKey(regionObj.Name)){
                    Map<String, List<MYBZ_Region__c>> MonthAndRegionMap = new Map<String, List<MYBZ_Region__c>>();
                    List<MYBZ_Region__c> tempRegionList = new List<MYBZ_Region__c>();
                    tempRegionList.add(regionObj);
                    MonthAndRegionMap.put(regionObj.Range__c, tempRegionList);
                    RegionNameAndRegionListMap.put(regionObj.Name, MonthAndRegionMap);
                }
                else{
                    if(RegionNameAndRegionListMap.get(regionObj.Name).containsKey(regionObj.Range__c)){
                        RegionNameAndRegionListMap.get(regionObj.Name).get(regionObj.Range__c).add(regionObj);
                    }
                    else{
                        List<MYBZ_Region__c> tempRegionList = new List<MYBZ_Region__c>();
                        tempRegionList.add(regionObj);
                        RegionNameAndRegionListMap.get(regionObj.Name).put(regionObj.Range__c, tempRegionList);
                    }
                }
                regionIds.add(regionObj.id);
            }
        }
        
        if(!regionIds.isEmpty()){
            List<MYBZ_Region__c> regions = [SELECT Id, Range__c, TRxStartDates__c, NRxStartDates__c, OpexStartDates__c, GrossMarginStartDates__c, NetProfitStartDates__c, Global_Id__c, Parent__c, Product__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_Region__c WHERE Parent__c =: divisionObj.id AND Name =:firstRegionName];
            for(MYBZ_Region__c regionObj : regions){
                if(!DateNameAndDatesMap.containsKey('trxStartDates')){
                    Map<String, DateTime> RangeAndTRxValueMap = new Map<String, DateTime>();
                    RangeAndTRxValueMap.put(regionObj.Range__c, regionObj.TRxStartDates__c);
                    DateNameAndDatesMap.put('trxStartDates',RangeAndTRxValueMap);
                }
                if(!DateNameAndDatesMap.containsKey('nrxStartDates')){
                    Map<String, DateTime> RangeAndNRxValueMap = new Map<String, DateTime>();
                    RangeAndNRxValueMap.put(regionObj.Range__c, regionObj.NRxStartDates__c);
                    DateNameAndDatesMap.put('nrxStartDates',RangeAndNRxValueMap);
                }
                if(!DateNameAndDatesMap.containsKey('opexStartDates')){
                    Map<String, DateTime> RangeAndOpexValueMap = new Map<String, DateTime>();
                    RangeAndOpexValueMap.put(regionObj.Range__c, regionObj.OpexStartDates__c);
                    DateNameAndDatesMap.put('opexStartDates',RangeAndOpexValueMap);
                }
                if(!DateNameAndDatesMap.containsKey('grossMarginsStartDates')){
                    Map<String, DateTime> RangeAndGrossValueMap = new Map<String, DateTime>();
                    RangeAndGrossValueMap.put(regionObj.Range__c, regionObj.GrossMarginStartDates__c);
                    DateNameAndDatesMap.put('grossMarginsStartDates',RangeAndGrossValueMap);
                }
                if(!DateNameAndDatesMap.containsKey('netProfitStartDates')){
                    Map<String, DateTime> RangeAndNetProfitValueMap = new Map<String, DateTime>();
                    RangeAndNetProfitValueMap.put(regionObj.Range__c, regionObj.NetProfitStartDates__c);
                    DateNameAndDatesMap.put('netProfitStartDates',RangeAndNetProfitValueMap);
                }
                else
                {
                    if(!DateNameAndDatesMap.get('trxStartDates').containsKey(regionObj.Range__c)){
                        DateNameAndDatesMap.get('trxStartDates').put(regionObj.Range__c,regionObj.TRxStartDates__c);
                    }
                    if(!DateNameAndDatesMap.get('nrxStartDates').containsKey(regionObj.Range__c)){
                        DateNameAndDatesMap.get('nrxStartDates').put(regionObj.Range__c,regionObj.NRxStartDates__c);
                    }
                    if(!DateNameAndDatesMap.get('opexStartDates').containsKey(regionObj.Range__c)){
                        DateNameAndDatesMap.get('opexStartDates').put(regionObj.Range__c,regionObj.OpexStartDates__c);
                    }
                    if(!DateNameAndDatesMap.get('grossMarginsStartDates').containsKey(regionObj.Range__c)){
                        DateNameAndDatesMap.get('grossMarginsStartDates').put(regionObj.Range__c,regionObj.GrossMarginStartDates__c);
                    }
                    if(!DateNameAndDatesMap.get('netProfitStartDates').containsKey(regionObj.Range__c)){
                        DateNameAndDatesMap.get('netProfitStartDates').put(regionObj.Range__c,regionObj.NetProfitStartDates__c);
                    }
                }
            }
            for(MYBZ_District__c districtObj : [SELECT Name, Global_Id__c, Range__c, Product__r.Name, Region__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_District__c WHERE Region__c IN: regionIds]){
                if(!RegionNameAndDistrictMap.containsKey(districtObj.Region__r.Name)){
                    Set<String> districtNames = new Set<String>();
                    districtNames.add(districtObj.Name);
                    RegionNameAndDistrictMap.put(districtObj.Region__r.Name, districtNames);
                }
                else{
                    RegionNameAndDistrictMap.get(districtObj.Region__r.Name).add(districtObj.Name);
                }
                if(!DistrictNameAndDistrictListMap.containsKey(districtObj.Name)){
                    Map<String, List<MYBZ_District__c>> MonthAndDistrictMap = new Map<String, List<MYBZ_District__c>>();
                    List<MYBZ_District__c> tempDistrictList = new List<MYBZ_District__c>();
                    tempDistrictList.add(districtObj);
                    
                    MonthAndDistrictMap.put(districtObj.Range__c, tempDistrictList);
                    DistrictNameAndDistrictListMap.put(districtObj.Name, MonthAndDistrictMap);
                }
                else{
                    if(DistrictNameAndDistrictListMap.get(districtObj.Name).containsKey(districtObj.Range__c)){
                        DistrictNameAndDistrictListMap.get(districtObj.Name).get(districtObj.Range__c).add(districtObj);
                    }
                    else{
                        List<MYBZ_District__c> tempDistrictList = new List<MYBZ_District__c>();
                        tempDistrictList.add(districtObj);
                        DistrictNameAndDistrictListMap.get(districtObj.Name).put(districtObj.Range__c, tempDistrictList);
                    }
                }
                districtIds.add(districtObj.Id);
            }
            
        }
        if(!districtIds.isEmpty()){
            for(MYBZ_Territory__c territoryObj : [SELECT Id, Name, Range__c, State__r.Name, Product__r.Name, TRx__c, NRx__c FROM MYBZ_Territory__c WHERE State__c IN:districtIds]){
                if(!DistrictNameAndTerritoryMap.containsKey(territoryObj.State__r.Name)){
                    Set<String> territoryNames = new Set<String>();
                    territoryNames.add(territoryObj.Name);
                    DistrictNameAndTerritoryMap.put(territoryObj.State__r.Name, territoryNames);
                }
                else{
                    DistrictNameAndTerritoryMap.get(territoryObj.State__r.Name).add(territoryObj.Name);
                }
                if(!TerritoryNameAndTerritoryListMap.containsKey(territoryObj.Name)){
                
                    Map<String, List<MYBZ_Territory__c>> MonthAndTerritoryMap = new Map<String, List<MYBZ_Territory__c>>();
                    List<MYBZ_Territory__c> tempTerritoryList = new List<MYBZ_Territory__c>();
                    tempTerritoryList.add(territoryObj);
                    
                    MonthAndTerritoryMap.put(territoryObj.Range__c, tempTerritoryList);
                    TerritoryNameAndTerritoryListMap.put(territoryObj.Name, MonthAndTerritoryMap);
                }
                else{
                    if(TerritoryNameAndTerritoryListMap.get(territoryObj.Name).containsKey(territoryObj.Range__c)){
                        TerritoryNameAndTerritoryListMap.get(territoryObj.Name).get(territoryObj.Range__c).add(territoryObj);
                    }
                    else{
                        List<MYBZ_Territory__c> tempTerritoryList = new List<MYBZ_Territory__c>();
                        tempTerritoryList.add(territoryObj);
                        TerritoryNameAndTerritoryListMap.get(territoryObj.Name).put(territoryObj.Range__c, tempTerritoryList);
                    }
                }
            }
        }

        if(!DateNameAndDatesMap.isEmpty() && !RegionNameAndRegionListMap.isEmpty() && !RegionNameAndDistrictMap.isEmpty() && !DistrictNameAndDistrictListMap.isEmpty() && !DistrictNameAndTerritoryMap.isEmpty() && !TerritoryNameAndTerritoryListMap.isEmpty())
        {
            gen = JSON.createGenerator(true);
            gen.writeStartObject();  
            gen.writeStringField('name',divisionObj.Name);
            
            for(String dateNames : DateNameAndDatesMap.keySet()){
                gen.writeFieldName(dateNames);
                gen.writeStartObject();
                Map<String, DateTime> RangeAndValueMap = DateNameAndDatesMap.get(dateNames);
                for(String range : RangeAndValueMap.keySet()){
                    gen.writeDateTimeField(range+'StartDate',RangeAndValueMap.get(range));
                }
                gen.writeEndObject();
            }
            gen.writeFieldName('children');
            gen.writeStartArray();   
            for (String regionName : RegionNameAndRegionListMap.keySet())
            {
                gen.writeStartObject(); 
                gen.writeStringField('name',regionName);
                if(!RegionNameAndRegionListMap.isEmpty()){                    
                    if(RegionNameAndRegionListMap.get(regionName) !=null){
                        Map<String, List<MYBZ_Region__c>> regionsMap = RegionNameAndRegionListMap.get(regionName);
                        for(String range : regionsMap.keySet()){
                            gen.writeFieldName(range);
                            gen.writeStartArray();
                            for(MYBZ_Region__c tempRegionObj : regionsMap.get(range)){
                                gen.writeStartObject();
                                gen.writeStringField('name',tempRegionObj.Product__r.Name);
                                gen.writeNumberField('trxValue',tempRegionObj.TRx__c);
                                gen.writeNumberField('nrxValue',tempRegionObj.NRx__c);
                                gen.writeNumberField('opex',tempRegionObj.OPEX__c);
                                gen.writeNumberField('grossMargins',tempRegionObj.Gross_Margin__c);
                                gen.writeNumberField('netProfit',tempRegionObj.Net_Profit__c);
                                gen.writeEndObject();
                            }
                            gen.writeEndArray();
                        }
                    }
                }
                if(RegionNameAndDistrictMap.get(regionName) !=null){
                    gen.writeFieldName('children');
                    gen.writeStartArray();  
                    for(String districtName : RegionNameAndDistrictMap.get(regionName)){
                        gen.writeStartObject(); 
                        gen.writeStringField('name',districtName);
                        if(!DistrictNameAndDistrictListMap.isEmpty()){
                            if(DistrictNameAndDistrictListMap.get(districtName) !=null){
                                Map<String, List<MYBZ_District__c>> districtsMap = DistrictNameAndDistrictListMap.get(districtName);
                                for(String range : districtsMap.keySet()){
                                    gen.writeFieldName(range);
                                    gen.writeStartArray();
                                    for(MYBZ_District__c tempDistrictObj : districtsMap.get(range)){
                                        gen.writeStartObject();
                                        gen.writeStringField('name',tempDistrictObj.Product__r.Name);
                                        gen.writeNumberField('trxValue',tempDistrictObj.TRx__c);
                                        gen.writeNumberField('nrxValue',tempDistrictObj.NRx__c);
                                        gen.writeNumberField('opex',tempDistrictObj.OPEX__c);
                                        gen.writeNumberField('grossMargins',tempDistrictObj.Gross_Margin__c);
                                        gen.writeNumberField('netProfit',tempDistrictObj.Net_Profit__c);
                                        gen.writeEndObject();
                                    }
                                    gen.writeEndArray();
                                }
                            }
                        }
                        if(DistrictNameAndTerritoryMap.get(districtName) !=null){
                            gen.writeFieldName('children');
                            gen.writeStartArray();
                            for(String territoryName : DistrictNameAndTerritoryMap.get(districtName)){
                                gen.writeStartObject(); 
                                gen.writeStringField('name',territoryName);
                                if(!TerritoryNameAndTerritoryListMap.isEmpty()){
                                    if(TerritoryNameAndTerritoryListMap.get(territoryName) !=null){
                                        Map<String, List<MYBZ_Territory__c>> territoryMap = TerritoryNameAndTerritoryListMap.get(territoryName);
                                        for(String range : territoryMap.keySet()){
                                            gen.writeFieldName(range);
                                            gen.writeStartArray();
                                            for(MYBZ_Territory__c tempTerritoryObj : territoryMap.get(range)){
                                                gen.writeStartObject();
                                                gen.writeStringField('name',tempTerritoryObj.Product__r.Name);
                                                gen.writeNumberField('trxValue',tempTerritoryObj.TRx__c);
                                                gen.writeNumberField('nrxValue',tempTerritoryObj.NRx__c);
                                                gen.writeEndObject();
                                            }
                                            gen.writeEndArray();
                                        }
                                    }
                                }
                                gen.writeEndObject();
                            }
                            gen.writeEndArray();
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                }
                gen.writeEndObject();
            }
            gen.writeEndArray();
            gen.writeEndObject();
        }
        
        String sdata = gen.getAsString();
        System.debug('--sdata--RegionRollup'+sdata );
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    @RemoteAction 
    global static Object Alignment()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        JSONGenerator gen;
        gen = JSON.createGenerator(true);
        /*if(Role == 'Sales Representative'){
            List < MYBZ_Territory__c > salesRepTerritoryList = [SELECT Name, Global_Id__c, State__r.Name, State__r.Global_Id__c, Region_Name__c, Region_Global_ID__c FROM MYBZ_Territory__c WHERE Global_Id__c = :GlobalId LIMIT 1];
            if(!salesRepTerritoryList.isEmpty()){
                gen.writeStartArray();
                gen.writeStartObject();
                for(MYBZ_Territory__c territoryObj : salesRepTerritoryList){
                    gen.writeStringField('name',territoryObj.Region_Name__c);
                    gen.writeStringField('globalID',territoryObj.Region_Global_ID__c);
                    gen.writeFieldName('children');
                    gen.writeStartArray();
                    gen.writeStartObject();
                    gen.writeStringField('name',territoryObj.State__r.Name);
                    gen.writeStringField('globalID',territoryObj.State__r.Global_Id__c);
                    gen.writeFieldName('children');
                    gen.writeStartArray();
                    gen.writeStartObject();
                    gen.writeStringField('name',territoryObj.Name);
                    gen.writeStringField('globalID',territoryObj.Global_Id__c);
                    gen.writeEndObject();
                    gen.writeEndArray();
                    gen.writeEndObject();
                    gen.writeEndArray();
                }
                gen.writeEndObject();
                gen.writeEndArray();
            }
        }
        if(Role == 'District Sales Manager'){
            List <MYBZ_District__c> districtManagerList = [SELECT Id, Name, Global_Id__c, Region__r.Name, Region__r.Global_Id__c FROM MYBZ_District__c WHERE Global_Id__c =: GlobalId LIMIT 1];
            Map<String, String> TerritoryNameAndGlobalIdMap = new Map<String, String>();
            
            if(!districtManagerList.isEmpty()){
                Id districtId = districtManagerList[0].Id;
                
                for(MYBZ_Territory__c territoryObj : [SELECT Name, Global_Id__c FROM MYBZ_Territory__c WHERE State__c =:districtId]){
                    if(!TerritoryNameAndGlobalIdMap.containsKey(territoryObj.Name)){
                        TerritoryNameAndGlobalIdMap.put(territoryObj.Name, territoryObj.Global_Id__c);
                    }
                }
            }
            if(!districtManagerList.isEmpty() && !TerritoryNameAndGlobalIdMap.isEmpty()){
                gen.writeStartArray();
                gen.writeStartObject();
                for(MYBZ_District__c districtObj : districtManagerList){
                    gen.writeStringField('name',districtObj.Region__r.Name);
                    gen.writeStringField('globalID',districtObj.Region__r.Global_Id__c);
                    gen.writeFieldName('children');
                    gen.writeStartArray();
                    gen.writeStartObject();
                    gen.writeStringField('name',districtObj.Name);
                    gen.writeStringField('globalID',districtObj.Global_Id__c);
                    gen.writeFieldName('children');
                    gen.writeStartArray();
                    if(!TerritoryNameAndGlobalIdMap.isEmpty()){
                        for(String territoryName : TerritoryNameAndGlobalIdMap.keySet()){
                            gen.writeStartObject();
                            gen.writeStringField('name',territoryName);
                            gen.writeStringField('globalID',TerritoryNameAndGlobalIdMap.get(territoryName));
                            gen.writeEndObject();
                        }
                    }
                    gen.writeEndArray();
                    gen.writeEndObject();
                    gen.writeEndArray();
                }
                gen.writeEndObject();
                gen.writeEndArray();
            }
        }
        if(Role == 'Major Marketing Manager'){
            List <MYBZ_Region__c> regionalManagerList = [SELECT Id, Name, Global_Id__c FROM MYBZ_Region__c WHERE Global_Id__c =: GlobalId LIMIT 1];
            Map<String, String> DistrictNameAndGlobalIdMap = new Map<String, String>();
            Map<String, List<MYBZ_Territory__c>> DistrictNameAndTerritoryListMap = new Map<String, List<MYBZ_Territory__c>>();
            
            if(!regionalManagerList.isEmpty()){
                Id regionId = regionalManagerList[0].Id;
                
                for(MYBZ_District__c districtObj : [SELECT Id, Name, Global_Id__c FROM MYBZ_District__c WHERE Region__c =:regionId]){
                    if(!DistrictNameAndGlobalIdMap.containsKey(districtObj.Name)){
                        DistrictNameAndGlobalIdMap.put(districtObj.Name, districtObj.Global_Id__c);
                    }
                }
                if(!DistrictNameAndGlobalIdMap.isEmpty()){
                    for(MYBZ_Territory__c territoryObj : [SELECT Id, Name, Global_Id__c, State__r.Name FROM MYBZ_Territory__c WHERE State__r.Name IN: DistrictNameAndGlobalIdMap.keySet()]){
                        if(!DistrictNameAndTerritoryListMap.containsKey(territoryObj.State__r.Name)){
                            List<MYBZ_Territory__c> territoryList = new List<MYBZ_Territory__c>();
                            territoryList.add(territoryObj);
                        }
                        else{
                            DistrictNameAndTerritoryListMap.get(territoryObj.State__r.Name).add(territoryObj);
                        }
                    }
                }
            }
            if(!regionalManagerList.isEmpty() && !DistrictNameAndGlobalIdMap.isEmpty() && !DistrictNameAndTerritoryListMap.isEmpty()){
                gen.writeStartArray();
                gen.writeStartObject();
                for(MYBZ_Region__c regionObj : regionalManagerList){
                    gen.writeStringField('name',regionObj.Name);
                    gen.writeStringField('globalID',regionObj.Global_Id__c);
                }
                gen.writeFieldName('children');
                gen.writeStartArray();
                for(String districtName : DistrictNameAndGlobalIdMap.keySet()){
                    gen.writeStartObject();
                    gen.writeStringField('name',districtName);
                    gen.writeStringField('globalID',DistrictNameAndGlobalIdMap.get(districtName));
                    if(DistrictNameAndTerritoryListMap.containsKey(districtName)){
                        gen.writeFieldName('children');
                        gen.writeStartArray();
                        for(MYBZ_Territory__c territoryObj : DistrictNameAndTerritoryListMap.get(districtName)){
                            gen.writeStartObject();
                            gen.writeStringField('name',territoryObj.Name);
                            gen.writeStringField('globalID',territoryObj.Global_Id__c);
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();
                    }
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
                gen.writeEndArray();
            }
        }*/
        
        Set<Id> regionIds = new Set<Id>();
        Set<Id> districtIds = new Set<Id>();
        MYBZ_IHS_Division__c divisionObj = [SELECT Id, Name FROM MYBZ_IHS_Division__c LIMIT 1];
        Map<String, String> RegionNameAndGlobalIdMap = new Map<String, String>();
        Map<String, Set<String>> RegionNameAndDistrictMap = new Map<String, Set<String>>();
        Map<String, String> DistrictNameAndGlobalIdMap = new Map<String, String>();
        Map<String, Set<String>> DistrictNameAndTerritoryMap = new Map<String, Set<String>>();
        Map<String, String> TerritoryNameAndGlobalIdMap = new Map<String, String>();
        
        List <MYBZ_Region__c> regionList = [SELECT Id, Name, Global_Id__c FROM MYBZ_Region__c WHERE Parent__c = : divisionObj.id];
        if(!regionList.isEmpty())
        {
            for(MYBZ_Region__c regionObj : regionList){
                if(!RegionNameAndGlobalIdMap.containsKey(regionObj.Name)){
                    RegionNameAndGlobalIdMap.put(regionObj.Name, regionObj.Global_Id__c);
                }
                regionIds.add(regionObj.Id);
            }
        }
        for(MYBZ_District__c districtObj : [SELECT Id, Name, Global_Id__c, Region__r.Name FROM MYBZ_District__c WHERE Region__c IN: regionIds]){
            districtIds.add(districtObj.Id);
            if(!RegionNameAndDistrictMap.containsKey(districtObj.Region__r.Name)){
                Set<String> districtNames = new Set<String>();
                districtNames.add(districtObj.Name);
                RegionNameAndDistrictMap.put(districtObj.Region__r.Name, districtNames);
            }
            else{
                RegionNameAndDistrictMap.get(districtObj.Region__r.Name).add(districtObj.Name);
            }
            if(!DistrictNameAndGlobalIdMap.containsKey(districtObj.Name)){
                DistrictNameAndGlobalIdMap.put(districtObj.Name, districtObj.Global_Id__c);
            }
        }
        for(MYBZ_Territory__c territoryObj : [SELECT Id, Name, Global_Id__c, State__r.Name FROM MYBZ_Territory__c WHERE State__c IN: districtIds]){
            if(!DistrictNameAndTerritoryMap.containsKey(territoryObj.State__r.Name)){
                Set<String> territoryNames = new Set<String>();
                territoryNames.add(territoryObj.Name);
                DistrictNameAndTerritoryMap.put(territoryObj.State__r.Name, territoryNames);
            }
            else{
                DistrictNameAndTerritoryMap.get(territoryObj.State__r.Name).add(territoryObj.Name);
            }
            if(!TerritoryNameAndGlobalIdMap.containsKey(territoryObj.Name)){
                TerritoryNameAndGlobalIdMap.put(territoryObj.Name, territoryObj.Global_Id__c);
            }
        }
            
        if(!RegionNameAndGlobalIdMap.isEmpty() && !RegionNameAndDistrictMap.isEmpty() && !DistrictNameAndGlobalIdMap.isEmpty() && !DistrictNameAndTerritoryMap.isEmpty() && !TerritoryNameAndGlobalIdMap.isEmpty()){
            gen.writeStartArray();
            System.debug('Inside');
            for(String regionName : RegionNameAndGlobalIdMap.keySet()){
                gen.writeStartObject();
                gen.writeStringField('name',regionName);
                String regionGlobalId = RegionNameAndGlobalIdMap.get(regionName);
                gen.writeStringField('globalID',regionGlobalId);
                
                if(RegionNameAndDistrictMap.containsKey(regionName)){
                    gen.writeFieldName('children');
                    gen.writeStartArray();
                    
                    for(String districtName : RegionNameAndDistrictMap.get(regionName)){
                        gen.writeStartObject();
                        gen.writeStringField('name',districtName);
                        String districtGlobalId = DistrictNameAndGlobalIdMap.get(districtName);
                        gen.writeStringField('globalID',districtGlobalId);
                        if(DistrictNameAndTerritoryMap.containsKey(districtName)){
                            gen.writeFieldName('children');
                            gen.writeStartArray();
                            for(String territoryName : DistrictNameAndTerritoryMap.get(districtName)){
                                gen.writeStartObject();
                                gen.writeStringField('name',territoryName);
                                String territoryGlobalId = TerritoryNameAndGlobalIdMap.get(territoryName);
                                if(territoryGlobalId == null || territoryGlobalId == '')
                                    gen.writeNullField('globalID'); 
                                else
                                    gen.writeStringField('globalID',territoryGlobalId);
                                gen.writeEndObject();
                            }
                            gen.writeEndArray();
                        }
                        gen.writeEndObject();
                    }
                    gen.writeEndArray();
                }
                gen.writeEndObject();
            }
            gen.writeEndArray();
        }
        
        String sdata = gen.getAsString();
        System.debug('sdata'+sdata );
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    
    public static void ParamtersFunctionForTargetGoal(){
        if(targetGoalDistrictName !=null && targetGoalDistrictName !=''){
            //TargetGoal();
        }
    }
    
    @RemoteAction 
    global static Object TargetGoal()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        JSONGenerator gen;
        List<MYBZ_Target_Goal__c> targetGoalList;
        
        Set<Decimal> targetGoalYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>> YearAndMonthTargetGoalMap = new Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>>();
        system.debug('Role---'+Role);
        system.debug('targetGoalDistrictName--'+targetGoalDistrictName);
        system.debug('pickerDistrictName--'+pickerDistrictName);
        system.debug('disPassed---'+disPassed);
        
        if((Role == 'District Sales Manager' || Role == 'Major Marketing Manager') && targetGoalDistrictName == null && disPassed == null){
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == 'Sales Representative'){
            MYBZ_Territory__c territoryObj = [SELECT Id, State__r.Name FROM MYBZ_Territory__c WHERE Global_Id__c =:GlobalId LIMIT 1];
            String associatedDistrictName = territoryObj.State__r.Name;
            system.debug('associatedDistrictName--'+associatedDistrictName);
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:associatedDistrictName AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == 'Major Marketing Manager' && targetGoalDistrictName !=null && targetGoalDistrictName !=''){
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:targetGoalDistrictName ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == 'Major Marketing Manager' && disPassed !=null && disPassed !=''){
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:disPassed AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        system.debug('targetGoalList---'+targetGoalList);
        if(!targetGoalList.isEmpty()){
            for(MYBZ_Target_Goal__c targetGoalObj : targetGoalList){
                targetGoalYear.add(targetGoalObj.Year__c);
            }
        }
        if(!targetGoalYear.isEmpty()){
            for(Decimal year : targetGoalYear){
                for(MYBZ_Target_Goal__c targetGoalObj : targetGoalList){
                    if(targetGoalObj.Year__c == year){
                        if(!YearAndMonthsMap.containsKey(year)){
                            Set<Decimal> MonthsSet = new Set<Decimal>();
                            MonthsSet.add(targetGoalObj.Month__c);
                            YearAndMonthsMap.put(year, MonthsSet);
                        }
                        else{
                            YearAndMonthsMap.get(year).add(targetGoalObj.Month__c);
                        }
                    }
                }
            }
        }
        if(!targetGoalYear.isEmpty() && !YearAndMonthsMap.isEmpty()){
            for(Decimal year : targetGoalYear){
                Map<Decimal, List<MYBZ_Target_Goal__c>> MonthAndTargetGoalMap = new Map<Decimal, List<MYBZ_Target_Goal__c>>();
                if(YearAndMonthsMap.containsKey(year)){
                    for(Decimal month : YearAndMonthsMap.get(year)){
                        List<MYBZ_Target_Goal__c> targetGoalMonthList = new List<MYBZ_Target_Goal__c>();
                        for(MYBZ_Target_Goal__c targetGoalObj : targetGoalList){
                            if(targetGoalObj.Month__c == month && targetGoalObj.Year__c == year){
                                targetGoalMonthList.add(targetGoalObj);
                            }
                        }
                        MonthAndTargetGoalMap.put(month, targetGoalMonthList);
                    }
                }
                YearAndMonthTargetGoalMap.put(year, MonthAndTargetGoalMap);
            }
        }
        if(!targetGoalYear.isEmpty() && !YearAndMonthTargetGoalMap.isEmpty()){
            gen = JSON.createGenerator(true);
            gen.writeStartArray();
            for(Decimal year : targetGoalYear){
                if(YearAndMonthTargetGoalMap.containsKey(year)){
                    Map<Decimal, List<MYBZ_Target_Goal__c>> TempMonthAndTargetGoalMap = YearAndMonthTargetGoalMap.get(year);
                    for(Decimal month : TempMonthAndTargetGoalMap.keySet()){
                        gen.writeStartObject();
                        gen.writeNumberField('month',month);
                        gen.writeNumberField('year',year);
                        if(TempMonthAndTargetGoalMap.get(month) !=null){
                            gen.writeFieldName('goals');
                            gen.writeStartArray();
                            for(MYBZ_Target_Goal__c targetGoalObj : TempMonthAndTargetGoalMap.get(month)){
                                gen.writeStartObject();
                                gen.writeStringField('productName',targetGoalObj.Product__r.Name);
                                gen.writeNumberField('goalSet',targetGoalObj.TRx_Goal__c);
                                gen.writeNumberField('goalMet',targetGoalObj.TRx_Goal_Attainment__c);
                                gen.writeEndObject();
                            }
                            gen.writeEndArray();
                        }
                        gen.writeEndObject();
                    }
                }
            }
            gen.writeEndArray();
        }
        String sdata = gen.getAsString();
        System.debug('sdata----'+sdata);
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    public static void ParamtersFunctionForProductTrends(){
        if(productTrendRegionName !=null && productTrendRegionName !=''){
            ProductTrends();
        }
        if(productTrendDistrictName !=null && productTrendDistrictName !=''){
            ProductTrends();
        }
        if(productTrendTerritoryName !=null && productTrendTerritoryName !=''){
            ProductTrends();
        }
    }
    
    
    @RemoteAction 
    global static Object ProductTrends()
    {
       
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        system.debug('GlobalId--'+GlobalId);
        JSONGenerator gen;
        List<MYBZ_Market_Share__c> productTrendsList;
        
        Set<Decimal> productTrendYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>> YearAndMonthProductTrendMap = new Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        if((Role == 'Major Marketing Manager' || Role == 'District Sales Manager' || Role == 'Sales Representative') && (productTrendRegionName ==null || productTrendRegionName =='') && (productTrendDistrictName == null || productTrendDistrictName == '') && (productTrendTerritoryName == null || productTrendTerritoryName == '')){
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'Major Marketing Manager' && productTrendRegionName !=null && productTrendRegionName !=''){
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Region__r.Name =:productTrendRegionName AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if((Role == 'Major Marketing Manager' || Role == 'District Sales Manager') && productTrendDistrictName !=null && productTrendDistrictName !=''){
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE District__r.Name =:productTrendDistrictName AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'District Sales Manager' && productTrendTerritoryName !=null && productTrendTerritoryName !=''){
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:productTrendTerritoryName AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        system.debug('productTrendsList---'+productTrendsList);
        if(!productTrendsList.isEmpty()){
            for(MYBZ_Market_Share__c productTrendObj : productTrendsList){
                productTrendYear.add(productTrendObj.Year__c);
            }
        }
        if(!productTrendYear.isEmpty()){
            for(Decimal year : productTrendYear){
                for(MYBZ_Market_Share__c productTrendObj : productTrendsList){
                    if(productTrendObj.Year__c == year){
                        if(!YearAndMonthsMap.containsKey(year)){
                            Set<Decimal> MonthsSet = new Set<Decimal>();
                            MonthsSet.add(productTrendObj.Month__c);
                            YearAndMonthsMap.put(year, MonthsSet);
                        }
                        else{
                            YearAndMonthsMap.get(year).add(productTrendObj.Month__c);
                        }
                    }
                }
            }
        }
        if(!productTrendYear.isEmpty() && !YearAndMonthsMap.isEmpty()){
            for(Decimal year : productTrendYear){
                
                Map<Decimal, List<MYBZ_Market_Share__c>> MonthAndProductTrendMap = new Map<Decimal, List<MYBZ_Market_Share__c>>();
                if(YearAndMonthsMap.containsKey(year)){
                    for(Decimal month : YearAndMonthsMap.get(year)){
                        List<MYBZ_Market_Share__c> productTrendMonthList = new List<MYBZ_Market_Share__c>();
                        for(MYBZ_Market_Share__c productTrendObj : productTrendsList){
                            if(productTrendObj.Month__c == month && productTrendObj.Year__c == year){
                                productTrendMonthList.add(productTrendObj);
                            }
                        }
                        MonthAndProductTrendMap.put(month, productTrendMonthList);
                    }
                }
                YearAndMonthProductTrendMap.put(year, MonthAndProductTrendMap);
            }
        }
        system.debug('YearAndMonthProductTrendMap---'+YearAndMonthProductTrendMap);
        if(!productTrendYear.isEmpty() && !YearAndMonthProductTrendMap.isEmpty()){
            gen = JSON.createGenerator(true);
            gen.writeStartArray();
            for(Decimal year : productTrendYear){
                if(YearAndMonthProductTrendMap.containsKey(year)){
                    Map<Decimal, List<MYBZ_Market_Share__c>> TempMonthAndProductTrendMap = YearAndMonthProductTrendMap.get(year);
                    for(Decimal month : TempMonthAndProductTrendMap.keySet()){
                        gen.writeStartObject();
                        gen.writeNumberField('month',month);
                        gen.writeNumberField('year',year);
                        if(TempMonthAndProductTrendMap.get(month) !=null){
                            gen.writeFieldName('products');
                            gen.writeStartArray();
                            for(MYBZ_Market_Share__c productTrendObj : TempMonthAndProductTrendMap.get(month)){
                                gen.writeStartObject();
                                gen.writeStringField('productName',productTrendObj.Product__r.Name);
                                gen.writeNumberField('trx',productTrendObj.TRx__c);
                                gen.writeNumberField('percentageChangeFromPreviousMonth',productTrendObj.percentageChangeFromPreviousMonth__c);
                                gen.writeBooleanField('lillyProduct',productTrendObj.lillyProduct__c);
                                gen.writeEndObject();
                            }
                            gen.writeEndArray();
                        }
                        gen.writeEndObject();
                    }
                }
            }
            gen.writeEndArray();
        }
        String sdata = gen.getAsString();
        System.debug('sdata---'+sdata);
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    
    public static void ParamtersFunctionForMarketShare(){
        if(marketShareRegionName !=null && marketShareRegionName !=''){
            MarketShare();
        }
        if(marketShareDistrictName !=null && marketShareDistrictName !=''){
            MarketShare();
        }
        if(marketShareTerritoryName !=null && marketShareTerritoryName !=''){
            MarketShare();
        }
    }
    
    
    @RemoteAction 
    global static Object MarketShare()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
       
        JSONGenerator gen;
        
        Map<String, Set<Decimal>> MarketShareNameAndYearMap = new Map<String, Set<Decimal>>();
        Map<String, Map<Decimal, Set<Decimal>>>MarketShareNameAndYearMonthMap = new Map<String, Map<Decimal, Set<Decimal>>>();
        
        
        
        Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>> MarketShareNameAndMarketShareMap = new Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        List<MYBZ_Market_Share__c> marketShareList;
        if((Role == 'Major Marketing Manager' || Role == 'District Sales Manager' || Role == 'Sales Representative')  && (marketShareRegionName == null || marketShareRegionName == '') && (marketShareDistrictName == null || marketShareDistrictName == '') && (marketShareTerritoryName == null || marketShareTerritoryName == '')){
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'Major Marketing Manager' && productTrendRegionName !=null && productTrendRegionName !=''){
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Region__r.Name =:marketShareRegionName ORDER BY Month__c, Year__c ASC];
        }
        if((Role == 'Major Marketing Manager' || Role == 'District Sales Manager') && marketShareDistrictName !=null &&marketShareDistrictName !=''){
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__r.Name =:marketShareDistrictName ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'District Sales Manager' && marketShareTerritoryName !=null && marketShareTerritoryName !=''){
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:marketShareTerritoryName ORDER BY Month__c, Year__c ASC];
        }
        if(!marketShareList.isEmpty()){
            for(MYBZ_Market_Share__c marketShareObj : marketShareList){
                if(!MarketShareNameAndYearMap.containsKey(marketShareObj.Market__c)){
                    Set<Decimal> YearSet = new Set<Decimal>();
                    YearSet.add(marketShareObj.Year__c);
                    MarketShareNameAndYearMap.put(marketShareObj.Market__c, YearSet);
                }
                else{
                    MarketShareNameAndYearMap.get(marketShareObj.Market__c).add(marketShareObj.Year__c);
                }
            }
        }
        if(!MarketShareNameAndYearMap.isEmpty()){
            for(String marketShareName : MarketShareNameAndYearMap.keySet()){
                Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
                for(MYBZ_Market_Share__c marketShareObj : marketShareList){
                    if(marketShareObj.Market__c == marketShareName){
                        Set<Decimal> marketYears = MarketShareNameAndYearMap.get(marketShareName);
                        for(Decimal Year : marketYears){
                            if(marketShareObj.Year__c == Year){
                                if(!YearAndMonthsMap.containsKey(Year)){
                                    Set<Decimal> MonthsSet = new Set<Decimal>();
                                    MonthsSet.add(marketShareObj.Month__c);
                                    YearAndMonthsMap.put(year, MonthsSet);
                                }
                                else{
                                    YearAndMonthsMap.get(year).add(marketShareObj.Month__c);
                                }
                            }
                        }
                    }
                }
                MarketShareNameAndYearMonthMap.put(marketShareName,YearAndMonthsMap);
            }
        }
        if(!MarketShareNameAndYearMonthMap.isEmpty()){
            for(String marketShareName : MarketShareNameAndYearMonthMap.keySet()){
                Map<Decimal, Set<Decimal>> YearAndMonthsMap = MarketShareNameAndYearMonthMap.get(marketShareName);
                List<MYBZ_Market_Share__c> marketList = new List<MYBZ_Market_Share__c>();
                Map<Decimal, List<MYBZ_Market_Share__c>> YearAndMarketShareMap = new Map<Decimal, List<MYBZ_Market_Share__c>>();
                for(Decimal year : YearAndMonthsMap.keySet()){
                    Set<Decimal>MonthsSet = YearAndMonthsMap.get(year);
                    for(Decimal month : MonthsSet){
                        Map<Decimal, List<MYBZ_Market_Share__c>> MonthAndMarketMap = new Map<Decimal, List<MYBZ_Market_Share__c>>();
                        for(MYBZ_Market_Share__c marketShareObj : marketShareList){
                            if(marketShareObj.Month__c == month && marketShareObj.Year__c == year && marketShareObj.Market__c == marketShareName){
                                marketList.add(marketShareObj);
                            }
                        }
                    }
                    YearAndMarketShareMap.put(year, marketList);
                }
                MarketShareNameAndMarketShareMap.put(marketShareName, YearAndMarketShareMap);
            }
        }
        system.debug('MarketShareNameAndMarketShareMap---'+MarketShareNameAndMarketShareMap);
        if(!MarketShareNameAndYearMonthMap.isEmpty() && !MarketShareNameAndMarketShareMap.isEmpty()){
            gen = JSON.createGenerator(true);
            gen.writeStartArray();
            for(String marketShareName : MarketShareNameAndMarketShareMap.keySet()){
                Map<Decimal, Set<Decimal>> YearAndMonthMap = MarketShareNameAndYearMonthMap.get(marketShareName);
                gen.writeStartObject();
                gen.writeStringField('market',marketShareName);
                if(MarketShareNameAndMarketShareMap.get(marketShareName) !=null){
                    Map<Decimal, List<MYBZ_Market_Share__c>> YearAndMarketMap = MarketShareNameAndMarketShareMap.get(marketShareName);
                    gen.writeFieldName('data');
                    gen.writeStartArray();
                    for(Decimal Year : YearAndMarketMap.KeySet()){
                        Set<Decimal>MonthsSet = YearAndMonthMap.get(Year);
                        List<MYBZ_Market_Share__c> marketList =  YearAndMarketMap.get(Year);
                        System.debug('marketList---'+marketList);
                        for(Decimal Month : MonthsSet){
                            gen.writeStartObject();
                            gen.writeNumberField('month',Month);
                            gen.writeNumberField('year',Year);
                            if(!marketList.isEmpty()){
                                gen.writeFieldName('products');
                                gen.writeStartArray();
                                for(MYBZ_Market_Share__c marketShareObj : marketList){
                                    Decimal percentageChangeSinceLastMonth;
                                    if(marketShareObj.Market__c == marketShareName && marketShareObj.Year__c == Year && marketShareObj.Month__c == Month){
                                        gen.writeStartObject();
                                        if(marketShareObj.TRx__c == 0 || marketShareObj.Previous_Month_TRx__c == 0)
                                            percentageChangeSinceLastMonth = 0;
                                        else
                                            percentageChangeSinceLastMonth = ((marketShareObj.TRx__c - marketShareObj.Previous_Month_TRx__c) / marketShareObj.Previous_Month_TRx__c);
                                        gen.writeStringField('productName',marketShareObj.Product__r.Name);
                                        gen.writeBooleanField('lillyProduct',marketShareObj.lillyProduct__c);
                                        gen.writeNumberField('percentageChangeSinceLastMonth',percentageChangeSinceLastMonth);
                                        gen.writeNumberField('trx',marketShareObj.TRx__c);
                                        gen.writeEndObject();
                                    }
                                    
                                }
                                gen.writeEndArray();
                            }
                            gen.writeEndObject();
                        }
                    }
                    gen.writeEndArray();
                }
                gen.writeEndObject();
            }
            gen.writeEndArray();
        }
        String sdata = gen.getAsString();
        System.debug('sdata---'+sdata);
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    @RemoteAction 
    global static Object TrendsPrescriber()
    {
        
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        List<MYBZ_Product_Trend_Detail__c> TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Global_ID__c=:GlobalId order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();  
        String Years='';
        String Months;
        String Products;
        Integer productprescribercount;
        Integer firstiteration=1;
    
        //Looping over Trend-Details
        for(MYBZ_Product_Trend_Detail__c trenddetails : TrendsDetailsList)
        {
            if(!Years.contains(String.Valueof(trenddetails.Year__c)))
            {
                Years+=trenddetails.Year__c;
                Months = '';
            }
            if(!Months.contains(String.Valueof(trenddetails.Month__c)))
            {
                 if(firstiteration==1)
                {
                    gen.writeStartObject();
                    firstiteration=0;
                }
                else
                {
                    gen.writeEndArray();
                    gen.writeEndObject();
                    gen.writeStartObject();
                }
                Months+=trenddetails.Month__c;
                Products='';
                gen.writeNumberField('month',trenddetails.Month__c);
                //sdata+='"month":'+ month + ',';
                gen.writeNumberField('year',trenddetails.Year__c);
                gen.writeFieldName('products');
                gen.writeStartArray();      
            }
            if(!Products.contains(trenddetails.IHS_Product__r.Name))
            {
                Products+=trenddetails.IHS_Product__r.Name;
                gen.writeStartObject();
                gen.writeStringField('product',trenddetails.IHS_Product__r.Name);
                gen.writeFieldName('topFivePrescribers');
                gen.writeStartArray();
                productprescribercount=0;
            }
            if(productprescribercount<=5)
            {
                productprescribercount++;
                gen.writeStartObject();
                gen.writeStringField('prescriberFirstName',trenddetails.HCP_First_Name__c);
                gen.writeStringField('prescriberLastName',trenddetails.HCP_Last_Name__c);
                gen.writeNumberField('trx',trenddetails.TRx_Units__c);
                gen.writeEndObject();
                if(productprescribercount==5)
                {
                gen.writeEndArray();
                gen.writeEndObject();
                }
            }
            else
            {
                continue;
            }
                
        }
        gen.writeEndArray();  
        String sdata = gen.getAsString();
        sdata=sdata.replaceall('\n','');
        System.Debug('%%%%' + sdata);
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    @RemoteAction  
  global static Object callPlanning() {       
        
     UserId = UserInfo.getUserId();
     User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
     Role = userObj.MYBZ_Role__c;
     GlobalId = userObj.Prsnl_Nbr_GLBL__c;
     system.debug('GlobalId--'+GlobalId);
    List<MYBZ_Call_Planning__c> CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Global_ID__c=:GlobalId order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    List<MYBZ_Call__c> CallsList = [select id,Name,Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.Name,Call_Type__c,Product_Position__c,Call_Date__c from MYBZ_Call__c where Global_ID__c=:GlobalId order by First_Name__c,Last_Name__c,Call_Date__c,Call_Type__c,Product_Position__c ];
    Decimal percentageChangePastMonth = 0;
    Decimal percentageChangePastThreeMonths = 0;
    Decimal percentageChangePastSixMonths = 0;
    Integer Dummy=0;
    Integer newuserflag=1;
    Integer firstuserflag=1;
    Integer firstproduct=1;
    Integer newproduct=1;
    Integer firstCall=1;
    Integer usercallcount=0;
    String firstNameLastName='';
    String CurrentProduct='';
    String CurrentDate = '';
    Integer newdate = 0;
    Integer newtype=0;
    String CurrentType = '';
    Integer callsProductNumber = 1;
    Integer callsFirstProduct = 1;
    Integer InitialCallCount=0;
    String CurrentCallsUser='';
    String sdata='';
    String CallUser='';
    //Integer ProcessCallPlanning=1;
    Integer CallsCount=0;
    String TypesList='';
    sdata+='[';
    //JSONGenerator gen = JSON.createGenerator(true);
    //gen.writeStartArray();  
    for(Integer CallPlanningCount=0;CallPlanningCount<CallPlanningsList.size();CallPlanningCount++)
    {
        
        if(!firstNameLastName.equals(CallPlanningsList[CallPlanningCount].First_Name__c+CallPlanningsList[CallPlanningCount].Last_Name__c))
        {
           newuserflag = 1;
           CurrentDate = '';
           CurrentType ='';
           CurrentProduct='';
           firstNameLastName=CallPlanningsList[CallPlanningCount].First_Name__c+CallPlanningsList[CallPlanningCount].Last_Name__c;
           if(firstuserflag==1)
           {
            sdata+='{';
            //gen.writeStartObject();
            firstuserflag=0;
           }
           else
           {
            sdata+='},{';
            //gen.writeEndObject();
            //gen.writeStartObject();
           }
           sdata+='"firstName":"'+CallPlanningsList[CallPlanningCount].First_Name__c+'",';
           sdata+='"lastName":"'+CallPlanningsList[CallPlanningCount].Last_Name__c+'",';
           sdata+='"tier":"'+CallPlanningsList[CallPlanningCount].Tier__c+'",';
           sdata+='"products":[';
           //gen.writeStringField('firstName',CallPlanningsList[CallPlanningCount].First_Name__c);
           //gen.writeStringField('lastName',CallPlanningsList[CallPlanningCount].Last_Name__c);
           //gen.writeStringField('tier',String.ValueOf(CallPlanningsList[CallPlanningCount].Tier__c));
           //gen.writeFieldName('products');
           //gen.writeStartArray();
            
           firstproduct = 1;
        }   
        else
        {
        newuserflag=0;
        }
        
        //PRODUCTS

        if(!CurrentProduct.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
        {
            newproduct=1;
            percentageChangePastMonth=0;
            percentageChangePastThreeMonths=0;
            percentageChangePastSixMonths=0;
            
            CurrentProduct = CallPlanningsList[CallPlanningCount].Product__r.Name;
            if(firstproduct==1)
            {
                sdata+='{';
                //gen.writeStartObject();
                firstproduct=0;
            }
            else
            {
                sdata+='},{';
                //gen.writeStartObject();
                //gen.writeEndObject();
            }
        }
        else
        {
            newproduct=0;
        }
        if(CallPlanningsList[CallPlanningCount].Range__c.Equals('1M'))
        {
                if((CallPlanningCount+1 == CallPlanningsList.size())||CallPlanningsList[CallPlanningCount+1].Range__c.Equals('3M'))
                {
                    sdata+='"name":"'+CallPlanningsList[CallPlanningCount].Product__r.Name+'",';
                    sdata+='"scriptsWrittenPastMonth":'+CallPlanningsList[CallPlanningCount].TRx_Units__c+',';
                    //gen.writeStringField('name',CallPlanningsList[CallPlanningCount].Product__r.Name);
                    //gen.writeNumberField('scriptsWrittenPastMonth',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                    {
                    percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                    percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    percentageChangePastMonth=0;
                //continue;
                }
                else
                {
                    sdata+='"name":"'+CallPlanningsList[CallPlanningCount].Product__r.Name+'",';
                    sdata+='"scriptsWrittenPastMonth":'+CallPlanningsList[CallPlanningCount].TRx_Units__c+',';
                    sdata+='"scriptsWrittenPastThreeMonths":'+dummy+',';
                    sdata+='"scriptsWrittenPastSixMonths":'+dummy+',';
                    sdata+='"percentageChangePastMonth":'+percentageChangePastMonth+',';
                    sdata+='"percentageChangePastThreeMonths":'+dummy+',';
                    sdata+='"percentageChangePastSixMonths":'+dummy; 
                    
                    
                }
                
        }
        if(CallPlanningsList[CallPlanningCount].Range__c.Equals('3M'))
        {
                if((CallPlanningCount+1 == CallPlanningsList.size())||CallPlanningsList[CallPlanningCount+1].Range__c.Equals('6M'))
                {
                    sdata+='"scriptsWrittenPastThreeMonths":'+CallPlanningsList[CallPlanningCount].TRx_Units__c+',';
                    //gen.writeNumberField('scriptsWrittenPastThreeMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                    {
                    percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                    percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    percentageChangePastThreeMonths=0;
                    //continue;
               }
               else
               {
                    sdata+='"scriptsWrittenPastThreeMonths":'+CallPlanningsList[CallPlanningCount].TRx_Units__c+',';
                    sdata+='"scriptsWrittenPastSixMonths":'+dummy+',';
                    sdata+='"percentageChangePastMonth":'+percentageChangePastMonth+',';
                    sdata+='"percentageChangePastThreeMonths":'+percentageChangePastThreeMonths+',';
                    sdata+='"percentageChangePastSixMonths":'+dummy; 
               
               }
               
                
        }
       if(CallPlanningsList[CallPlanningCount].Range__c.Equals('6M'))
        {
                //gen.writeNumberField('scriptsWrittenPastSixMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                sdata+='"scriptsWrittenPastSixMonths":'+CallPlanningsList[CallPlanningCount].TRx_Units__c+',';
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                {
                percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
                }
                else
                percentageChangePastThreeMonths=0;
                sdata+='"percentageChangePastMonth":'+percentageChangePastMonth+',';
                sdata+='"percentageChangePastThreeMonths":'+percentageChangePastThreeMonths+',';
                sdata+='"percentageChangePastSixMonths":'+percentageChangePastSixMonths;
                //gen.writeNumberField('percentageChangePastMonth',percentageChangePastMonth);
                //gen.writeNumberField('percentageChangePastThreeMonths',percentageChangePastThreeMonths);
                //gen.writeNumberField('percentageChangePastSixMonths',percentageChangePastSixMonths);
            }
            
            
       
       if((CallPlanningCount+1 == CallPlanningsList.size() )||(!firstNameLastName.equals(CallPlanningsList[CallPlanningCount+1].First_Name__c+CallPlanningsList[CallPlanningCount+1].Last_Name__c)))
        {
                sdata+='}]';
                InitialCallCount=CallsCount;
                //System.Debug('######'+firstNameLastName+' '+CallsCount+' '+CallsList[CallsCount].First_Name__c+' '+CallPlanningsList[CallPlanningCount+1]);
                if(!firstNameLastName.equals(CallsList[CallsCount].First_Name__c+CallsList[CallsCount].Last_Name__c))
                {
                    for(integer a=CallsCount;a<CallsList.Size();a++)
                    {
                        if(!firstNameLastName.equals(CallsList[CallsCount].First_Name__c+CallsList[CallsCount].Last_Name__c))
                        {
                            CallsCount++;
                        }
                        else
                        {
                            break;
                        }
                    }
                    if(CallsCount==CallsList.size())
                    {
                        CallsCount=InitialCallCount;
                    }
                }
                if(firstNameLastName.equals(CallsList[CallsCount].First_Name__c+CallsList[CallsCount].Last_Name__c))
                {               
                sdata+=',';
                sdata+='"calls":[';
                //gen.writeEndObject();
                //gen.writeEndArray();
                //gen.writeFieldName('calls');
                //gen.writeStartArray();
                firstCall=1;
                usercallcount=0;
                for(integer i = CallsCount; i<CallsList.Size(); i++)
                {
                    CallsCount = i;
                    
                    if(usercallcount==5)
                    {
                        sdata+= '}]';
                        break;
                    }
                    
                    usercallcount++;
                    if(firstNameLastName.equals(CallsList[i].First_Name__c+CallsList[i].Last_Name__c))
                    {
                                               
                        if( !CurrentDate.equals(CallsList[i].Call_Date__c.format('MM/dd/yyyy')) )
                        {
                            newdate = 1;
                            CurrentDate = CallsList[i].Call_Date__c.format('MM/dd/yyyy');                           
                        }
                        else
                        {
                            newdate = 0;
                        }
                        
                        if( !CurrentType.equals(CallsList[i].Call_Type__c))
                        {
                            newtype=1;
                            CurrentType = CallsList[i].Call_Type__c;
                        }
                        else
                        {
                            newtype=0;
                        }
                        
                        
                        if( (newtype==1 || newdate ==1) && usercallcount<6)
                        {
                            callsProductNumber = 1;
                            if(firstCall==1)
                            {
                                sdata+= '{';
                                //gen.writeStartObject();
                                firstCall=0;
                            }
                            else
                            {
                                sdata+= '},{';
                                //gen.writeEndObject();
                                //gen.writeStartObject();
                            }
                            
                            sdata+='"date":';
                            sdata+='"'+CallsList[i].Call_Date__c.format('MM/dd/yyyy')+'",';
                            sdata+='"type":"';
                            sdata+=CallsList[i].Call_Type__c+'"';
                            
                            //gen.writeStringField('date',CallsList[i].Call_Date__c.format('MM/dd/yyyy'));   
                            //gen.writeStringField('type',CallsList[i].Call_Type__c);
                        }
                        else
                        {
                            
                            callsProductNumber+=1;
                            //if(callsProductNumber==2)
                           
                            
                        }
                        
                        //Information       
                        if(CallsList[i].Call_Type__c.equals('Sample Only'))
                        {
                            if(callsProductNumber==2)
                            {
                                if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL))
                                {
                                     sdata+=',';
                                    sdata+='"product' + String.ValueOf(callsProductNumber) +'":';
                                    sdata+='"'+CallsList[i].Product__r.Name+'"';
                                    //sdata+='"'+CallsList[i].Product__r.Name+'"';
                                    
                                    //gen.writeFieldName('product');
                                    //gen.writeString(String.ValueOf(callsProductNumber));
                                    //gen.writeString(CallsList[i].Product__r.Name);
                                    
                                }
                            }
                            else
                            {
                                if((CallsList[i].Product__c!=NULL))
                                {
                                sdata+=',"product' + String.ValueOf(callsProductNumber) +'":';
                                sdata+='"'+CallsList[i].Product__r.Name+'"';
                                }
                            //sdata+='"'+CallsList[i].Product__r.Name+'"';
                            //gen.writeFieldName('product');
                            //gen.writeString(String.ValueOf(callsProductNumber));
                            //gen.writeString(CallsList[i].Product__r.Name);
                            }
                        }
                        
                        
                        if((callsProductNumber<=2)&&(!CallsList[i].Call_Type__c.equals('Sample Only')))
                        {
                            if(callsProductNumber==2)
                            {
                                if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL)&&(CallsList[i].Product_Position__c==2))
                                {
                                     sdata+=',';
                                    sdata+='"product' + String.ValueOf(callsProductNumber) +'":';
                                    sdata+='"'+CallsList[i].Product__r.Name+'"';
                                    //sdata+='"'+CallsList[i].Product__r.Name+'"';
                                    
                                    //gen.writeFieldName('product');
                                    //gen.writeString(String.ValueOf(callsProductNumber));
                                    //gen.writeString(CallsList[i].Product__r.Name);
                                    
                                }
                            }
                            else
                            {
                             if((CallsList[i].Product__c!=NULL)&&CallsList[i].Product_Position__c==1)
                            {
                            
                            sdata+=',"product' + String.ValueOf(callsProductNumber) +'":';
                            
                            sdata+='"'+CallsList[i].Product__r.Name+'"';
                            }
                            //sdata+='"'+CallsList[i].Product__r.Name+'"';
                            //gen.writeFieldName('product');
                            //gen.writeString(String.ValueOf(callsProductNumber));
                            //gen.writeString(CallsList[i].Product__r.Name);
                            }
                        }
                        if((i+1 == CallsList.size() )||(!firstNameLastName.equals(CallsList[i+1].First_Name__c+CallsList[i+1].Last_Name__c)))
                        {
                            //closing all calls
                            sdata+= '}]';
                            //gen.writeEndObject();
                            //gen.writeEndArray();
                            if((i+1)!=CallsList.size())
                            {
                            CallsCount+=1;
                            }
                            break;
                        }                       
                    } // end of if same user    
 
                    }// end of calls for
                    
                    
                }
                  
                }// end of if next user is different
            
        
        
    } // end of user for

    sdata+='}]';
    //gen.writeEndObject();
    //gen.writeEndArray();
    //System.Debug('&&&'+sdata);
    //sdata = gen.getAsString();
    sdata=sdata.replaceall('\n','');
    System.Debug('%%%%' + sdata);
    Object obj=Json.deserializeUntyped(sdata);
     return obj;
    
    
 } 
}