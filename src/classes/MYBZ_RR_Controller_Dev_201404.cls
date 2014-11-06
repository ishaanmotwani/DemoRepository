/*
 *@ Class Name                                                    : MYBZ_RegionRollup_Controller
 *@ Description                                                   : Class for retrieving salesforce data in the form of a string and returning as a JSON object via a remote action.
 *@ CreatedBy                                                     : Gaurav Suri
 *@ CreatedOn                                                     : 09-30-2014
 *@ Modification Log                                              :
 */
global with sharing class MYBZ_RR_Controller_Dev_201404
{
  /* 
         * @Method Name                    :  mysampledata
         * @Description                    :  JavaScript remoting to allow mysampledata method to be called in a javascript controller and return data 
                                              retrieved from Salesforce in the form of a JSON object. 
         * @Return Type                    :  object
         * @Param                          :  abc
                                           
   */
  
    
    
    global static Id UserId;
    global static String Role{get;set;}
    global static String GlobalId{get;set;}
    global static String uname{get;set;}
  
    global MYBZ_RR_Controller_Dev_201404(){
        UserId = UserInfo.getUserId();
        User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        uname=userObj.name;
    }
   
    @RemoteAction 
    global static Object RegionRollup1()
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
        
        List <MYBZ_Region__c> regionList = [SELECT Name, Range__c, TRxStartDates__c, NRxStartDates__c, OpexStartDates__c, GrossMarginStartDates__c, NetProfitStartDates__c, Global_Id__c, Parent__c, Product__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_Region__c WHERE Parent__c =: divisionObj.id AND Product__c!=null];
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
            List<MYBZ_Region__c> regions = [SELECT Id, Range__c, TRxStartDates__c, NRxStartDates__c, OpexStartDates__c, GrossMarginStartDates__c, NetProfitStartDates__c, Global_Id__c, Parent__c, Product__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_Region__c WHERE Parent__c =: divisionObj.id AND Name =:firstRegionName AND Product__c!=null];
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
            for(MYBZ_District__c districtObj : [SELECT Name, Global_Id__c, Range__c, Product__r.Name, Region__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_District__c WHERE Region__c IN: regionIds AND Product__c!=null])
            {
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
            for(MYBZ_Territory__c territoryObj : [SELECT Id, Name, Range__c, State__r.Name, Product__r.Name, TRx__c, NRx__c FROM MYBZ_Territory__c WHERE State__c IN:districtIds AND Product__c!=null]){
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
        System.debug('sdata'+sdata );
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    @RemoteAction 
    global static Object RegionRollup(String region, String district, String territory)
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
        
        List <MYBZ_Region__c> regionList = [SELECT Name, Range__c, TRxStartDates__c, NRxStartDates__c, OpexStartDates__c, GrossMarginStartDates__c, NetProfitStartDates__c, Global_Id__c, Parent__c, Product__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_Region__c WHERE Parent__c =: divisionObj.id AND Product__c!=null];
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
            List<MYBZ_Region__c> regions = [SELECT Id, Range__c, TRxStartDates__c, NRxStartDates__c, OpexStartDates__c, GrossMarginStartDates__c, NetProfitStartDates__c, Global_Id__c, Parent__c, Product__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_Region__c WHERE Parent__c =: divisionObj.id AND Name =:firstRegionName AND Product__c!=null];
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
            for(MYBZ_District__c districtObj : [SELECT Name, Global_Id__c, Range__c, Product__r.Name, Region__r.Name, TRx__c, NRx__c, OPEX__c, Net_Profit__c, Gross_Margin__c FROM MYBZ_District__c WHERE Region__c IN: regionIds AND Product__c!=null]){
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
            for(MYBZ_Territory__c territoryObj : [SELECT Id, Name, Range__c, State__r.Name, Product__r.Name, TRx__c, NRx__c FROM MYBZ_Territory__c WHERE State__c IN:districtIds AND Product__c!=null]){
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
        System.debug('sdata'+sdata );
        Object obj = Json.deserializeUntyped(sdata);
        return obj;
    }
    @RemoteAction 
    global static Object Alignment(String region, String district, String territory)
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        JSONGenerator gen;
        gen = JSON.createGenerator(true);
        
        
        Set<Id> regionIds = new Set<Id>();
        Set<Id> districtIds = new Set<Id>();
        MYBZ_IHS_Division__c divisionObj = [SELECT Id, Name FROM MYBZ_IHS_Division__c LIMIT 1];
        Map<String, String> RegionNameAndGlobalIdMap = new Map<String, String>();
        Map<String, Set<String>> RegionNameAndDistrictMap = new Map<String, Set<String>>();
        Map<String, String> DistrictNameAndGlobalIdMap = new Map<String, String>();
        Map<String, Set<String>> DistrictNameAndTerritoryMap = new Map<String, Set<String>>();
        Map<String, String> TerritoryNameAndGlobalIdMap = new Map<String, String>();
        
        List <MYBZ_Region__c> regionList = [SELECT Id, Name, Global_Id__c FROM MYBZ_Region__c WHERE Parent__c = : divisionObj.id AND Product__c!=null];
        if(!regionList.isEmpty())
        {
            for(MYBZ_Region__c regionObj : regionList){
                if(!RegionNameAndGlobalIdMap.containsKey(regionObj.Name)){
                    RegionNameAndGlobalIdMap.put(regionObj.Name, regionObj.Global_Id__c);
                }
                regionIds.add(regionObj.Id);
            }
        }
        for(MYBZ_District__c districtObj : [SELECT Id, Name, Global_Id__c, Region__r.Name FROM MYBZ_District__c WHERE Region__c IN: regionIds AND Product__c!=null]){
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
        for(MYBZ_Territory__c territoryObj : [SELECT Id, Name, Global_Id__c, State__r.Name FROM MYBZ_Territory__c WHERE State__c IN: districtIds AND Product__c!=null]){
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
    
    @RemoteAction 
    global static Object Alignment1()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        JSONGenerator gen;
        gen = JSON.createGenerator(true);
        
        
        Set<Id> regionIds = new Set<Id>();
        Set<Id> districtIds = new Set<Id>();
        MYBZ_IHS_Division__c divisionObj = [SELECT Id, Name FROM MYBZ_IHS_Division__c LIMIT 1];
        Map<String, String> RegionNameAndGlobalIdMap = new Map<String, String>();
        Map<String, Set<String>> RegionNameAndDistrictMap = new Map<String, Set<String>>();
        Map<String, String> DistrictNameAndGlobalIdMap = new Map<String, String>();
        Map<String, Set<String>> DistrictNameAndTerritoryMap = new Map<String, Set<String>>();
        Map<String, String> TerritoryNameAndGlobalIdMap = new Map<String, String>();
        
        List <MYBZ_Region__c> regionList = [SELECT Id, Name, Global_Id__c FROM MYBZ_Region__c WHERE Parent__c = : divisionObj.id AND Product__c!=null];
        if(!regionList.isEmpty())
        {
            for(MYBZ_Region__c regionObj : regionList){
                if(!RegionNameAndGlobalIdMap.containsKey(regionObj.Name)){
                    RegionNameAndGlobalIdMap.put(regionObj.Name, regionObj.Global_Id__c);
                }
                regionIds.add(regionObj.Id);
            }
        }
        for(MYBZ_District__c districtObj : [SELECT Id, Name, Global_Id__c, Region__r.Name FROM MYBZ_District__c WHERE Region__c IN: regionIds AND Product__c!=null]){
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
        for(MYBZ_Territory__c territoryObj : [SELECT Id, Name, Global_Id__c, State__r.Name FROM MYBZ_Territory__c WHERE State__c IN: districtIds AND Product__c!=null]){
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
    
    @RemoteAction 
    global static Object TargetGoal(String region, String district, String territory)
    {
        system.debug('district---'+district);
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        
        String sdata;
        Object obj;
        
        JSONGenerator gen;
        List<MYBZ_Target_Goal__c> targetGoalList = new List<MYBZ_Target_Goal__c>();
        
        Set<Decimal> targetGoalYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>> YearAndMonthTargetGoalMap = new Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>>();
        system.debug('Role---'+Role);
       
        if(Role == 'District Sales Manager' && district != null && district != ''){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:district AND Territory__c = null   ORDER BY Month__c, Year__c ASC ];
        }
        else if(Role == 'Major Market Manager' && district !=null && district !=''){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:district AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == 'Super User' && district != null && district != ''){
            targetGoalList.clear();
            
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__c =:district AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        
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
            sdata = gen.getAsString();
            System.debug('sdata----'+sdata);
            obj = Json.deserializeUntyped(sdata);
        }
        return obj;
    }
     @RemoteAction 
    global static Object TargetGoal1()
    {
        //system.debug('geographyDictionary---'+geographyDictionary);
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        
        String sdata;
        Object obj;
        
        JSONGenerator gen;
        List<MYBZ_Target_Goal__c> targetGoalList = new List<MYBZ_Target_Goal__c>();
        
        Set<Decimal> targetGoalYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>> YearAndMonthTargetGoalMap = new Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>>();
        system.debug('Role---'+Role);
        
        if(Role == 'District Sales Manager'){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Global_Id__c =:GlobalId AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == 'Major Market Manager'){
            targetGoalList.clear();
            MYBZ_Region__c regionObj = [SELECT Id FROM MYBZ_Region__c WHERE Global_Id__c =:GlobalId LIMIT 1];
            
            MYBZ_District__c districtObj = [SELECT Id FROM MYBZ_District__c WHERE Region__c =:regionObj.Id LIMIT 1];
            
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__c =:districtObj.Id AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == 'Sales Representative'){
            targetGoalList.clear();
            MYBZ_Territory__c territoryObj = [SELECT Id, State__r.Name FROM MYBZ_Territory__c WHERE Global_Id__c =:GlobalId LIMIT 1];
            String associatedDistrictName = territoryObj.State__r.Name;
            system.debug('associatedDistrictName--'+associatedDistrictName);
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:associatedDistrictName AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == 'Super User'){
            targetGoalList.clear();
            MYBZ_District__c districtObj = [SELECT Id, Global_Id__c FROM MYBZ_District__c WHERE Global_Id__c !=null AND Global_Id__c !='' LIMIT 1];
            
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__c =:districtObj.Id AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        
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
            sdata = gen.getAsString();
            System.debug('sdata----'+sdata);
            obj = Json.deserializeUntyped(sdata);
        }
        return obj;
    }
    
    
    @RemoteAction 
    global static Object ProductTrends(String region, String district, String territory)
    {
       
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        system.debug('GlobalId--'+GlobalId);
        
        String sdata;
        Object obj;
        
        JSONGenerator gen;
        List<MYBZ_Market_Share__c> productTrendsList = new  List<MYBZ_Market_Share__c>();
        
        Set<Decimal> productTrendYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>> YearAndMonthProductTrendMap = new Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        if((Role == 'Major Market Manager' || Role == 'District Sales Manager' || Role == 'Super User') && district !=null && district !=''){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE District__r.Name =:district AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if((Role == 'Major Market Manager' || Role == 'Super User') && region !=null && region !=''){
            productTrendsList.clear();
           
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Region__r.Name =: region AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if((Role == 'District Sales Manager' || Role == 'Super User') && territory !=null && territory !=''){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:territory AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
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
            sdata = gen.getAsString();
            System.debug('sdata---'+sdata);
            obj = Json.deserializeUntyped(sdata);
        }
        return obj;
    }
    @RemoteAction 
    global static Object ProductTrends1()
    {
       
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        system.debug('GlobalId--'+GlobalId);
        
        String sdata;
        Object obj;
        
        JSONGenerator gen;
        List<MYBZ_Market_Share__c> productTrendsList = new  List<MYBZ_Market_Share__c>();
        
        Set<Decimal> productTrendYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>> YearAndMonthProductTrendMap = new Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        if(Role == 'Sales Representative'){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'District Sales Manager'){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'Major Market Manager'){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'Super User'){
            productTrendsList.clear();
            String territoryName = 'BAYSTATE MA IH Partner 125397';
            MYBZ_Territory__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Territory__c WHERE Name =:territoryName LIMIT 1];
            
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c FROM MYBZ_Market_Share__c WHERE Territory__c =:territoryObj.Id AND Owner__c = 'LILLY' AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
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
            sdata = gen.getAsString();
            System.debug('sdata---'+sdata);
            obj = Json.deserializeUntyped(sdata);
        }
        return obj;
    }
   
    @RemoteAction 
    global static Object MarketShare(String region, String district, String territory)
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        String sdata;
        Object obj;
        JSONGenerator gen;
        
        Map<String, Set<Decimal>> MarketShareNameAndYearMap = new Map<String, Set<Decimal>>();
        Map<String, Map<Decimal, Set<Decimal>>>MarketShareNameAndYearMonthMap = new Map<String, Map<Decimal, Set<Decimal>>>();
        
        
        
        Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>> MarketShareNameAndMarketShareMap = new Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        List<MYBZ_Market_Share__c> marketShareList = new List<MYBZ_Market_Share__c>();
        if((Role == 'Major Market Manager' || Role == 'District Sales Manager' || Role == 'Super User') && district !=null && district !=''){
            marketShareList.clear();
           
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__r.Name =:district ORDER BY Month__c, Year__c ASC];
        }
        if((Role == 'Major Market Manager' || Role == 'Super User') && region !=null && region !=''){
            marketShareList.clear();
            
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Region__r.Name =: region ORDER BY Month__c, Year__c ASC];
        }
        if((Role == 'District Sales Manager' || Role == 'Super User') && territory !=null && territory !=''){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:territory ORDER BY Month__c, Year__c ASC];
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
            sdata = gen.getAsString();
            System.debug('sdata---'+sdata);
            obj = Json.deserializeUntyped(sdata);
        }
        return obj;
    }
    
    @RemoteAction 
    global static Object MarketShare1()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        String sdata;
        Object obj;
        JSONGenerator gen;
        
        Map<String, Set<Decimal>> MarketShareNameAndYearMap = new Map<String, Set<Decimal>>();
        Map<String, Map<Decimal, Set<Decimal>>>MarketShareNameAndYearMonthMap = new Map<String, Map<Decimal, Set<Decimal>>>();
        
        
        
        Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>> MarketShareNameAndMarketShareMap = new Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        List<MYBZ_Market_Share__c> marketShareList = new List<MYBZ_Market_Share__c>();
         if(Role == 'Sales Representative'){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'District Sales Manager'){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'Major Market Manager'){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        if(Role == 'Super User'){
            marketShareList.clear();
            MYBZ_Territory__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Territory__c WHERE Global_Id__c !=null AND Global_Id__c !='' LIMIT 1];
            
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE Territory__c =:territoryObj.Id ORDER BY Month__c, Year__c ASC];
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
            sdata = gen.getAsString();
            System.debug('sdata---'+sdata);
            obj = Json.deserializeUntyped(sdata);
        }
        return obj;
    }
    @RemoteAction 
    global static Object TrendsPrescriber1()
    {
        
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        List<MYBZ_Product_Trend_Detail__c> TrendsDetailsList = new List<MYBZ_Product_Trend_Detail__c>();
        String sdata;
        Object obj;
        
        if(Role == 'Sales Representative'){
            TrendsDetailsList.clear();
           //List of all trend-details for a particular user
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Global_ID__c=:GlobalId order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if(Role == 'District Sales Manager'){
            TrendsDetailsList.clear();
           //List of all trend-details for a particular user
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Global_ID__c=:GlobalId order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if(Role == 'Major Market Manager'){
            TrendsDetailsList.clear();
           //List of all trend-details for a particular user
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Global_ID__c=:GlobalId order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if(Role == 'Super User'){
            TrendsDetailsList.clear();
            String territoryName = 'BAYSTATE MA IH Partner 125397';
            MYBZ_Territory__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Territory__c WHERE Name =:territoryName AND Range__c = 'oneMonthData' LIMIT 1];
            
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Territory__c =:territoryObj.Id order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
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
                productprescribercount=1;
            }
            if(productprescribercount<=5)
            {
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
                
                productprescribercount++;
                
            }
                            
       }
       gen.writeEndArray();  
       sdata = gen.getAsString();
       sdata=sdata.replaceall('\n','');
       System.Debug('--TrendsPrescribers' + sdata);
        obj = Json.deserializeUntyped(sdata); 
        return obj;
    }
    
    @RemoteAction 
    global static Object TrendsPrescriber(String region, String district, String territory)
    {
        
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        String sdata;
        Object obj;
        List<MYBZ_Product_Trend_Detail__c> TrendsDetailsList = new List<MYBZ_Product_Trend_Detail__c>();
        
        if((Role == 'Major Market Manager' || Role == 'District Sales Manager' || Role == 'Super User') && district !=null && district !=''){
            TrendsDetailsList.clear();
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where District__r.Name =:district order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if((Role == 'Major Market Manager' || Role == 'Super User') && region !=null && region !=''){
            TrendsDetailsList.clear();
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Area__r.Name =:region order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if((Role == 'District Sales Manager' || Role == 'Super User') && territory !=null && territory !=''){
            TrendsDetailsList.clear();
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where territory__r.Name =:territory order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
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
                productprescribercount=1;
            }
            if(productprescribercount<=5)
            {
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
                
                productprescribercount++;
                
            }
                            
       }
       gen.writeEndArray();  
       sdata = gen.getAsString();
       sdata=sdata.replaceall('\n','');
       System.Debug('--TrendsPrescribers' + sdata);
        obj = Json.deserializeUntyped(sdata); 
        return obj;
    }
    
     @RemoteAction  
  global static Object callPlanning(String region, String district, String territory){       
        

     UserId = UserInfo.getUserId();
     User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
     Role = userObj.MYBZ_Role__c;
     GlobalId = userObj.Prsnl_Nbr_GLBL__c;
     List<MYBZ_Call_Planning__c> CallPlanningsList = new List<MYBZ_Call_Planning__c>();
     
    if(Role == 'Sales Representative'){
        CallPlanningsList.clear();
        
        CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Global_ID__c=:GlobalId order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    }
    if((Role == 'District Sales Manager' || Role == 'Super User') && territory != null && territory !=''){
        CallPlanningsList.clear();
        
        CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Territory__r.Name=:territory order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    }
    if(Role == 'Major Market Manager'){
        
        CallPlanningsList.clear();
        MYBZ_Territory__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Territory__c WHERE Global_Id__c !=null AND Global_Id__c !='' LIMIT 1];
        
        CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Territory__c =:territoryObj.Id order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    }
    
       if(CallPlanningsList.isempty())
    {
        return null;
    }
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
    
    if(CallPlanningsList.isempty())
    {
        return null;
    }
    
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartArray();  
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
            
            gen.writeStartObject();
            firstuserflag=0;
           }
           else
           {
            
            gen.writeEndObject();
            gen.writeStartObject();
           }
           
           gen.writeStringField('firstName',CallPlanningsList[CallPlanningCount].First_Name__c);
           gen.writeStringField('lastName',CallPlanningsList[CallPlanningCount].Last_Name__c);
           gen.writeStringField('tier',String.ValueOf(CallPlanningsList[CallPlanningCount].Tier__c));
           gen.writeFieldName('products');
           gen.writeStartArray();
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
                
                gen.writeStartObject();
                firstproduct=0;
            }
            else
            {
                
                gen.writeEndObject();
                gen.writeStartObject();
            }
        }
        else
        {
            newproduct=0;
        }
        if(newproduct==1)
        {
          gen.writeStringField('name',CallPlanningsList[CallPlanningCount].Product__r.Name);
        }
        if(CallPlanningsList[CallPlanningCount].Range__c.Equals('1M'))
        {
                if((CallPlanningCount+1 == CallPlanningsList.size()||CallPlanningsList[CallPlanningCount+1].Range__c.Equals('3M'))&&CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name) )
                {
                    
                    
                    //gen.writeStringField('name',CallPlanningsList[CallPlanningCount].Product__r.Name);
                    gen.writeNumberField('scriptsWrittenPastMonth',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                    {
                    percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                    percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    percentageChangePastMonth=0;
                //continue;
                }
                else if(CallPlanningCount+1 == CallPlanningsList.size()||(!CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name)))
                {
                    gen.writeNumberField('scriptsWrittenPastMonth',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',dummy);
                    gen.writeNumberField('scriptsWrittenPastSixMonths',dummy);
                    gen.writeNumberField('percentageChangePastMonth',percentageChangePastMonth);
                    gen.writeNumberField('percentageChangePastThreeMonths',dummy);
                    gen.writeNumberField('percentageChangePastSixMonths',dummy);
                }
                else
                {
                    gen.writeNumberField('scriptsWrittenPastMonth',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',dummy);
                    percentageChangePastThreeMonths=dummy;                    
                }
                
        }
        if(CallPlanningsList[CallPlanningCount].Range__c.Equals('3M'))
        {
                if((CallPlanningCount+1 == CallPlanningsList.size()||CallPlanningsList[CallPlanningCount+1].Range__c.Equals('6M'))&&CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
                {
                    
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                    {
                    percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                    percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    percentageChangePastThreeMonths=0;
                    //continue;
               }
               else if((CallPlanningCount+1 == CallPlanningsList.size()||(!CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))))
               {
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    gen.writeNumberField('scriptsWrittenPastSixMonths',dummy);
                    gen.writeNumberField('percentageChangePastMonth',percentageChangePastMonth);
                    gen.writeNumberField('percentageChangePastThreeMonths',percentageChangePastThreeMonths);
                    gen.writeNumberField('percentageChangePastSixMonths',dummy);
               }
               
                
        }
       if(CallPlanningsList[CallPlanningCount].Range__c.Equals('6M'))
        {
                gen.writeNumberField('scriptsWrittenPastSixMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                {
                percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
                }
                else
                percentageChangePastThreeMonths=0;
                gen.writeNumberField('percentageChangePastMonth',percentageChangePastMonth);
                gen.writeNumberField('percentageChangePastThreeMonths',percentageChangePastThreeMonths);
                gen.writeNumberField('percentageChangePastSixMonths',percentageChangePastSixMonths);
            }
            
            
       
       if((CallPlanningCount+1 == CallPlanningsList.size() )||(!firstNameLastName.equals(CallPlanningsList[CallPlanningCount+1].First_Name__c+CallPlanningsList[CallPlanningCount+1].Last_Name__c)))
        {
                
                gen.writeEndObject();
                gen.writeEndArray();
                InitialCallCount=CallsCount;
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
                gen.writeFieldName('calls');
                gen.writeStartArray();
                firstCall=1;
                usercallcount=0;
                for(integer i = CallsCount; i<CallsList.Size(); i++)
                {
                    CallsCount = i;
                    
                    if(usercallcount==5)
                    {
                        
                        gen.writeEndObject();
                        gen.writeEndArray();
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
                                gen.writeStartObject();
                                firstCall=0;
                            }
                            else
                            {
                                gen.writeEndObject();
                                gen.writeStartObject();
                            }
                            
                            gen.writeStringField('date',CallsList[i].Call_Date__c.format('MM/dd/yyyy'));   
                            gen.writeStringField('type',CallsList[i].Call_Type__c);
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
                                if(CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL))
                                {
                                    gen.writeStringField('product2',CallsList[i].Product__r.Name);
                                    
                                }
                            }
                            else
                            {
                                if((CallsList[i].Product__c!=NULL))
                                {
                                gen.writeStringField('product1',CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        
                        
                        if((callsProductNumber<=2)&&(!CallsList[i].Call_Type__c.equals('Sample Only')))
                        {
                            if(callsProductNumber==2)
                            {
                                if(CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL)&&(CallsList[i].Product_Position__c==2))
                                {
                                    gen.writeStringField('product2',CallsList[i].Product__r.Name);
                                    
                                }
                            }
                            else
                            {
                             if((CallsList[i].Product__c!=NULL)&&CallsList[i].Product_Position__c==1)
                                {
                                 gen.writeStringField('product1',CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        if((i+1 == CallsList.size() )||(!firstNameLastName.equals(CallsList[i+1].First_Name__c+CallsList[i+1].Last_Name__c)))
                        {
                            //closing all calls
                            
                            gen.writeEndObject();
                            gen.writeEndArray();
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


    gen.writeEndObject();
    gen.writeEndArray();
    //System.Debug('&&&'+sdata);
    sdata = gen.getAsString();
    sdata=sdata.replaceall('\n','');
    System.Debug('%%%%' + sdata);
    Object obj=Json.deserializeUntyped(sdata);
    return obj;
    
 }  
 
  @RemoteAction  
  global static Object callPlanning1(){       
        
    List<MYBZ_Call_Planning__c> CallPlanningsList = new List<MYBZ_Call_Planning__c>();
     UserId = UserInfo.getUserId();
     User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c FROM User WHERE Id =:UserId];
     Role = userObj.MYBZ_Role__c;
     GlobalId = userObj.Prsnl_Nbr_GLBL__c;
    if(Role == 'Major Market Manager' || Role == 'Super User'){
        CallPlanningsList.clear();
        
        MYBZ_Territory__c territoryObj = [SELECT Id, Name, Global_Id__c FROM MYBZ_Territory__c WHERE Global_Id__c !=null AND Global_Id__c !='' LIMIT 1];
        
        CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Global_ID__c=:territoryObj.Global_Id__c order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    }
    if(Role == 'District Sales Manager'){
        CallPlanningsList.clear();
        
        MYBZ_District__c districtObj = [SELECT Id, Name FROM MYBZ_District__c WHERE Global_Id__c =:GlobalId LIMIT 1];
        
        MYBZ_Territory__c territoryObj = [SELECT Id, Name, Global_Id__c FROM MYBZ_Territory__c WHERE State__c =:districtObj.Id AND Global_Id__c !=null AND Global_Id__c !='' LIMIT 1];
        
        CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Global_ID__c=:territoryObj.Global_Id__c order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    }
    if(Role == 'Sales Representative'){
        CallPlanningsList.clear();
        
        CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Global_ID__c=:GlobalId order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    }
    if(CallPlanningsList.isempty())
    {
        return null;
    }
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
    
    if(CallPlanningsList.isempty())
    {
        return null;
    }
    
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartArray();  
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
            
            gen.writeStartObject();
            firstuserflag=0;
           }
           else
           {
            
            gen.writeEndObject();
            gen.writeStartObject();
           }
           
           gen.writeStringField('firstName',CallPlanningsList[CallPlanningCount].First_Name__c);
           gen.writeStringField('lastName',CallPlanningsList[CallPlanningCount].Last_Name__c);
           gen.writeStringField('tier',String.ValueOf(CallPlanningsList[CallPlanningCount].Tier__c));
           gen.writeFieldName('products');
           gen.writeStartArray();
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
                
                gen.writeStartObject();
                firstproduct=0;
            }
            else
            {
                
                gen.writeEndObject();
                gen.writeStartObject();
            }
        }
        else
        {
            newproduct=0;
        }
        if(newproduct==1)
        {
          gen.writeStringField('name',CallPlanningsList[CallPlanningCount].Product__r.Name);
        }
        if(CallPlanningsList[CallPlanningCount].Range__c.Equals('1M'))
        {
                if((CallPlanningCount+1 == CallPlanningsList.size()||CallPlanningsList[CallPlanningCount+1].Range__c.Equals('3M'))&&CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name) )
                {
                    
                    
                    //gen.writeStringField('name',CallPlanningsList[CallPlanningCount].Product__r.Name);
                    gen.writeNumberField('scriptsWrittenPastMonth',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                    {
                    percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                    percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    percentageChangePastMonth=0;
                //continue;
                }
                else if(CallPlanningCount+1 == CallPlanningsList.size()||(!CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name)))
                {
                    gen.writeNumberField('scriptsWrittenPastMonth',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',dummy);
                    gen.writeNumberField('scriptsWrittenPastSixMonths',dummy);
                    gen.writeNumberField('percentageChangePastMonth',percentageChangePastMonth);
                    gen.writeNumberField('percentageChangePastThreeMonths',dummy);
                    gen.writeNumberField('percentageChangePastSixMonths',dummy);
                }
                else
                {
                    gen.writeNumberField('scriptsWrittenPastMonth',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',dummy);
                    percentageChangePastThreeMonths=dummy;                    
                }
                
        }
        if(CallPlanningsList[CallPlanningCount].Range__c.Equals('3M'))
        {
                if((CallPlanningCount+1 == CallPlanningsList.size()||CallPlanningsList[CallPlanningCount+1].Range__c.Equals('6M'))&&CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
                {
                    
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                    {
                    percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                    percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    percentageChangePastThreeMonths=0;
                    //continue;
               }
               else if((CallPlanningCount+1 == CallPlanningsList.size()||(!CallPlanningsList[CallPlanningCount+1].Product__r.Name.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))))
               {
                    gen.writeNumberField('scriptsWrittenPastThreeMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                    gen.writeNumberField('scriptsWrittenPastSixMonths',dummy);
                    gen.writeNumberField('percentageChangePastMonth',percentageChangePastMonth);
                    gen.writeNumberField('percentageChangePastThreeMonths',percentageChangePastThreeMonths);
                    gen.writeNumberField('percentageChangePastSixMonths',dummy);
               }
               
                
        }
       if(CallPlanningsList[CallPlanningCount].Range__c.Equals('6M'))
        {
                gen.writeNumberField('scriptsWrittenPastSixMonths',CallPlanningsList[CallPlanningCount].TRx_Units__c);
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c!=0)
                {
                percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units__c)*100;
                percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
                }
                else
                percentageChangePastThreeMonths=0;
                gen.writeNumberField('percentageChangePastMonth',percentageChangePastMonth);
                gen.writeNumberField('percentageChangePastThreeMonths',percentageChangePastThreeMonths);
                gen.writeNumberField('percentageChangePastSixMonths',percentageChangePastSixMonths);
            }
            
            
       
       if((CallPlanningCount+1 == CallPlanningsList.size() )||(!firstNameLastName.equals(CallPlanningsList[CallPlanningCount+1].First_Name__c+CallPlanningsList[CallPlanningCount+1].Last_Name__c)))
        {
                
                gen.writeEndObject();
                gen.writeEndArray();
                InitialCallCount=CallsCount;
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
                gen.writeFieldName('calls');
                gen.writeStartArray();
                firstCall=1;
                usercallcount=0;
                for(integer i = CallsCount; i<CallsList.Size(); i++)
                {
                    CallsCount = i;
                    
                    if(usercallcount==5)
                    {
                        
                        gen.writeEndObject();
                        gen.writeEndArray();
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
                                gen.writeStartObject();
                                firstCall=0;
                            }
                            else
                            {
                                gen.writeEndObject();
                                gen.writeStartObject();
                            }
                            
                            gen.writeStringField('date',CallsList[i].Call_Date__c.format('MM/dd/yyyy'));   
                            gen.writeStringField('type',CallsList[i].Call_Type__c);
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
                                if(CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL))
                                {
                                    gen.writeStringField('product2',CallsList[i].Product__r.Name);
                                    
                                }
                            }
                            else
                            {
                                if((CallsList[i].Product__c!=NULL))
                                {
                                gen.writeStringField('product1',CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        
                        
                        if((callsProductNumber<=2)&&(!CallsList[i].Call_Type__c.equals('Sample Only')))
                        {
                            if(callsProductNumber==2)
                            {
                                if(CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL)&&(CallsList[i].Product_Position__c==2))
                                {
                                    gen.writeStringField('product2',CallsList[i].Product__r.Name);
                                    
                                }
                            }
                            else
                            {
                             if((CallsList[i].Product__c!=NULL)&&CallsList[i].Product_Position__c==1)
                                {
                                 gen.writeStringField('product1',CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        if((i+1 == CallsList.size() )||(!firstNameLastName.equals(CallsList[i+1].First_Name__c+CallsList[i+1].Last_Name__c)))
                        {
                            //closing all calls
                            
                            gen.writeEndObject();
                            gen.writeEndArray();
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


    gen.writeEndObject();
    gen.writeEndArray();
    //System.Debug('&&&'+sdata);
    sdata = gen.getAsString();
    sdata=sdata.replaceall('\n','');
    System.Debug('%%%%' + sdata);
    Object obj=Json.deserializeUntyped(sdata);
    return obj;
    
    
 }    
     
}