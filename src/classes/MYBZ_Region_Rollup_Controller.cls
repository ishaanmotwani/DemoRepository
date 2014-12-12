/*
 *@ Class Name                                                    : MYBZ_RegionRollup_Controller
 *@ Description                                                   : Class for retrieving salesforce data in the form of a string and returning as a JSON object via a remote action.
 *@ CreatedBy                                                     : Neelam Dalwani
 *@ CreatedOn                                                     : 09-30-2014
 *@ Modification Log                                              :
 */


global with sharing class MYBZ_Region_Rollup_Controller
{

    global static Id UserId;
    global static String Role{get;set;}
    global static String GlobalId{get;set;}
    global static String uname{get;set;}
  
    global MYBZ_Region_Rollup_Controller(){
        UserId = UserInfo.getUserId();
        User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        uname=userObj.name;
    }
   
    /* 
          * @Method Name                    :  Region Rollup
          * @Description                    :  JavaScript remoting to allow Alignment record to be retrieved from Salesforce in the form of a JSON object to show Region Rollup Report.                                        
          * @Return Type                    :  object
          * @Param                          :   Region - The region associated to the territory selected, District - The district associated to the territory selected
                                               Territory - The territory selected via a territory picker.  
                                            
    */
    
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
        
        List<String> rangeData = new List<String>{'oneMonthData','threeMonthData','sixMonthData'};
        List<String> metricDates = new List<String>{'opexStartDates','netProfitStartDates','grossMarginsStartDates','trxStartDates','nrxStartDates','dddStartDates'};
        
        List <MYBZ_Region_Rollup__c> regionList = new List <MYBZ_Region_Rollup__c>();
        List <MYBZ_Region_Rollup__c> districtList = new List <MYBZ_Region_Rollup__c>();
        List <MYBZ_Region_Rollup__c> territoryList = new List <MYBZ_Region_Rollup__c>();
        
        Map<String,Map<String,MYBZ_Region_Rollup__c>> mapRegionNameAndRegion=new Map<String,Map<String,MYBZ_Region_Rollup__c>>();
        Map<String,Set<String>> mapRegionNameAndDistrictName=new Map<String,Set<String>>();
        Map<String,Map<String,MYBZ_Region_Rollup__c>> mapDistrictNameAndDistrict=new Map<String,Map<String,MYBZ_Region_Rollup__c>>();
        Map<String,Set<String>> mapDistrictNameAndTerritoryName=new Map<String,Set<String>>();
        Map<String, Map<String,MYBZ_Region_Rollup__c>> mapTerritoryNameAndTerritory = new  Map<String, Map<String,MYBZ_Region_Rollup__c>>();
        
        for(MYBZ_Region_Rollup__c regRoll : [SELECT Region__r.Name, District__r.Name, Territory__r.Name, Gross_Margin_1M__c, Gross_Margin_3M__c, Gross_Margin_6M__c, Gross_Margin_Start_Date_1M__c, Gross_Margin_Start_Date_3M__c, Gross_Margin_Start_Date_6M__c, Net_Profit_1M__c, Net_Profit_3M__c, Net_Profit_6M__c, Net_Profit_Start_Date_1M__c, Net_Profit_Start_Date_3M__c, Net_Profit_Start_Date_6M__c, NRx_1M__c, NRx_3M__c, NRx_6M__c, NRx_Start_Date_1M__c, NRx_Start_Date_3M__c, NRx_Start_Date_6M__c, OPEX_1M__c, OPEX_3M__c, OPEX_6M__c, OPEX_Start_Date_1M__c, OPEX_Start_Date_3M__c, OPEX_Start_Date_6M__c, TRx_1M__c, TRx_3M__c, TRx_6M__c, TRx_Start_Date_1M__c, TRx_Start_Date_3M__c, TRx_Start_Date_6M__c, DDD_Dollars_1M__c, DDD_Dollars_3M__c, DDD_Dollars_6M__c, DDD_Dollars_Start_Date_1M__c, DDD_Dollars_Start_Date_3M__c, DDD_Dollars_Start_Date_6M__c, Global_Id__c, Region__r.Parent__c, Product__r.Name, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Region__r.Parent__c =: divisionObj.id AND Product__c!=null]){
            if(regRoll.Alignment_Level__c == System.Label.MYBZ_Region){
                regionList.add(regRoll);
            }
            if(regRoll.Alignment_Level__c == System.Label.MYBZ_District){
                districtList.add(regRoll);
            }
            if(regRoll.Alignment_Level__c == System.Label.MYBZ_Territory){
                territoryList.add(regRoll);
            }
        }
        if(!regionList.isEmpty()){
            for(MYBZ_Region_Rollup__c regionObj : regionList)
            {
                if(!mapRegionNameAndRegion.containsKey(regionObj.Region__r.Name))
                {
                 Map<String,MYBZ_Region_Rollup__c> tempRegionRollupMap = new Map<String,MYBZ_Region_Rollup__c>();
                   tempRegionRollupMap.put(regionObj.Product__r.Name,regionObj);
                   mapRegionNameAndRegion.put(regionObj.Region__r.Name,tempRegionRollupMap);
                }
                else 
                {
                    if(!mapRegionNameAndRegion.get(regionObj.Region__r.Name).containsKey(regionObj.Product__r.Name))
                        mapRegionNameAndRegion.get(regionObj.Region__r.Name).put(regionObj.Product__r.Name,regionObj);
                
                }
            }
        }
        if(!districtList.isEmpty()){
            for(MYBZ_Region_Rollup__c districtObj : districtList)
            {
                if(!mapRegionNameAndDistrictName.containsKey(districtObj.Region__r.Name))
                {
                    Set<String> tempDistrictName=new Set<String>();
                    tempDistrictName.add(districtObj.District__r.Name);
                    mapRegionNameAndDistrictName.put(districtObj.Region__r.Name,tempDistrictName);
                }
                else 
                {
                    mapRegionNameAndDistrictName.get(districtObj.Region__r.Name).add(districtObj.District__r.Name);
                }
                if(!mapDistrictNameAndDistrict.containsKey(districtObj.District__r.Name))
                {
                    Map<String,MYBZ_Region_Rollup__c> tempDistrictMap = new Map<String,MYBZ_Region_Rollup__c>();
                    tempDistrictMap.put(districtObj.Product__r.Name,districtObj);
                    mapDistrictNameAndDistrict.put(districtObj.District__r.Name,tempDistrictMap);
                        
                }
                else 
                {
                    if(!mapDistrictNameAndDistrict.get(districtObj.District__r.Name).containsKey(districtObj.Product__r.Name))
                    mapDistrictNameAndDistrict.get(districtObj.District__r.Name).put(districtObj.Product__r.Name,districtObj);
            
                }
            }
        }
        
        
        if(!territoryList.isEmpty()){
        
            for(MYBZ_Region_Rollup__c territoryObj : territoryList){
            
                if(!mapDistrictNameAndTerritoryName.containsKey(territoryObj.District__r.Name))
                {
                    Set<String> tempTerrName=new Set<String>();
                    tempTerrName.add(territoryObj.Territory__r.Name);
                    mapDistrictNameAndTerritoryName.put(territoryObj.District__r.Name,tempTerrName);
                }
                else
                {
                    mapDistrictNameAndTerritoryName.get(territoryObj.District__r.Name).add(territoryObj.Territory__r.Name);
                }
                if(!mapTerritoryNameAndTerritory.containsKey(territoryObj.Territory__r.Name))
                {
                    Map<String,MYBZ_Region_Rollup__c> tempTerrMap = new Map<String,MYBZ_Region_Rollup__c>();
                    tempTerrMap.put(territoryObj.Product__r.Name,territoryObj);
                    mapTerritoryNameAndTerritory.put(territoryObj.Territory__r.Name,tempTerrMap);
                }
                else 
                {
                    if(!mapTerritoryNameAndTerritory.get(territoryObj.Territory__r.Name).containsKey(territoryObj.Product__r.Name))
                    mapTerritoryNameAndTerritory.get(territoryObj.Territory__r.Name).put(territoryObj.Product__r.Name,territoryObj);
            
                }
            }
        }
        
        system.debug('mapRegionNameAndRegion--'+mapRegionNameAndRegion);
        system.debug('mapRegionNameAndDistrictName--'+mapRegionNameAndDistrictName);
        system.debug('mapDistrictNameAndDistrict--'+mapDistrictNameAndDistrict);
        system.debug('mapDistrictNameAndTerritoryName--'+mapDistrictNameAndTerritoryName);
        system.debug('mapTerritoryNameAndTerritory--'+mapTerritoryNameAndTerritory);
        if(!regionList.isEmpty()){
           for(MYBZ_Region_Rollup__c regionObj : regionList){
                if(regionObj.Product__r.Name == System.Label.MYBZ_EFFIENT){
                    firstRegionName = regionObj.Region__r.Name;
                    break;
                }
            }
            
            gen = JSON.createGenerator(true);
            gen.writeStartObject();  
            gen.writeStringField(System.Label.MYBZ_Name,divisionObj.Name);
            
            for(String str : metricDates){
                gen.writeFieldName(str);
                gen.writeStartObject();
                if(str == 'opexStartDates'){
                    if(regionList[0].OPEX_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].OPEX_Start_Date_1M__c);
                    }
                    if(regionList[0].OPEX_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].OPEX_Start_Date_3M__c);
                    }
                    if(regionList[0].OPEX_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].OPEX_Start_Date_6M__c);
                    }
                }
                else if(str == 'netProfitStartDates'){
                    if(regionList[0].Net_Profit_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].Net_Profit_Start_Date_1M__c);
                    }
                    if(regionList[0].Net_Profit_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].Net_Profit_Start_Date_3M__c);
                    }
                    if(regionList[0].Net_Profit_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].Net_Profit_Start_Date_6M__c);
                    }
                }
                else if(str == 'grossMarginsStartDates'){
                    if(regionList[0].Gross_Margin_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].Gross_Margin_Start_Date_1M__c);
                    }
                    if(regionList[0].Gross_Margin_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].Gross_Margin_Start_Date_3M__c);
                    }
                    if(regionList[0].Gross_Margin_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].Gross_Margin_Start_Date_6M__c);
                    }
                }
                else if(str == 'trxStartDates'){
                    if(regionList[0].TRx_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].TRx_Start_Date_1M__c);
                    }
                    if(regionList[0].TRx_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].TRx_Start_Date_3M__c);
                    }
                    if(regionList[0].TRx_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].TRx_Start_Date_6M__c);
                    }
                }
                else if(str == 'nrxStartDates'){
                    if(regionList[0].NRx_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].NRx_Start_Date_1M__c);
                    }
                    if(regionList[0].NRx_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].NRx_Start_Date_3M__c);
                    }
                    if(regionList[0].NRx_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].NRx_Start_Date_6M__c);
                    }
                }
                else if(str == 'dddStartDates'){
                    if(regionList[0].DDD_Dollars_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].DDD_Dollars_Start_Date_1M__c);
                    }
                    if(regionList[0].DDD_Dollars_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].DDD_Dollars_Start_Date_3M__c);
                    }
                    if(regionList[0].DDD_Dollars_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].DDD_Dollars_Start_Date_6M__c);
                    }
                }
                gen.writeEndObject();
            }
            if(!mapRegionNameAndRegion.isEmpty()){
                gen.writeFieldName(System.Label.MYBZ_children);
                gen.writeStartArray();
                for(String regionName : mapRegionNameAndRegion.keySet())
                {
                    gen.writeStartObject(); 
                    gen.writeStringField(System.Label.MYBZ_Name,regionName);
                    if(!mapRegionNameAndRegion.get(regionName).isEmpty())
                    {
                        Map<String,MYBZ_Region_Rollup__c> regionsMap = mapRegionNameAndRegion.get(regionName);
                        for(String str : rangeData){
                            gen.writeFieldName(str);
                            gen.writeStartArray();
                            for(String eachProduct : regionsMap.keySet()){
                                MYBZ_Region_Rollup__c tempRegionObj = regionsMap.get(eachProduct);
                                if(str == 'oneMonthData'){
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_1M__c);
                                    if(tempRegionObj.DDD_Dollars_1M__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_1M__c);
                                    else
                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                    gen.writeEndObject();
                                }
                                if(str == 'threeMonthData'){
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_3M__c);
                                    if(tempRegionObj.DDD_Dollars_3M__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_3M__c);
                                    else
                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                    gen.writeEndObject();
                                }
                                if(str == 'sixMonthData'){
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_6M__c);
                                    if(tempRegionObj.DDD_Dollars_6M__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_6M__c);
                                    else
                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                    gen.writeEndObject();
                                }
                            }
                            gen.writeEndArray();
                        }
                    }
                
                    if(!mapRegionNameAndDistrictName.get(regionName).isEmpty()){
                        gen.writeFieldName(System.Label.MYBZ_children);
                        gen.writeStartArray();
                        for(String distName : mapRegionNameAndDistrictName.get(regionName))
                        {
                            gen.writeStartObject(); 
                            gen.writeStringField(System.Label.MYBZ_Name,distName);
                            system.debug('distName--'+distName);
                            if(!mapDistrictNameAndDistrict.get(distName).isEmpty())
                            {
                                Map<String,MYBZ_Region_Rollup__c> distMap = mapDistrictNameAndDistrict.get(distName);
                                for(String str : rangeData){
                                    gen.writeFieldName(str);
                                    gen.writeStartArray();
                                    for(String eachProduct : distMap.keySet()){
                                        MYBZ_Region_Rollup__c tempdistObj = distMap.get(eachProduct);
                                        if(str == 'oneMonthData'){
                                            gen.writeStartObject();
                                            gen.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                            gen.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_1M__c);
                                            if(tempdistObj.DDD_Dollars_1M__c !=null)
                                                gen.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_1M__c);
                                            else
                                                gen.writeNullField(System.Label.MYBZ_dddDollars);
                                             gen.writeEndObject();
                                        }
                                        if(str == 'threeMonthData'){
                                            gen.writeStartObject();
                                            gen.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                            gen.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_3M__c);
                                            if(tempdistObj.DDD_Dollars_3M__c !=null)
                                                gen.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_3M__c);
                                            else
                                                gen.writeNullField(System.Label.MYBZ_dddDollars);
                                            gen.writeEndObject();
                                        }
                                        if(str == 'sixMonthData'){
                                            gen.writeStartObject();
                                            gen.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                            gen.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_6M__c);
                                            if(tempdistObj.DDD_Dollars_6M__c !=null)
                                                gen.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_6M__c);
                                            else
                                                gen.writeNullField(System.Label.MYBZ_dddDollars);
                                            gen.writeEndObject();
                                        }
                                    }
                                    gen.writeEndArray();
                                }
                            }
                            if(!mapDistrictNameAndTerritoryName.get(distName).isEmpty()){
                                gen.writeFieldName(System.Label.MYBZ_children);
                                gen.writeStartArray();
                                for(String terrName : mapDistrictNameAndTerritoryName.get(distName))
                                {
                                    gen.writeStartObject(); 
                                    gen.writeStringField(System.Label.MYBZ_Name,terrName);
                            
                                    if(!mapTerritoryNameAndTerritory.get(terrName).isEmpty())
                                    {
                                        Map<String,MYBZ_Region_Rollup__c> terrMap = mapTerritoryNameAndTerritory.get(terrName);
                                        for(String str : rangeData){
                                            gen.writeFieldName(str);
                                            gen.writeStartArray();
                                            for(String eachProduct : terrMap.keySet()){
                                                MYBZ_Region_Rollup__c tempTerrtObj = terrMap.get(eachProduct);
                                                if(str == 'oneMonthData'){
                                                    gen.writeStartObject();
                                                    gen.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_1M__c);
                                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_1M__c);
                                                    if(tempTerrtObj.DDD_Dollars_1M__c !=null)
                                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_1M__c);
                                                    else
                                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                                    gen.writeEndObject();
                                                }
                                                if(str == 'threeMonthData'){
                                                    gen.writeStartObject();
                                                    gen.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_3M__c);
                                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_3M__c);
                                                    if(tempTerrtObj.DDD_Dollars_3M__c !=null)
                                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_3M__c);
                                                    else
                                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                                    gen.writeEndObject();
                                                }
                                                if(str == 'sixMonthData'){
                                                    gen.writeStartObject();
                                                    gen.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_6M__c);
                                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_6M__c);
                                                    if(tempTerrtObj.DDD_Dollars_6M__c !=null)
                                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_6M__c);
                                                    else
                                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                                    gen.writeEndObject();
                                                }
                                            }
                                            gen.writeEndArray();
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
            }
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
        
        List<String> rangeData = new List<String>{'oneMonthData','threeMonthData','sixMonthData'};
        List<String> metricDates = new List<String>{'opexStartDates','netProfitStartDates','grossMarginsStartDates','trxStartDates','nrxStartDates','dddStartDates'};
        
        List <MYBZ_Region_Rollup__c> regionList = new List <MYBZ_Region_Rollup__c>();
        List <MYBZ_Region_Rollup__c> districtList = new List <MYBZ_Region_Rollup__c>();
        List <MYBZ_Region_Rollup__c> territoryList = new List <MYBZ_Region_Rollup__c>();
        
        Map<String,Map<String,MYBZ_Region_Rollup__c>> mapRegionNameAndRegion=new Map<String,Map<String,MYBZ_Region_Rollup__c>>();
        Map<String,Set<String>> mapRegionNameAndDistrictName=new Map<String,Set<String>>();
        Map<String,Map<String,MYBZ_Region_Rollup__c>> mapDistrictNameAndDistrict=new Map<String,Map<String,MYBZ_Region_Rollup__c>>();
        Map<String,Set<String>> mapDistrictNameAndTerritoryName=new Map<String,Set<String>>();
        Map<String, Map<String,MYBZ_Region_Rollup__c>> mapTerritoryNameAndTerritory = new  Map<String, Map<String,MYBZ_Region_Rollup__c>>();
        
        for(MYBZ_Region_Rollup__c regRoll : [SELECT Region__r.Name, District__r.Name, Territory__r.Name, Gross_Margin_1M__c, Gross_Margin_3M__c, Gross_Margin_6M__c, Gross_Margin_Start_Date_1M__c, Gross_Margin_Start_Date_3M__c, Gross_Margin_Start_Date_6M__c, Net_Profit_1M__c, Net_Profit_3M__c, Net_Profit_6M__c, Net_Profit_Start_Date_1M__c, Net_Profit_Start_Date_3M__c, Net_Profit_Start_Date_6M__c, NRx_1M__c, NRx_3M__c, NRx_6M__c, NRx_Start_Date_1M__c, NRx_Start_Date_3M__c, NRx_Start_Date_6M__c, OPEX_1M__c, OPEX_3M__c, OPEX_6M__c, OPEX_Start_Date_1M__c, OPEX_Start_Date_3M__c, OPEX_Start_Date_6M__c, TRx_1M__c, TRx_3M__c, TRx_6M__c, TRx_Start_Date_1M__c, TRx_Start_Date_3M__c, TRx_Start_Date_6M__c, DDD_Dollars_1M__c, DDD_Dollars_3M__c, DDD_Dollars_6M__c, DDD_Dollars_Start_Date_1M__c, DDD_Dollars_Start_Date_3M__c, DDD_Dollars_Start_Date_6M__c, Global_Id__c, Region__r.Parent__c, Product__r.Name, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Region__r.Parent__c =: divisionObj.id AND Product__c!=null]){
            if(regRoll.Alignment_Level__c == System.Label.MYBZ_Region){
                regionList.add(regRoll);
            }
            if(regRoll.Alignment_Level__c == System.Label.MYBZ_District){
                districtList.add(regRoll);
            }
            if(regRoll.Alignment_Level__c == System.Label.MYBZ_Territory){
                territoryList.add(regRoll);
            }
        }
        if(!regionList.isEmpty()){
            for(MYBZ_Region_Rollup__c regionObj : regionList)
            {
                if(!mapRegionNameAndRegion.containsKey(regionObj.Region__r.Name))
                {
                 Map<String,MYBZ_Region_Rollup__c> tempRegionRollupMap = new Map<String,MYBZ_Region_Rollup__c>();
                   tempRegionRollupMap.put(regionObj.Product__r.Name,regionObj);
                   mapRegionNameAndRegion.put(regionObj.Region__r.Name,tempRegionRollupMap);
                }
                else 
                {
                    if(!mapRegionNameAndRegion.get(regionObj.Region__r.Name).containsKey(regionObj.Product__r.Name))
                        mapRegionNameAndRegion.get(regionObj.Region__r.Name).put(regionObj.Product__r.Name,regionObj);
                
                }
            }
        }
        if(!districtList.isEmpty()){
            for(MYBZ_Region_Rollup__c districtObj : districtList)
            {
                if(!mapRegionNameAndDistrictName.containsKey(districtObj.Region__r.Name))
                {
                    Set<String> tempDistrictName=new Set<String>();
                    tempDistrictName.add(districtObj.District__r.Name);
                    mapRegionNameAndDistrictName.put(districtObj.Region__r.Name,tempDistrictName);
                }
                else 
                {
                    mapRegionNameAndDistrictName.get(districtObj.Region__r.Name).add(districtObj.District__r.Name);
                }
                if(!mapDistrictNameAndDistrict.containsKey(districtObj.District__r.Name))
                {
                    Map<String,MYBZ_Region_Rollup__c> tempDistrictMap = new Map<String,MYBZ_Region_Rollup__c>();
                    tempDistrictMap.put(districtObj.Product__r.Name,districtObj);
                    mapDistrictNameAndDistrict.put(districtObj.District__r.Name,tempDistrictMap);
                        
                }
                else 
                {
                    if(!mapDistrictNameAndDistrict.get(districtObj.District__r.Name).containsKey(districtObj.Product__r.Name))
                    mapDistrictNameAndDistrict.get(districtObj.District__r.Name).put(districtObj.Product__r.Name,districtObj);
            
                }
            }
        }
        
        
        if(!territoryList.isEmpty()){
        
            for(MYBZ_Region_Rollup__c territoryObj : territoryList){
            
                if(!mapDistrictNameAndTerritoryName.containsKey(territoryObj.District__r.Name))
                {
                    Set<String> tempTerrName=new Set<String>();
                    tempTerrName.add(territoryObj.Territory__r.Name);
                    mapDistrictNameAndTerritoryName.put(territoryObj.District__r.Name,tempTerrName);
                }
                else
                {
                    mapDistrictNameAndTerritoryName.get(territoryObj.District__r.Name).add(territoryObj.Territory__r.Name);
                }
                if(!mapTerritoryNameAndTerritory.containsKey(territoryObj.Territory__r.Name))
                {
                    Map<String,MYBZ_Region_Rollup__c> tempTerrMap = new Map<String,MYBZ_Region_Rollup__c>();
                    tempTerrMap.put(territoryObj.Product__r.Name,territoryObj);
                    mapTerritoryNameAndTerritory.put(territoryObj.Territory__r.Name,tempTerrMap);
                }
                else 
                {
                    if(!mapTerritoryNameAndTerritory.get(territoryObj.Territory__r.Name).containsKey(territoryObj.Product__r.Name))
                    mapTerritoryNameAndTerritory.get(territoryObj.Territory__r.Name).put(territoryObj.Product__r.Name,territoryObj);
            
                }
            }
        }
        
        system.debug('mapRegionNameAndRegion--'+mapRegionNameAndRegion);
        system.debug('mapRegionNameAndDistrictName--'+mapRegionNameAndDistrictName);
        system.debug('mapDistrictNameAndDistrict--'+mapDistrictNameAndDistrict);
        system.debug('mapDistrictNameAndTerritoryName--'+mapDistrictNameAndTerritoryName);
        system.debug('mapTerritoryNameAndTerritory--'+mapTerritoryNameAndTerritory);
        if(!regionList.isEmpty()){
            for(MYBZ_Region_Rollup__c regionObj : regionList){
                if(regionObj.Product__r.Name == System.Label.MYBZ_EFFIENT){
                    firstRegionName = regionObj.Region__r.Name;
                    break;
                }
            }
            
            gen = JSON.createGenerator(true);
            gen.writeStartObject();  
            gen.writeStringField(System.Label.MYBZ_Name,divisionObj.Name);
            
            for(String str : metricDates){
                gen.writeFieldName(str);
                gen.writeStartObject();
                if(str == 'opexStartDates'){
                    if(regionList[0].OPEX_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].OPEX_Start_Date_1M__c);
                    }
                    if(regionList[0].OPEX_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].OPEX_Start_Date_3M__c);
                    }
                    if(regionList[0].OPEX_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].OPEX_Start_Date_6M__c);
                    }
                }
                else if(str == 'netProfitStartDates'){
                    if(regionList[0].Net_Profit_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].Net_Profit_Start_Date_1M__c);
                    }
                    if(regionList[0].Net_Profit_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].Net_Profit_Start_Date_3M__c);
                    }
                    if(regionList[0].Net_Profit_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].Net_Profit_Start_Date_6M__c);
                    }
                }
                else if(str == 'grossMarginsStartDates'){
                    if(regionList[0].Gross_Margin_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].Gross_Margin_Start_Date_1M__c);
                    }
                    if(regionList[0].Gross_Margin_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].Gross_Margin_Start_Date_3M__c);
                    }
                    if(regionList[0].Gross_Margin_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].Gross_Margin_Start_Date_6M__c);
                    }
                }
                else if(str == 'trxStartDates'){
                    if(regionList[0].TRx_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].TRx_Start_Date_1M__c);
                    }
                    if(regionList[0].TRx_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].TRx_Start_Date_3M__c);
                    }
                    if(regionList[0].TRx_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].TRx_Start_Date_6M__c);
                    }
                }
                else if(str == 'nrxStartDates'){
                    if(regionList[0].NRx_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].NRx_Start_Date_1M__c);
                    }
                    if(regionList[0].NRx_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].NRx_Start_Date_3M__c);
                    }
                    if(regionList[0].NRx_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].NRx_Start_Date_6M__c);
                    }
                }
                else if(str == 'dddStartDates'){
                    if(regionList[0].DDD_Dollars_Start_Date_1M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,regionList[0].DDD_Dollars_Start_Date_1M__c);
                    }
                    if(regionList[0].DDD_Dollars_Start_Date_3M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,regionList[0].DDD_Dollars_Start_Date_3M__c);
                    }
                    if(regionList[0].DDD_Dollars_Start_Date_6M__c != null){
                        gen.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,regionList[0].DDD_Dollars_Start_Date_6M__c);
                    }
                }
                gen.writeEndObject();
            }
            if(!mapRegionNameAndRegion.isEmpty()){
                gen.writeFieldName(System.Label.MYBZ_children);
                gen.writeStartArray();
                for(String regionName : mapRegionNameAndRegion.keySet())
                {
                    gen.writeStartObject(); 
                    gen.writeStringField(System.Label.MYBZ_Name,regionName);
                    if(!mapRegionNameAndRegion.get(regionName).isEmpty())
                    {
                        Map<String,MYBZ_Region_Rollup__c> regionsMap = mapRegionNameAndRegion.get(regionName);
                        for(String str : rangeData){
                            gen.writeFieldName(str);
                            gen.writeStartArray();
                            for(String eachProduct : regionsMap.keySet()){
                                MYBZ_Region_Rollup__c tempRegionObj = regionsMap.get(eachProduct);
                                if(str == 'oneMonthData'){
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_1M__c);
                                    gen.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_1M__c);
                                    if(tempRegionObj.DDD_Dollars_1M__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_1M__c);
                                    else
                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                    gen.writeEndObject();
                                }
                                if(str == 'threeMonthData'){
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_3M__c);
                                    gen.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_3M__c);
                                    if(tempRegionObj.DDD_Dollars_3M__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_3M__c);
                                    else
                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                    gen.writeEndObject();
                                }
                                if(str == 'sixMonthData'){
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_6M__c);
                                    gen.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_6M__c);
                                    if(tempRegionObj.DDD_Dollars_6M__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_6M__c);
                                    else
                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                    gen.writeEndObject();
                                }
                            }
                            gen.writeEndArray();
                        }
                    }
                
                    if(!mapRegionNameAndDistrictName.get(regionName).isEmpty()){
                        gen.writeFieldName(System.Label.MYBZ_children);
                        gen.writeStartArray();
                        for(String distName : mapRegionNameAndDistrictName.get(regionName))
                        {
                            gen.writeStartObject(); 
                            gen.writeStringField(System.Label.MYBZ_Name,distName);
                            system.debug('distName--'+distName);
                            if(!mapDistrictNameAndDistrict.get(distName).isEmpty())
                            {
                                Map<String,MYBZ_Region_Rollup__c> distMap = mapDistrictNameAndDistrict.get(distName);
                                for(String str : rangeData){
                                    gen.writeFieldName(str);
                                    gen.writeStartArray();
                                    for(String eachProduct : distMap.keySet()){
                                        MYBZ_Region_Rollup__c tempdistObj = distMap.get(eachProduct);
                                        if(str == 'oneMonthData'){
                                            gen.writeStartObject();
                                            gen.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                            gen.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_1M__c);
                                            gen.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_1M__c);
                                            if(tempdistObj.DDD_Dollars_1M__c !=null)
                                                gen.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_1M__c);
                                            else
                                                gen.writeNullField(System.Label.MYBZ_dddDollars);
                                             gen.writeEndObject();
                                        }
                                        if(str == 'threeMonthData'){
                                            gen.writeStartObject();
                                            gen.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                            gen.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_3M__c);
                                            gen.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_3M__c);
                                            if(tempdistObj.DDD_Dollars_3M__c !=null)
                                                gen.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_3M__c);
                                            else
                                                gen.writeNullField(System.Label.MYBZ_dddDollars);
                                            gen.writeEndObject();
                                        }
                                        if(str == 'sixMonthData'){
                                            gen.writeStartObject();
                                            gen.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                            gen.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_6M__c);
                                            gen.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_6M__c);
                                            if(tempdistObj.DDD_Dollars_6M__c !=null)
                                                gen.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_6M__c);
                                            else
                                                gen.writeNullField(System.Label.MYBZ_dddDollars);
                                            gen.writeEndObject();
                                        }
                                    }
                                    gen.writeEndArray();
                                }
                            }
                            if(!mapDistrictNameAndTerritoryName.get(distName).isEmpty()){
                                gen.writeFieldName(System.Label.MYBZ_children);
                                gen.writeStartArray();
                                for(String terrName : mapDistrictNameAndTerritoryName.get(distName))
                                {
                                    gen.writeStartObject(); 
                                    gen.writeStringField(System.Label.MYBZ_Name,terrName);
                            
                                    if(!mapTerritoryNameAndTerritory.get(terrName).isEmpty())
                                    {
                                        Map<String,MYBZ_Region_Rollup__c> terrMap = mapTerritoryNameAndTerritory.get(terrName);
                                        for(String str : rangeData){
                                            gen.writeFieldName(str);
                                            gen.writeStartArray();
                                            for(String eachProduct : terrMap.keySet()){
                                                MYBZ_Region_Rollup__c tempTerrtObj = terrMap.get(eachProduct);
                                                if(str == 'oneMonthData'){
                                                    gen.writeStartObject();
                                                    gen.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_1M__c);
                                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_1M__c);
                                                    if(tempTerrtObj.DDD_Dollars_1M__c !=null)
                                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_1M__c);
                                                    else
                                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                                    gen.writeEndObject();
                                                }
                                                if(str == 'threeMonthData'){
                                                    gen.writeStartObject();
                                                    gen.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_3M__c);
                                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_3M__c);
                                                    if(tempTerrtObj.DDD_Dollars_3M__c !=null)
                                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_3M__c);
                                                    else
                                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                                    gen.writeEndObject();
                                                }
                                                if(str == 'sixMonthData'){
                                                    gen.writeStartObject();
                                                    gen.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                    gen.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_6M__c);
                                                    gen.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_6M__c);
                                                    if(tempTerrtObj.DDD_Dollars_6M__c !=null)
                                                        gen.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_6M__c);
                                                    else
                                                        gen.writeNullField(System.Label.MYBZ_dddDollars);
                                                    gen.writeEndObject();
                                                }
                                            }
                                            gen.writeEndArray();
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
            }
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
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
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
        
        List <MYBZ_Region_Rollup__c> regionList = [SELECT Id, Region__r.Name, Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Region];
        if(!regionList.isEmpty())
        {
            for(MYBZ_Region_Rollup__c regionObj : regionList){
                if(!RegionNameAndGlobalIdMap.containsKey(regionObj.Region__r.Name)){
                    RegionNameAndGlobalIdMap.put(regionObj.Region__r.Name, regionObj.Global_Id__c);
                }
            }
        }
        
        List <MYBZ_Region_Rollup__c> districtList = [SELECT Id, Region__r.Name, District__r.Name, Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_District];
        
        if(!districtList.isEmpty()){
            for(MYBZ_Region_Rollup__c districtObj : districtList){
                if(!RegionNameAndDistrictMap.containsKey(districtObj.Region__r.Name)){
                    Set<String> districtNames = new Set<String>();
                    districtNames.add(districtObj.District__r.Name);
                    RegionNameAndDistrictMap.put(districtObj.Region__r.Name, districtNames);
                }
                else{
                    RegionNameAndDistrictMap.get(districtObj.Region__r.Name).add(districtObj.District__r.Name);
                }
                if(!DistrictNameAndGlobalIdMap.containsKey(districtObj.District__r.Name)){
                    DistrictNameAndGlobalIdMap.put(districtObj.District__r.Name, districtObj.Global_Id__c);
                }
            }
        }
        
        List <MYBZ_Region_Rollup__c> territoryList = [SELECT Id, Territory__r.Name, District__r.Name, Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Territory];
        
        if(!territoryList.isEmpty()){
            for(MYBZ_Region_Rollup__c territoryObj : territoryList){
                if(!DistrictNameAndTerritoryMap.containsKey(territoryObj.District__r.Name)){
                    Set<String> territoryNames = new Set<String>();
                    territoryNames.add(territoryObj.Territory__r.Name);
                    DistrictNameAndTerritoryMap.put(territoryObj.District__r.Name, territoryNames);
                }
                else{
                    DistrictNameAndTerritoryMap.get(territoryObj.District__r.Name).add(territoryObj.Territory__r.Name);
                }
                if(!TerritoryNameAndGlobalIdMap.containsKey(territoryObj.Territory__r.Name)){
                    TerritoryNameAndGlobalIdMap.put(territoryObj.Territory__r.Name, territoryObj.Global_Id__c);
                }
            }
        }
        if(!RegionNameAndGlobalIdMap.isEmpty() && !RegionNameAndDistrictMap.isEmpty() && !DistrictNameAndGlobalIdMap.isEmpty() && !DistrictNameAndTerritoryMap.isEmpty() && !TerritoryNameAndGlobalIdMap.isEmpty()){
            gen.writeStartArray();
            System.debug('Inside');
            for(String regionName : RegionNameAndGlobalIdMap.keySet()){
                gen.writeStartObject();
                gen.writeStringField(System.Label.MYBZ_Name,regionName);
                String regionGlobalId = RegionNameAndGlobalIdMap.get(regionName);
                gen.writeStringField(System.Label.MYBZ_globalID,regionGlobalId);
                
                if(RegionNameAndDistrictMap.containsKey(regionName)){
                    gen.writeFieldName(System.Label.MYBZ_children);
                    gen.writeStartArray();
                    
                    for(String districtName : RegionNameAndDistrictMap.get(regionName)){
                        gen.writeStartObject();
                        gen.writeStringField(System.Label.MYBZ_Name,districtName);
                        String districtGlobalId = DistrictNameAndGlobalIdMap.get(districtName);
                        gen.writeStringField(System.Label.MYBZ_globalID,districtGlobalId);
                        if(DistrictNameAndTerritoryMap.containsKey(districtName)){
                            gen.writeFieldName(System.Label.MYBZ_children);
                            gen.writeStartArray();
                            for(String territoryName : DistrictNameAndTerritoryMap.get(districtName)){
                                gen.writeStartObject();
                                gen.writeStringField(System.Label.MYBZ_Name,territoryName);
                                String territoryGlobalId = TerritoryNameAndGlobalIdMap.get(territoryName);
                                if(territoryGlobalId == null || territoryGlobalId == '')
                                    gen.writeNullField(System.Label.MYBZ_globalID); 
                                else
                                    gen.writeStringField(System.Label.MYBZ_globalID,territoryGlobalId);
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
    /* 
          * @Method Name                    :  Alignment
          * @Description                    :  JavaScript remoting to allow Alignment record to be retrieved from Salesforce in the form of a JSON object to show alignment dropdown in territory picker.                                        
          * @Return Type                    :  object
          * @Param                          :  
    */
    
    @RemoteAction 
    global static Object Alignment1()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
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
        
        List <MYBZ_Region_Rollup__c> regionList = [SELECT Id, Region__r.Name, Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Region];
        if(!regionList.isEmpty())
        {
            for(MYBZ_Region_Rollup__c regionObj : regionList){
                if(!RegionNameAndGlobalIdMap.containsKey(regionObj.Region__r.Name)){
                    RegionNameAndGlobalIdMap.put(regionObj.Region__r.Name, regionObj.Global_Id__c);
                }
            }
        }
        
        List <MYBZ_Region_Rollup__c> districtList = [SELECT Id, Region__r.Name, District__r.Name, Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_District];
        
        if(!districtList.isEmpty()){
            for(MYBZ_Region_Rollup__c districtObj : districtList){
                if(!RegionNameAndDistrictMap.containsKey(districtObj.Region__r.Name)){
                    Set<String> districtNames = new Set<String>();
                    districtNames.add(districtObj.District__r.Name);
                    RegionNameAndDistrictMap.put(districtObj.Region__r.Name, districtNames);
                }
                else{
                    RegionNameAndDistrictMap.get(districtObj.Region__r.Name).add(districtObj.District__r.Name);
                }
                if(!DistrictNameAndGlobalIdMap.containsKey(districtObj.District__r.Name)){
                    DistrictNameAndGlobalIdMap.put(districtObj.District__r.Name, districtObj.Global_Id__c);
                }
            }
        }
        
        List <MYBZ_Region_Rollup__c> territoryList = [SELECT Id, Territory__r.Name, District__r.Name, Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Territory];
        
        if(!territoryList.isEmpty()){
            for(MYBZ_Region_Rollup__c territoryObj : territoryList){
                if(!DistrictNameAndTerritoryMap.containsKey(territoryObj.District__r.Name)){
                    Set<String> territoryNames = new Set<String>();
                    territoryNames.add(territoryObj.Territory__r.Name);
                    DistrictNameAndTerritoryMap.put(territoryObj.District__r.Name, territoryNames);
                }
                else{
                    DistrictNameAndTerritoryMap.get(territoryObj.District__r.Name).add(territoryObj.Territory__r.Name);
                }
                if(!TerritoryNameAndGlobalIdMap.containsKey(territoryObj.Territory__r.Name)){
                    TerritoryNameAndGlobalIdMap.put(territoryObj.Territory__r.Name, territoryObj.Global_Id__c);
                }
            }
        }
        if(!RegionNameAndGlobalIdMap.isEmpty() && !RegionNameAndDistrictMap.isEmpty() && !DistrictNameAndGlobalIdMap.isEmpty() && !DistrictNameAndTerritoryMap.isEmpty() && !TerritoryNameAndGlobalIdMap.isEmpty()){
            gen.writeStartArray();
            System.debug('Inside');
            for(String regionName : RegionNameAndGlobalIdMap.keySet()){
                gen.writeStartObject();
                gen.writeStringField(System.Label.MYBZ_Name,regionName);
                String regionGlobalId = RegionNameAndGlobalIdMap.get(regionName);
                gen.writeStringField(System.Label.MYBZ_globalID,regionGlobalId);
                
                if(RegionNameAndDistrictMap.containsKey(regionName)){
                    gen.writeFieldName(System.Label.MYBZ_children);
                    gen.writeStartArray();
                    
                    for(String districtName : RegionNameAndDistrictMap.get(regionName)){
                        gen.writeStartObject();
                        gen.writeStringField(System.Label.MYBZ_Name,districtName);
                        String districtGlobalId = DistrictNameAndGlobalIdMap.get(districtName);
                        gen.writeStringField(System.Label.MYBZ_globalID,districtGlobalId);
                        if(DistrictNameAndTerritoryMap.containsKey(districtName)){
                            gen.writeFieldName(System.Label.MYBZ_children);
                            gen.writeStartArray();
                            for(String territoryName : DistrictNameAndTerritoryMap.get(districtName)){
                                gen.writeStartObject();
                                gen.writeStringField(System.Label.MYBZ_Name,territoryName);
                                String territoryGlobalId = TerritoryNameAndGlobalIdMap.get(territoryName);
                                if(territoryGlobalId == null || territoryGlobalId == '')
                                    gen.writeNullField(System.Label.MYBZ_globalID); 
                                else
                                    gen.writeStringField(System.Label.MYBZ_globalID,territoryGlobalId);
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
    
    
    /* 
          * @Method Name                    :  TargetGoal
          * @Description                    :  JavaScript remoting to allow TargetGoal record associated with particular district to be retrieved from Salesforce in the form of a JSON object                                         
          * @Return Type                    :  object
          * @Param                          :   Region - The region associated to the territory selected, District - The district associated to the territory selected
                                               Territory - The territory selected via a territory picker.  
                                            
    */
    
    @RemoteAction 
    global static Object TargetGoal(String region, String district, String territory)
    {
        system.debug('district---'+district);
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        System.debug('****region'+region);
        System.debug('****district'+district);
        System.debug('****territory'+territory);
        
        String sdata;
        Object obj;
        
        JSONGenerator gen;
        List<MYBZ_Target_Goal__c> targetGoalList = new List<MYBZ_Target_Goal__c>();
        
        Set<Decimal> targetGoalYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>> YearAndMonthTargetGoalMap = new Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>>();
        system.debug('Role---'+Role);
       
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) && district != null && district != ''){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:district AND Territory__c = null   ORDER BY Month__c, Year__c ASC ];
        }
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) && territory != null && territory != ''){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Territory__r.Name =: territory ORDER BY Month__c, Year__c ASC ];
        }
        if(Role == System.Label.MYBZ_MajorMarketManager && district !=null && district !=''){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:district AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        if(Role == System.Label.MYBZ_SuperUser && district != null && district != ''){
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
                        gen.writeNumberField(System.Label.MYBZ_month,month);
                        gen.writeNumberField(System.Label.MYBZ_Year,year);
                        if(TempMonthAndTargetGoalMap.get(month) !=null){
                            gen.writeFieldName(System.Label.MYBZ_goals);
                            gen.writeStartArray();
                            for(MYBZ_Target_Goal__c targetGoalObj : TempMonthAndTargetGoalMap.get(month)){
                                gen.writeStartObject();
                                gen.writeStringField(System.Label.MYBZ_productName,targetGoalObj.Product__r.Name);
                                gen.writeNumberField(System.Label.MYBZ_goalSet,targetGoalObj.TRx_Goal__c);
                                gen.writeNumberField(System.Label.MYBZ_goalMet,targetGoalObj.TRx_Goal_Attainment__c);
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
    
    /* 
          * @Method Name                    :  TargetGoal
          * @Description                    :  JavaScript remoting to allow TargetGoal record associated with particular district to be retrieved from Salesforce in the form of a JSON object                                         
          * @Return Type                    :  object
          * @Param                          :   
                                            
    */
     @RemoteAction 
    global static Object TargetGoal1()
    {
        //system.debug('geographyDictionary---'+geographyDictionary);
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        
        String sdata;
        Object obj;
        
        JSONGenerator gen;
        List<MYBZ_Target_Goal__c> targetGoalList = new List<MYBZ_Target_Goal__c>();
        
        Set<Decimal> targetGoalYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>> YearAndMonthTargetGoalMap = new Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>>();
        system.debug('Role---'+Role);
        
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager)){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Global_Id__c =:GlobalId AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == System.Label.MYBZ_MajorMarketManager){
            targetGoalList.clear();
            MYBZ_Region_Rollup__c regionRollupObj = [SELECT Id, District__c FROM MYBZ_Region_Rollup__c WHERE Global_Id__c =:GlobalId LIMIT 1];
        
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__c =:regionRollupObj.District__c AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        else if(Role == System.Label.MYBZ_SalesRepresentative){
            targetGoalList.clear();
            targetGoalList = [SELECT Id, Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
            
        }
        else if(Role == System.Label.MYBZ_SuperUser){
            targetGoalList.clear();
            
            
            MYBZ_District__c districtObj = [SELECT Id FROM MYBZ_District__c LIMIT 1];
            
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
                        gen.writeNumberField(System.Label.MYBZ_month,month);
                        gen.writeNumberField(System.Label.MYBZ_Year,year);
                        if(TempMonthAndTargetGoalMap.get(month) !=null){
                            gen.writeFieldName(System.Label.MYBZ_goals);
                            gen.writeStartArray();
                            for(MYBZ_Target_Goal__c targetGoalObj : TempMonthAndTargetGoalMap.get(month)){
                                gen.writeStartObject();
                                gen.writeStringField(System.Label.MYBZ_productName,targetGoalObj.Product__r.Name);
                                gen.writeNumberField(System.Label.MYBZ_goalSet,targetGoalObj.TRx_Goal__c);
                                gen.writeNumberField(System.Label.MYBZ_goalMet,targetGoalObj.TRx_Goal_Attainment__c);
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
    
    
     /* 
          * @Method Name                    :  ProductTrends
          * @Description                    :  JavaScript remoting to allow Product Trends records for each month to be retrieved from Salesforce in the form of a JSON object 
                                               in the presence of a territory picker.                                      
          * @Return Type                    :  object
          * @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
                                               Territory - The territory selected via a territory picker.   
                                            
    */
    
    @RemoteAction 
    global static Object ProductTrends(String region, String district, String territory)
    {
       
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        Role = userObj.MYBZ_Role__c;
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        system.debug('GlobalId--'+GlobalId);
        
        System.debug('****region'+region);
        System.debug('****district'+district);
        System.debug('****territory'+territory);
        
        String sdata;
        Object obj;
         
        Decimal PercentageChangeTRx = 0;
        Decimal PercentageChangeDDDUnits = 0;
        Decimal PercentageChangeDDDDollars = 0;
        
        Decimal EffientTrx;
        Decimal EffientDollars;
        Decimal EffientUnits;
        
        //To determine if Effient product is present in the current month
        integer EffientFlag = 0;
        
        JSONGenerator gen;
        List<MYBZ_Market_Share__c> productTrendsList = new  List<MYBZ_Market_Share__c>();
        
        Set<Decimal> productTrendYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>> YearAndMonthProductTrendMap = new Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager || Role == System.Label.MYBZ_SuperUser) && district !=null && district !=''){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Market__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c,Previous_Month_TRx__c, DDD_Dollars__c,DDD_Units__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE District__r.Name =:district AND Territory__c = null AND Owner__c = :System.Label.MYBZ_LILLY AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && region !=null && region !='' && (district == null || district == '')){
            productTrendsList.clear();
           
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Market__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c,Previous_Month_TRx__c, DDD_Dollars__c,DDD_Units__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Region__r.Name =: region AND District__c = null AND Owner__c = :System.Label.MYBZ_LILLY AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  || Role == System.Label.MYBZ_SuperUser) && territory !=null && territory !=''){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Market__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c,Previous_Month_TRx__c, DDD_Dollars__c,DDD_Units__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:territory AND Owner__c = :System.Label.MYBZ_LILLY AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
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
                        EffientFlag=0;
                        gen.writeStartObject();
                        gen.writeNumberField(System.Label.MYBZ_month,month);
                        gen.writeNumberField(System.Label.MYBZ_Year,year);
                        if(TempMonthAndProductTrendMap.get(month) !=null){
                            gen.writeFieldName(System.Label.MYBZ_Products);
                            gen.writeStartArray();
                            for(MYBZ_Market_Share__c productTrendObj : TempMonthAndProductTrendMap.get(month)){
                            
                                if(!productTrendObj.Product__r.Name.Equals(System.Label.MYBZ_EFFIENT))
                                {
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_productName,productTrendObj.Product__r.Name);
                                    if(productTrendObj.TRx__c!=null)
                                    gen.writeNumberField(System.Label.MYBZ_trx,productTrendObj.TRx__c);
                                    else
                                    gen.writeNullField(System.Label.MYBZ_trx);
      
                                     if(productTrendObj.DDD_Dollars__c!=null)
                                     gen.writeNumberField(System.Label.MYBZ_dddDollars,productTrendObj.DDD_Dollars__c);
                                     else
                                     gen.writeNullField(System.Label.MYBZ_dddDollars);
                                     if(productTrendObj.DDD_Units__c!=null)
                                     gen.writeNumberField(System.Label.MYBZ_dddUnits,productTrendObj.DDD_Units__c);
                                     else
                                     gen.writeNullField(System.Label.MYBZ_dddUnits);
                                    if(productTrendObj.Previous_Month_TRx__c!=null)
                                        {
                                        if(productTrendObj.Previous_Month_TRx__c!=0)
                                            {
                                            PercentageChangeTRx = ((productTrendObj.TRx__c - productTrendObj.Previous_Month_TRx__c)/productTrendObj.Previous_Month_TRx__c);
                                            PercentageChangeTRx = PercentageChangeTRx.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else
                                            {
                                        PercentageChangeTRx=0;
                                            }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,PercentageChangeTRx);  
                                        }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx);
                                    
                                     if(productTrendObj.Previous_DDD_Dollars__c!=null)
                                    {
                                        if(productTrendObj.Previous_DDD_Dollars__c!=0)
                                        {
                                        PercentageChangeDDDDollars = ((productTrendObj.DDD_Dollars__c - productTrendObj.Previous_DDD_Dollars__c)/productTrendObj.Previous_DDD_Dollars__c);
                                        PercentageChangeDDDDollars = PercentageChangeDDDDollars.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDDollars=0;
                                        }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,PercentageChangeDDDDollars); 
                                    }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                                    
                                    if(productTrendObj.Previous_DDD_Units__c!=null)
                                    {
                                        if(productTrendObj.Previous_DDD_Units__c!=0)
                                        {
                                        PercentageChangeDDDUnits = ((productTrendObj.DDD_Units__c - productTrendObj.Previous_DDD_Units__c)/productTrendObj.Previous_DDD_Units__c);
                                        PercentageChangeDDDUnits = PercentageChangeDDDUnits.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDUnits=0;
                                        }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,PercentageChangeDDDUnits);   
                                    }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits); 
                                
                                //gen.writeNumberField('percentageChangeFromPreviousMonth',productTrendObj.percentageChangeFromPreviousMonth__c);
                                gen.writeBooleanField(System.Label.MYBZ_lillyProduct,productTrendObj.lillyProduct__c);
                                gen.writeEndObject();
                            }
                            else
                            {
                                if(EffientFlag==0)
                                EffientFlag = 1;
                                if(productTrendObj.TRx__c!=null)
                                {
                                EffientTrx=productTrendObj.TRx__c;
                                if(productTrendObj.Previous_Month_TRx__c!=null)
                                    {
                                        if(productTrendObj.Previous_Month_TRx__c!=0)
                                            {
                                            PercentageChangeTRx = ((productTrendObj.TRx__c - productTrendObj.Previous_Month_TRx__c)/productTrendObj.Previous_Month_TRx__c);
                                            PercentageChangeTRx = PercentageChangeTRx.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else
                                            {
                                        PercentageChangeTRx=0;
                                            }
                                          
                                    }
                                
                                }
                                if(productTrendObj.DDD_Dollars__c!=null)
                                {
                                EffientDollars=productTrendObj.DDD_Dollars__c;
                                if(productTrendObj.Previous_DDD_Dollars__c!=0)
                                        {
                                        PercentageChangeDDDDollars = ((productTrendObj.DDD_Dollars__c - productTrendObj.Previous_DDD_Dollars__c)/productTrendObj.Previous_DDD_Dollars__c);
                                        PercentageChangeDDDDollars = PercentageChangeDDDDollars.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDDollars=0;
                                        }
                                }
                                if(productTrendObj.DDD_Units__c!=null)
                                {
                                EffientUnits=productTrendObj.DDD_Units__c;
                                if(productTrendObj.Previous_DDD_Units__c!=0)
                                        {
                                        PercentageChangeDDDUnits = ((productTrendObj.DDD_Units__c - productTrendObj.Previous_DDD_Units__c)/productTrendObj.Previous_DDD_Units__c);
                                        PercentageChangeDDDUnits = PercentageChangeDDDUnits.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDUnits=0;
                                        }
                                }   
                            }
                              
                          }
                          if(EffientFlag==1)
                          {
                             gen.writeStartObject();
                             gen.writeStringField(System.Label.MYBZ_productName,System.Label.MYBZ_EFFIENT);
                             if(EffientTrx!=null)
                             gen.writeNumberField(System.Label.MYBZ_trx,EffientTrx);
                             else
                             gen.writeNullField(System.Label.MYBZ_trx);
                             if(EffientDollars!=null)
                             gen.writeNumberField(System.Label.MYBZ_dddDollars,EffientDollars);
                             else
                             gen.writeNullField(System.Label.MYBZ_dddDollars);
                             if(EffientUnits!=null)
                             gen.writeNumberField(System.Label.MYBZ_dddUnits,EffientUnits);
                             else
                             gen.writeNullField(System.Label.MYBZ_dddUnits);
                             if(PercentageChangeTRx!=null)
                             gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,PercentageChangeTRx);
                             else
                             gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx); 
                             if(PercentageChangeDDDDollars!=null)
                             gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,PercentageChangeDDDDollars); 
                             else
                             gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                             if(PercentageChangeDDDUnits!=null)
                             gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,PercentageChangeDDDUnits);
                             else
                             gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                             gen.writeBooleanField(System.Label.MYBZ_lillyProduct,true);
                             gen.writeEndObject();
                             EffientFlag=0;
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
    
     /* 
          * @Method Name                    :  ProductTrends1
          * @Description                    :  JavaScript remoting to allow Product Trends records for each month to be retrieved from Salesforce in the form of a JSON object 
                                               in the absence of a territory picker.                                           
          * @Return Type                    :  object
          * @Param                          :   
                                            
    */
    
    @RemoteAction 
    global static Object ProductTrends1()
    {
       
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        system.debug('GlobalId--'+GlobalId);
        
        String sdata;
        Object obj;
        
        Decimal PercentageChangeTRx = 0;
        Decimal PercentageChangeDDDUnits = 0;
        Decimal PercentageChangeDDDDollars = 0;
        
        Decimal EffientTrx;
        Decimal EffientDollars;
        Decimal EffientUnits;
        
        //To determine if Effient product is present in the current month
        integer EffientFlag = 0;
        
        JSONGenerator gen;
        List<MYBZ_Market_Share__c> productTrendsList = new  List<MYBZ_Market_Share__c>();
        
        Set<Decimal> productTrendYear = new Set<Decimal>();
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
        
        Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>> YearAndMonthProductTrendMap = new Map<Decimal, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        if(Role == System.Label.MYBZ_SalesRepresentative){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Market__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c,Previous_Month_TRx__c, DDD_Dollars__c,DDD_Units__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId AND Owner__c = :System.Label.MYBZ_LILLY AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC, Market__c];
        }
        if(Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager ){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId AND Owner__c = :System.Label.MYBZ_LILLY AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if(Role == System.Label.MYBZ_MajorMarketManager){
            productTrendsList.clear();
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId AND Owner__c = :System.Label.MYBZ_LILLY AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
        }
        if(Role == System.Label.MYBZ_SuperUser){
            productTrendsList.clear();
            
            MYBZ_Territory__c territoryObj = [SELECT Id FROM MYBZ_Territory__c LIMIT 1];
            
            productTrendsList = [SELECT Id, Global_ID__c, Region__c, District__c, Owner__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, percentageChangeFromPreviousMonth__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Territory__c =:territoryObj.Id AND Owner__c = :System.Label.MYBZ_LILLY AND lillyProduct__c = true ORDER BY Month__c, Year__c ASC];
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
                        EffientFlag=0;
                        gen.writeStartObject();
                        gen.writeNumberField(System.Label.MYBZ_month,month);
                        gen.writeNumberField(System.Label.MYBZ_Year,year);
                        if(TempMonthAndProductTrendMap.get(month) !=null){
                            gen.writeFieldName(System.Label.MYBZ_Products);
                            gen.writeStartArray();
                            for(MYBZ_Market_Share__c productTrendObj : TempMonthAndProductTrendMap.get(month)){
                                
                                system.debug('productTrendObj--'+productTrendObj.Product__r.Name);
                                if(!productTrendObj.Product__r.Name.Equals(System.Label.MYBZ_EFFIENT))
                                {
                                    gen.writeStartObject();
                                    gen.writeStringField(System.Label.MYBZ_productName,productTrendObj.Product__r.Name);
                                    if(productTrendObj.TRx__c!=null)
                                    gen.writeNumberField(System.Label.MYBZ_trx,productTrendObj.TRx__c);
                                    else
                                    gen.writeNullField(System.Label.MYBZ_trx);
      
                                     if(productTrendObj.DDD_Dollars__c!=null)
                                     gen.writeNumberField(System.Label.MYBZ_dddDollars,productTrendObj.DDD_Dollars__c);
                                     else
                                     gen.writeNullField(System.Label.MYBZ_dddDollars);
                                     if(productTrendObj.DDD_Units__c!=null)
                                     gen.writeNumberField(System.Label.MYBZ_dddUnits,productTrendObj.DDD_Units__c);
                                     else
                                     gen.writeNullField(System.Label.MYBZ_dddUnits);
                                    if(productTrendObj.Previous_Month_TRx__c!=null)
                                        {
                                        if(productTrendObj.Previous_Month_TRx__c!=0)
                                            {
                                            PercentageChangeTRx = ((productTrendObj.TRx__c - productTrendObj.Previous_Month_TRx__c)/productTrendObj.Previous_Month_TRx__c);
                                            PercentageChangeTRx = PercentageChangeTRx.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else
                                            {
                                        PercentageChangeTRx=0;
                                            }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,PercentageChangeTRx);  
                                        }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx);
                                    
                                     if(productTrendObj.Previous_DDD_Dollars__c!=null)
                                    {
                                        if(productTrendObj.Previous_DDD_Dollars__c!=0)
                                        {
                                        PercentageChangeDDDDollars = ((productTrendObj.DDD_Dollars__c - productTrendObj.Previous_DDD_Dollars__c)/productTrendObj.Previous_DDD_Dollars__c);
                                        PercentageChangeDDDDollars = PercentageChangeDDDDollars.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDDollars=0;
                                        }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,PercentageChangeDDDDollars); 
                                    }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                                    
                                    if(productTrendObj.Previous_DDD_Units__c!=null)
                                    {
                                        if(productTrendObj.Previous_DDD_Units__c!=0)
                                        {
                                        PercentageChangeDDDUnits = ((productTrendObj.DDD_Units__c - productTrendObj.Previous_DDD_Units__c)/productTrendObj.Previous_DDD_Units__c);
                                        PercentageChangeDDDUnits = PercentageChangeDDDUnits.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDUnits=0;
                                        }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,PercentageChangeDDDUnits);   
                                    }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits); 
                                
                                //gen.writeNumberField('percentageChangeFromPreviousMonth',productTrendObj.percentageChangeFromPreviousMonth__c);
                                gen.writeBooleanField(System.Label.MYBZ_lillyProduct,productTrendObj.lillyProduct__c);
                                gen.writeEndObject();
                            }
                            else
                            {
                                if(EffientFlag==0)
                                EffientFlag = 1;
                                if(productTrendObj.TRx__c!=null)
                                {
                                EffientTrx=productTrendObj.TRx__c;
                                if(productTrendObj.Previous_Month_TRx__c!=null)
                                    {
                                        if(productTrendObj.Previous_Month_TRx__c!=0)
                                            {
                                            PercentageChangeTRx = ((productTrendObj.TRx__c - productTrendObj.Previous_Month_TRx__c)/productTrendObj.Previous_Month_TRx__c);
                                            PercentageChangeTRx = PercentageChangeTRx.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else
                                            {
                                        PercentageChangeTRx=0;
                                            }
                                          
                                    }
                                
                                }
                                if(productTrendObj.DDD_Dollars__c!=null)
                                {
                                EffientDollars=productTrendObj.DDD_Dollars__c;
                                if(productTrendObj.Previous_DDD_Dollars__c!=0)
                                        {
                                        PercentageChangeDDDDollars = ((productTrendObj.DDD_Dollars__c - productTrendObj.Previous_DDD_Dollars__c)/productTrendObj.Previous_DDD_Dollars__c);
                                        PercentageChangeDDDDollars = PercentageChangeDDDDollars.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDDollars=0;
                                        }
                                }
                                if(productTrendObj.DDD_Units__c!=null)
                                {
                                EffientUnits=productTrendObj.DDD_Units__c;
                                if(productTrendObj.Previous_DDD_Units__c!=0)
                                        {
                                        PercentageChangeDDDUnits = ((productTrendObj.DDD_Units__c - productTrendObj.Previous_DDD_Units__c)/productTrendObj.Previous_DDD_Units__c);
                                        PercentageChangeDDDUnits = PercentageChangeDDDUnits.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                        PercentageChangeDDDUnits=0;
                                        }
                                }   
                            }
                              
                          }
                          if(EffientFlag==1)
                          {
                             gen.writeStartObject();
                             gen.writeStringField(System.Label.MYBZ_productName,System.Label.MYBZ_EFFIENT);
                             if(EffientTrx!=null)
                             gen.writeNumberField(System.Label.MYBZ_trx,EffientTrx);
                             else
                             gen.writeNullField(System.Label.MYBZ_trx);
                             if(EffientDollars!=null)
                             gen.writeNumberField(System.Label.MYBZ_dddDollars,EffientDollars);
                             else
                             gen.writeNullField(System.Label.MYBZ_dddDollars);
                             if(EffientUnits!=null)
                             gen.writeNumberField(System.Label.MYBZ_dddUnits,EffientUnits);
                             else
                             gen.writeNullField(System.Label.MYBZ_dddUnits);
                             if(PercentageChangeTRx!=null)
                             gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,PercentageChangeTRx);
                             else
                             gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx); 
                             if(PercentageChangeDDDDollars!=null)
                             gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,PercentageChangeDDDDollars); 
                             else
                             gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                             if(PercentageChangeDDDUnits!=null)
                             gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,PercentageChangeDDDUnits);
                             else
                             gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                             gen.writeBooleanField(System.Label.MYBZ_lillyProduct,true);
                             gen.writeEndObject();
                             EffientFlag=0;
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

    /* 
          * @Method Name                    :  MarketShare
          * @Description                    :  JavaScript remoting to allow MarketShare record of Lilly and Competitor  products to be retrieved from Salesforce in the form of a JSON object in the presence of a territory picker.                                         
          * @Return Type                    :  object
          * @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
                                               Territory - The territory selected via a territory picker.   
                                            
    */
   
    @RemoteAction 
    global static Object MarketShare(String region, String district, String territory)
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        System.debug('****region'+region);
        System.debug('****district'+district);
        System.debug('****territory'+territory);
        
        String sdata;
        Object obj;
        JSONGenerator gen;
        
        Map<String, Set<Decimal>> MarketShareNameAndYearMap = new Map<String, Set<Decimal>>();
        Map<String, Map<Decimal, Set<Decimal>>>MarketShareNameAndYearMonthMap = new Map<String, Map<Decimal, Set<Decimal>>>();
        
        
        
        Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>> MarketShareNameAndMarketShareMap = new Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        List<MYBZ_Market_Share__c> marketShareList = new List<MYBZ_Market_Share__c>();
        if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  || Role == System.Label.MYBZ_SuperUser) && district !=null && district !=''){
            marketShareList.clear();
           
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE District__r.Name =:district AND Territory__c = null ORDER BY Month__c, Year__c ASC];
        }
        if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && region !=null && region !='' && (district == null || district == '')){
            marketShareList.clear();
            
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Region__r.Name =: region AND District__c = null ORDER BY Month__c, Year__c ASC];
        }
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  || Role == System.Label.MYBZ_SuperUser) && territory !=null && territory !=''){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:territory ORDER BY Month__c, Year__c ASC];
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
                gen.writeStringField(System.Label.MYBZ_market,marketShareName);
                if(MarketShareNameAndMarketShareMap.get(marketShareName) !=null){
                    Map<Decimal, List<MYBZ_Market_Share__c>> YearAndMarketMap = MarketShareNameAndMarketShareMap.get(marketShareName);
                    gen.writeFieldName(System.Label.MYBZ_data);
                    gen.writeStartArray();
                    for(Decimal Year : YearAndMarketMap.KeySet()){
                        Set<Decimal>MonthsSet = YearAndMonthMap.get(Year);
                        List<MYBZ_Market_Share__c> marketList =  YearAndMarketMap.get(Year);
                        System.debug('marketList---'+marketList);
                        for(Decimal Month : MonthsSet){
                            gen.writeStartObject();
                            gen.writeNumberField(System.Label.MYBZ_month,Month);
                            gen.writeNumberField(System.Label.MYBZ_Year,Year);
                            if(!marketList.isEmpty()){
                                gen.writeFieldName(System.Label.MYBZ_Products);
                                gen.writeStartArray();
                                for(MYBZ_Market_Share__c marketShareObj : marketList){
                                    Decimal percentageChangeSinceLastMonth;
                                    if(marketShareObj.Market__c == marketShareName && marketShareObj.Year__c == Year && marketShareObj.Month__c == Month){
                                        gen.writeStartObject();
                                        if(marketShareObj.TRx__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_trx,marketShareObj.TRx__c);
                                        else
                                        gen.writeNullField(System.Label.MYBZ_trx);
                                        if(marketShareObj.Previous_Month_TRx__c!=null){
                                            if(marketShareObj.Previous_Month_TRx__c !=0){
                                                //gen.writeNumberField(System.Label.MYBZ_trx,marketShareObj.TRx__c);
                                                percentageChangeSinceLastMonth = ((marketShareObj.TRx__c - marketShareObj.Previous_Month_TRx__c) / marketShareObj.Previous_Month_TRx__c);
                                                percentageChangeSinceLastMonth = percentageChangeSinceLastMonth.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else{
                                                percentageChangeSinceLastMonth = 0;
                                                }
                                                gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,percentageChangeSinceLastMonth);
                                        }
                                        else
                                        gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx);
                                        gen.writeStringField(System.Label.MYBZ_productName,marketShareObj.Product__r.Name);
                                        gen.writeBooleanField(System.Label.MYBZ_lillyProduct,marketShareObj.lillyProduct__c);
                                        if(marketShareObj.DDD_Dollars__c!=null)
                                            gen.writeNumberField(System.Label.MYBZ_dddDollars,marketShareObj.DDD_Dollars__c);
                                        else
                                            gen.writeNullField(System.Label.MYBZ_dddDollars);
                                            
                                        if(marketShareObj.DDD_Units__c!=null)
                                            gen.writeNumberField(System.Label.MYBZ_dddUnits,marketShareObj.DDD_Units__c);
                                        else
                                            gen.writeNullField(System.Label.MYBZ_dddUnits);
                                            Decimal PercentageChangeDDDDollars;
                                        if(marketShareObj.Previous_DDD_Dollars__c!=null)
                                        {
                                            if(marketShareObj.Previous_DDD_Dollars__c!=0)
                                            {
                                            PercentageChangeDDDDollars = ((marketShareObj.DDD_Dollars__c - marketShareObj.Previous_DDD_Dollars__c)/marketShareObj.Previous_DDD_Dollars__c);
                                            PercentageChangeDDDDollars = PercentageChangeDDDDollars.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else
                                            {
                                                PercentageChangeDDDDollars=0;
                                            }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,PercentageChangeDDDDollars); 
                                        }
                                    else
                                        gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                                    Decimal PercentageChangeDDDUnits;
                                    if(marketShareObj.Previous_DDD_Units__c!=null)
                                    {
                                        if(marketShareObj.Previous_DDD_Units__c!=0)
                                        {
                                            PercentageChangeDDDUnits = ((marketShareObj.DDD_Units__c - marketShareObj.Previous_DDD_Units__c)/marketShareObj.Previous_DDD_Units__c);
                                            PercentageChangeDDDUnits = PercentageChangeDDDUnits.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                            PercentageChangeDDDUnits=0;
                                        }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,PercentageChangeDDDUnits);   
                                    }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                                    
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
    
    /* 
          * @Method Name                    :  MarketShare
          * @Description                    :  JavaScript remoting to allow MarketShare record of Lilly and Competitor  products to be retrieved from Salesforce in the form of a JSON object based on Global id 
          * @Return Type                    :  object
          * @Param                          :  
                                            
    */
    
     @RemoteAction 
    global static Object MarketShare1()
    {
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        
        String sdata;
        Object obj;
        JSONGenerator gen;
        
        Map<String, Set<Decimal>> MarketShareNameAndYearMap = new Map<String, Set<Decimal>>();
        Map<String, Map<Decimal, Set<Decimal>>>MarketShareNameAndYearMonthMap = new Map<String, Map<Decimal, Set<Decimal>>>();
        
        
        
        Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>> MarketShareNameAndMarketShareMap = new Map<String, Map<Decimal, List<MYBZ_Market_Share__c>>>();
        
        List<MYBZ_Market_Share__c> marketShareList = new List<MYBZ_Market_Share__c>();
         if(Role == System.Label.MYBZ_SalesRepresentative){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        if(Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager ){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        if(Role == System.Label.MYBZ_MajorMarketManager){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
        }
        if(Role == System.Label.MYBZ_SuperUser){
            marketShareList.clear();
            MYBZ_Territory__c territoryObj = [SELECT Id FROM MYBZ_Territory__c LIMIT 1];
            
            marketShareList = [SELECT Id, Region__c, District__c, Global_Id__c, Owner__c, Market__c, lillyProduct__c, Month__c, Year__c, Product__r.Name, TRx__c, Previous_Month_TRx__c, DDD_Units__c,DDD_Dollars__c,Previous_DDD_Dollars__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c WHERE Territory__c =:territoryObj.Id ORDER BY Month__c, Year__c ASC];
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
                gen.writeStringField(System.Label.MYBZ_market,marketShareName);
                if(MarketShareNameAndMarketShareMap.get(marketShareName) !=null){
                    Map<Decimal, List<MYBZ_Market_Share__c>> YearAndMarketMap = MarketShareNameAndMarketShareMap.get(marketShareName);
                    gen.writeFieldName(System.Label.MYBZ_data);
                    gen.writeStartArray();
                    for(Decimal Year : YearAndMarketMap.KeySet()){
                        Set<Decimal>MonthsSet = YearAndMonthMap.get(Year);
                        List<MYBZ_Market_Share__c> marketList =  YearAndMarketMap.get(Year);
                        System.debug('marketList---'+marketList);
                        for(Decimal Month : MonthsSet){
                            gen.writeStartObject();
                            gen.writeNumberField(System.Label.MYBZ_month,Month);
                            gen.writeNumberField(System.Label.MYBZ_Year,Year);
                            if(!marketList.isEmpty()){
                                gen.writeFieldName(System.Label.MYBZ_Products);
                                gen.writeStartArray();
                                for(MYBZ_Market_Share__c marketShareObj : marketList){
                                    Decimal percentageChangeSinceLastMonth;
                                    if(marketShareObj.Market__c == marketShareName && marketShareObj.Year__c == Year && marketShareObj.Month__c == Month){
                                        gen.writeStartObject();
                                        if(marketShareObj.TRx__c !=null)
                                        gen.writeNumberField(System.Label.MYBZ_trx,marketShareObj.TRx__c);
                                        else
                                        gen.writeNullField(System.Label.MYBZ_trx);
                                        if(marketShareObj.Previous_Month_TRx__c!=null){
                                            if(marketShareObj.Previous_Month_TRx__c !=0){
                                                //gen.writeNumberField(System.Label.MYBZ_trx,marketShareObj.TRx__c);
                                                percentageChangeSinceLastMonth = ((marketShareObj.TRx__c - marketShareObj.Previous_Month_TRx__c) / marketShareObj.Previous_Month_TRx__c);
                                                percentageChangeSinceLastMonth = percentageChangeSinceLastMonth.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else{
                                                percentageChangeSinceLastMonth = 0;
                                                }
                                                gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,percentageChangeSinceLastMonth);
                                        }
                                        else
                                        gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx);
                                        gen.writeStringField(System.Label.MYBZ_productName,marketShareObj.Product__r.Name);
                                        gen.writeBooleanField(System.Label.MYBZ_lillyProduct,marketShareObj.lillyProduct__c);
                                        if(marketShareObj.DDD_Dollars__c!=null)
                                            gen.writeNumberField(System.Label.MYBZ_dddDollars,marketShareObj.DDD_Dollars__c);
                                        else
                                            gen.writeNullField(System.Label.MYBZ_dddDollars);
                                            
                                        if(marketShareObj.DDD_Units__c!=null)
                                            gen.writeNumberField(System.Label.MYBZ_dddUnits,marketShareObj.DDD_Units__c);
                                        else
                                            gen.writeNullField(System.Label.MYBZ_dddUnits);
                                            Decimal PercentageChangeDDDDollars;
                                        if(marketShareObj.Previous_DDD_Dollars__c!=null)
                                        {
                                            if(marketShareObj.Previous_DDD_Dollars__c!=0)
                                            {
                                            PercentageChangeDDDDollars = ((marketShareObj.DDD_Dollars__c - marketShareObj.Previous_DDD_Dollars__c)/marketShareObj.Previous_DDD_Dollars__c);
                                            PercentageChangeDDDDollars = PercentageChangeDDDDollars.SetScale(2,RoundingMode.CEILING);
                                            }
                                            else
                                            {
                                                PercentageChangeDDDDollars=0;
                                            }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,PercentageChangeDDDDollars); 
                                        }
                                    else
                                        gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                                    Decimal PercentageChangeDDDUnits;
                                    if(marketShareObj.Previous_DDD_Units__c!=null)
                                    {
                                        if(marketShareObj.Previous_DDD_Units__c!=0)
                                        {
                                            PercentageChangeDDDUnits = ((marketShareObj.DDD_Units__c - marketShareObj.Previous_DDD_Units__c)/marketShareObj.Previous_DDD_Units__c);
                                            PercentageChangeDDDUnits = PercentageChangeDDDUnits.SetScale(2,RoundingMode.CEILING);
                                        }
                                        else
                                        {
                                            PercentageChangeDDDUnits=0;
                                        }
                                        gen.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,PercentageChangeDDDUnits);   
                                    }
                                    else
                                    gen.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                                    
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
   
     /* 
          * @Method Name                    :  TrendsPrescriber1
          * @Description                    :  JavaScript remoting to allow top five prescribers for each month associated to a certain product to be  
                                               retrieved from Salesforce in the form of a JSON object in the absence of a territory picker. 
          * @Return Type                    :  object
          * @Param                          :  
                                            
    */
    
    
    @RemoteAction 
    global static Object TrendsPrescriber1()
    {
        
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        List<MYBZ_Product_Trend_Detail__c> TrendsDetailsList = new List<MYBZ_Product_Trend_Detail__c>();
        String sdata;
        Object obj;
        
        if(Role == System.Label.MYBZ_SalesRepresentative || (Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) || Role == System.Label.MYBZ_MajorMarketManager){
            TrendsDetailsList.clear();
           //List of all trend-details for a particular user
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Global_ID__c=:GlobalId order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if(Role == System.Label.MYBZ_SuperUser){
            TrendsDetailsList.clear();
            
            MYBZ_Territory__c territoryObj = [SELECT Id FROM MYBZ_Territory__c LIMIT 1];
            
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Territory__c =:territoryObj.Id order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        
          if(TrendsDetailsList.isempty())
        {
        return null;
        }
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();  
        String Years='';
        String Months;
        String Products='';
        Integer productprescribercount;
        Integer firstiteration=1;
    
    //Looping over Trend-Details
    if(TrendsDetailsList != null && TrendsDetailsList.size() > 0){
        for(MYBZ_Product_Trend_Detail__c trenddetails : TrendsDetailsList)
            {
                if(trenddetails.Year__c==null||trenddetails.Month__c==null)
                continue;
               if(trenddetails.Year__c!=null)
               {
                if(!Years.contains(String.Valueof(trenddetails.Year__c)))
                {
                    Years+=trenddetails.Year__c;
                    Months = '';
                }
               }
               if(trenddetails.Month__c!=null)
               {
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
                    
                    if(trenddetails.Month__c!=null)
                    gen.writeNumberField(System.Label.MYBZ_month,trenddetails.Month__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_month);
                    //sdata+='"month":'+ month + ',';
                    if(trenddetails.Year__c!=null)
                    gen.writeNumberField(System.Label.MYBZ_Year,trenddetails.Year__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_Year);
                    gen.writeFieldName(System.Label.MYBZ_Products);
                    gen.writeStartArray();      
                }
               } 
                if(trenddetails.IHS_Product__r.Name!=null)
                {
                if(!Products.equals(trenddetails.IHS_Product__r.Name))
                    {
                    Products=trenddetails.IHS_Product__r.Name;
                    gen.writeStartObject();
                    if(trenddetails.IHS_Product__r.Name!=null)
                    gen.writeStringField(System.Label.MYBZ_product,trenddetails.IHS_Product__r.Name);
                    else
                    gen.writeNullField(System.Label.MYBZ_product);
                    gen.writeFieldName(System.Label.MYBZ_topFivePrescribers);
                    gen.writeStartArray();
                    productprescribercount=1;
                    }
                }
                if(productprescribercount<=5)
                {
                    gen.writeStartObject();
                    if(trenddetails.HCP_First_Name__c!=null)
                    gen.writeStringField(System.Label.MYBZ_prescriberFirstName,trenddetails.HCP_First_Name__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_prescriberFirstName);
                    if(trenddetails.HCP_Last_Name__c!=null)
                    gen.writeStringField(System.Label.MYBZ_prescriberLastName,trenddetails.HCP_Last_Name__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_prescriberLastName);
                    if(trenddetails.TRx_Units__c!=null)
                    gen.writeNumberField(System.Label.MYBZ_trx,trenddetails.TRx_Units__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_trx);
                    gen.writeEndObject();
                 
                    if(productprescribercount==5)
                    {
                    gen.writeEndArray();
                    gen.writeEndObject();
                    }
                    
                    productprescribercount++;
                    
                }
                                
           }
       }
       gen.writeEndArray();  
       sdata = gen.getAsString();
       sdata=sdata.replaceall('\n','');
       System.Debug('--TrendsPrescribers' + sdata);
        obj = Json.deserializeUntyped(sdata); 
        return obj;
    }
    
     /* 
          * @Method Name                    :  TrendsPrescriber
          * @Description                    :  JavaScript remoting to allow top five prescribers for each month associated to a certain product to be  
                                               retrieved from Salesforce in the form of a JSON object in the presence of a territory picker. 
          * @Return Type                    :  object
          * @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
                                               Territory - The territory selected via a territory picker.   
                                            
    */
    
        @RemoteAction 
    global static Object TrendsPrescriber(String region, String district, String territory)
    {
        
        UserId = UserInfo.getUserId();
        User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        Role = userObj.MYBZ_Role__c;
        if(Role==System.Label.MYBZ_AccountManager)
        GlobalId=userObj.MYBZ_Reporting_ID__c;
        else
        GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        String sdata;
        Object obj;
        List<MYBZ_Product_Trend_Detail__c> TrendsDetailsList = new List<MYBZ_Product_Trend_Detail__c>();
        
        if((Role == System.Label.MYBZ_MajorMarketManager || (Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) || Role == System.Label.MYBZ_SuperUser) && district !=null && district !=''){
            TrendsDetailsList.clear();
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where District__r.Name =:district AND Territory__c = null order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && region !=null && region !='' && (district ==null || district =='')){
            TrendsDetailsList.clear();
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where Area__r.Name =:region AND District__c = null order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager || Role == System.Label.MYBZ_SuperUser) && territory !=null && territory !=''){
            TrendsDetailsList.clear();
            TrendsDetailsList = [Select Name,Month__c,Year__c,IHS_Product__c,Range__c,IHS_Product__r.Name,TRx_Units__c,Global_ID__c,HCP_First_Name__c,HCP_Last_Name__c from MYBZ_Product_Trend_Detail__c where territory__r.Name =:territory order by Year__c,Month__c asc, IHS_Product__r.Name desc, TRx_Units__c desc];
        }
        if(TrendsDetailsList.isempty())
        {
        return null;
        }
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartArray();  
        String Years='';
        String Months;
        String Products='';
        Integer productprescribercount;
        Integer firstiteration=1;
    
         //Looping over Trend-Details
        if(TrendsDetailsList != null && TrendsDetailsList.size() > 0){
        for(MYBZ_Product_Trend_Detail__c trenddetails : TrendsDetailsList)
            {
                if(trenddetails.Year__c==null||trenddetails.Month__c==null)
                continue;
               if(trenddetails.Year__c!=null)
               {
                if(!Years.contains(String.Valueof(trenddetails.Year__c)))
                {
                    Years+=trenddetails.Year__c;
                    Months = '';
                }
               }
               if(trenddetails.Month__c!=null)
               {
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
                    
                    if(trenddetails.Month__c!=null)
                    gen.writeNumberField(System.Label.MYBZ_month,trenddetails.Month__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_month);
                    //sdata+='"month":'+ month + ',';
                    if(trenddetails.Year__c!=null)
                    gen.writeNumberField(System.Label.MYBZ_Year,trenddetails.Year__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_Year);
                    gen.writeFieldName(System.Label.MYBZ_Products);
                    gen.writeStartArray();      
                }
               } 
                if(trenddetails.IHS_Product__r.Name!=null)
                {
                if(!Products.equals(trenddetails.IHS_Product__r.Name))
                    {
                    Products=trenddetails.IHS_Product__r.Name;
                    gen.writeStartObject();
                    if(trenddetails.IHS_Product__r.Name!=null)
                    gen.writeStringField(System.Label.MYBZ_product,trenddetails.IHS_Product__r.Name);
                    else
                    gen.writeNullField(System.Label.MYBZ_product);
                    gen.writeFieldName(System.Label.MYBZ_topFivePrescribers);
                    gen.writeStartArray();
                    productprescribercount=1;
                    }
                }
                if(productprescribercount<=5)
                {
                    gen.writeStartObject();
                    if(trenddetails.HCP_First_Name__c!=null)
                    gen.writeStringField(System.Label.MYBZ_prescriberFirstName,trenddetails.HCP_First_Name__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_prescriberFirstName);
                    if(trenddetails.HCP_Last_Name__c!=null)
                    gen.writeStringField(System.Label.MYBZ_prescriberLastName,trenddetails.HCP_Last_Name__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_prescriberLastName);
                    if(trenddetails.TRx_Units__c!=null)
                    gen.writeNumberField(System.Label.MYBZ_trx,trenddetails.TRx_Units__c);
                    else
                    gen.writeNullField(System.Label.MYBZ_trx);
                    gen.writeEndObject();
                 
                    if(productprescribercount==5)
                    {
                    gen.writeEndArray();
                    gen.writeEndObject();
                    }
                    
                    productprescribercount++;
                    
                }
                                
           }
       }
       gen.writeEndArray();  
       sdata = gen.getAsString();
       sdata=sdata.replaceall('\n','');
       System.Debug('--TrendsPrescribers' + sdata);
        obj = Json.deserializeUntyped(sdata); 
        return obj;
    }
    
    
     /* 
          * @Method Name                    :  callPlanning
          * @Description                    :  JavaScript remoting to allow Call Planning record for each prescriber as well as calls associated to the same prescriber
                                               to be retrieved from Salesforce in the form of a JSON object in the presence of a territory picker.                                         
          * @Return Type                    :  object
          * @Param                          :  Region - The region associated to the territory selected, District - The district associated to the territory selected
                                               Territory - The territory selected via a territory picker.   
                                            
    */
    
     @RemoteAction  
  global static Object callPlanning(String region, String district, String territory){       
     
     UserId = UserInfo.getUserId();
     User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
     Role = userObj.MYBZ_Role__c;
     if(Role==System.Label.MYBZ_AccountManager)
     GlobalId=userObj.MYBZ_Reporting_ID__c;
     else
     GlobalId = userObj.Prsnl_Nbr_GLBL__c;
     List<MYBZ_CallPlanningProductJunction__c> CallPlanningsList = new List<MYBZ_CallPlanningProductJunction__c>();
     List<MYBZ_Call__c> CallsList = new List<MYBZ_Call__c>();
     if(Role == System.Label.MYBZ_SalesRepresentative){
        CallPlanningsList.clear();
        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:GlobalId order by Call_Planning__r.Physician_ID__c,Product__r.Name];
        CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c, Product__c,Product__r.Name from MYBZ_Call__c where Global_ID__c=:GlobalId order by Physician_ID__c,Call_Date__c desc,Product_Position__c asc ];
    }
    if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  || Role == System.Label.MYBZ_SuperUser) && territory != null && territory !=''){
        CallPlanningsList.clear();
        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Call_Planning__r.Territory__r.Name, Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c,Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Territory__r.Name=:territory order by Call_Planning__r.Physician_ID__c,Product__r.Name];
        CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c, Product__c,Product__r.Name,Territory__c,Territory__r.Name from MYBZ_Call__c where Territory__r.Name=:territory order by Physician_ID__c,Call_Date__c desc,Product_Position__c asc ];
        }
    if(Role == System.Label.MYBZ_MajorMarketManager){
        CallPlanningsList.clear();
        MYBZ_Region_Rollup__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Territory LIMIT 1];
        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:territoryObj.Global_Id__c order by Call_Planning__r.Physician_ID__c,Product__r.Name];
    }
    
       if(CallPlanningsList.isempty())
    {
        return null;
    }
    
    //Initialization of variables
    
    //Used to track percentage change values over different ranges.
    Decimal percentageChangePastMonth = 0;
    Decimal percentageChangePastThreeMonths = 0;
    Decimal percentageChangePastSixMonths = 0;
    
    //Tracks if a new physician is found while iterating over call planning records.
    
    //Integer newuserflag=1;
    
    //Tracks if the current record is the first physician record or not.
    Integer firstuserflag=1;
    
    //Tracks if the product has been encountered for the first time for a new physician.
    Integer firstproduct=1;
    
    //Tracks if a new product is encountered for the current physician.
    Integer newproduct=1;
    
    //Tracks the first call record.
    Integer firstCall=1;
    
    //Tracks the call count related to each physician.
    Integer usercallcount=0;
    
    //Initializing PhysicianID as blank. This variable is used to keep track of the PhysicianID as we iterate over call planning and call records.
    String PhysicianID ='';
    
    //String CallID='';
    
    //Initializing CurrentProduct as blank for each new physician.
    String CurrentProduct='';
    
    //Initializing currentCallID as blank. This variable is used to keep track of call IDs as we iterate over the call records.
    String currentCallID='';
    
    //Used to store created JSON in string format
    String sdata ='';
    
    //Tracks if a new call record is encountered.
    Integer newCallID=0;
    
    //Keeps track of the number of call records for each new CallID.
    Integer callsProductNumber = 1;
    
    //Temporary variable to allow us to restore the call count in case end of the call records list is reached. 
    Integer InitialCallCount=0;
    
    //Keeps track of the calls count while iterating over the call records.
    Integer CallsCount=0;
    
    //Returns a new JSON generator.
    JSONGenerator gen = JSON.createGenerator(true);
    
    
    
    //Writes the starting marker of a JSON Object.
    gen.writeStartObject();  
    if(CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c!=null)
    gen.writeStringField('startDate1Month',CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c.format(System.Label.MYBZ_DateFormat));
    else
    gen.writeNullField('startDate1Month');
    if(CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c!=null)
    gen.writeStringField('startDate3Month',CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c.format(System.Label.MYBZ_DateFormat));
    else
    gen.writeNullField('startDate3Month');
    if(CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c!=null)
    gen.writeStringField('startDate6Month',CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c.format(System.Label.MYBZ_DateFormat));
    else
    gen.writeNullField('startDate6Month');
    gen.writeFieldName('data');    
    
    gen.writeStartArray();
    
    //Loop to iterate over all call planning records.
    for(Integer CallPlanningCount=0;CallPlanningCount<CallPlanningsList.size();CallPlanningCount++)
    {
        
        //Determine if a new physician is encountered.
        if(!PhysicianID.equals(CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c))
        {
           
           //Indicates a new physician has been found       
           //newuserflag = 1;
           
           //Initializing currentCallID as blank for each new physician
           currentCallID ='';
           
           //Initializing CurrentProduct as blank for each new physician  
           CurrentProduct='';
           
           PhysicianID=CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c;
           
           //If a new physician record is encountered, start the object else, end the previous object first.
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
           
           //Write the necessary JSON fields
           
          if(CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c!=null)
           gen.writeStringField(System.Label.MYBZ_FirstName,CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c);
           else
           gen.writeNullField(System.Label.MYBZ_FirstName);
           if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c!=null)
           gen.writeStringField(System.Label.MYBZ_LastName,CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c);
           else
           gen.writeNullField(System.Label.MYBZ_LastName);
           if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c!=null)
           gen.writeStringField(System.Label.MYBZ_Tier,String.ValueOf(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c));
           else
           gen.writeNullField(System.Label.MYBZ_Tier);
           gen.writeFieldName(System.Label.MYBZ_Products);
           gen.writeStartArray();
           
           firstproduct = 1;
        }   
                
        //PRODUCTS
        //To check if a new product has been encountered for the current physician
                
        if(CallPlanningsList[CallPlanningCount].Product__c!=null)
        {
            if(!CurrentProduct.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
            {
                newproduct=1;
                percentageChangePastMonth=0;
                percentageChangePastThreeMonths=0;
                percentageChangePastSixMonths=0;
                CurrentProduct = CallPlanningsList[CallPlanningCount].Product__r.Name;
            
                //Determines if the product has been encountered for the first time for the current physician
            
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
        }
        else
        {
          newproduct=1;
          percentageChangePastMonth=0;
          percentageChangePastThreeMonths=0;
          percentageChangePastSixMonths=0;
          CurrentProduct =''; 
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
        
        if(newproduct==1)
        {
          if(CallPlanningsList[CallPlanningCount].Product__r.Name!=null)
          gen.writeStringField(System.Label.MYBZ_Name,CallPlanningsList[CallPlanningCount].Product__r.Name);
          else
          gen.writeNullField(System.Label.MYBZ_Name);
        }
        
        //Adding TRx values to the JSON if they are not null.
        
        if(CallPlanningsList[CallPlanningCount].TRx_Units_1M__c!=null)
        gen.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastMonth,CallPlanningsList[CallPlanningCount].TRx_Units_1M__c);
        else
        gen.writeNullField(System.Label.MYBZ_ScriptsWrittenPastMonth);
        if(CallPlanningsList[CallPlanningCount].TRx_Units_3M__c!=null)
        gen.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths,CallPlanningsList[CallPlanningCount].TRx_Units_3M__c);
        else
        gen.writeNullField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths);
        if(CallPlanningsList[CallPlanningCount].TRx_Units_6M__c!=null)
        gen.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastSixMonths,CallPlanningsList[CallPlanningCount].TRx_Units_6M__c);
        else
        gen.writeNullField(System.Label.MYBZ_ScriptsWrittenPastSixMonths);
        
        if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=null)
        {
          if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=0)
          {
          percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units_1M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)*100;
          percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
          }
          else
          {
            percentageChangePastMonth=0;
          }
          gen.writeNumberField(System.Label.MYBZ_PercentageChangePastMonth,percentageChangePastMonth);
        }
        else
        gen.writeNullField(System.Label.MYBZ_PercentageChangePastMonth);
        
        if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=null)
        {
          if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=0)
          {
          percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_3M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)*100;
          percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
          }
          else
          {
            percentageChangePastThreeMonths=0;
          }
          gen.writeNumberField(System.Label.MYBZ_PercentageChangePastThreeMonths,percentageChangePastThreeMonths);
        }
        else
        gen.writeNullField(System.Label.MYBZ_PercentageChangePastThreeMonths);  
        
        if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=null)
        {
          if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=0)
          {
          percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_6M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)*100;
          percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
          }
          else
          {
            percentageChangePastSixMonths=0;
          }
          gen.writeNumberField(System.Label.MYBZ_PercentageChangePastSixMonths,percentageChangePastSixMonths);
        }
        else
        gen.writeNullField(System.Label.MYBZ_PercentageChangePastSixMonths);           
        if((CallPlanningCount+1 == CallPlanningsList.size() )||(!PhysicianID.equals(CallPlanningsList[CallPlanningCount+1].Call_Planning__r.Physician_ID__c)))
        {
        gen.writeEndObject();
        gen.writeEndArray();
        
        InitialCallCount=CallsCount;
        
        //If the current call record does not correspond to the current call planning record, go to the next call record. If end of the calls list is reached, restore the callscount.
        
        if(CallsCount<CallsList.Size()&&(!PhysicianID.equals(CallsList[CallsCount].Physician_ID__c)))
                {
                    for(integer a=CallsCount;a<CallsList.Size();a++)
                    {
                        if(!PhysicianID.equals(CallsList[CallsCount].Physician_ID__c))
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
        
        //If the current call record corresponds to the current call planning record, write the required JSON fields.
        
        if(CallsCount<CallsList.Size()&&(PhysicianID.equals(CallsList[CallsCount].Physician_ID__c)))
                {               
                gen.writeFieldName(System.Label.MYBZ_Calls);
                gen.writeStartArray();
                firstCall=1;
                usercallcount=0;
                for(integer i = CallsCount; i<CallsList.Size(); i++)
                {
                    CallsCount = i;
                    
                    //If the call count for a particular physician exceeds five, break out of the loop since only five most recent calls information needs to be passed.
                    if(usercallcount==5)
                    {
                        gen.writeEndObject();
                        gen.writeEndArray();
                        break;
                    }
                    
                    usercallcount++;
                    
                    //Check if the current call record correspond to the current call planning record
                    if(PhysicianID.equals(CallsList[i].Physician_ID__c))
                    {
                         //Check if the current record encountered corresponds to the same call as the previous.
                         if(!currentCallID.equals(CallsList[i].Call_ID__c))
                        {
                            newCallID=1;
                            currentCallID= CallsList[i].Call_ID__c;
                        }
                        else
                        {
                            newCallID=0;
                        }
                        
                        
                        if( newCallID==1 && usercallcount<6)
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
                            
                            //Write the required JSON fields for the new call encountered.
                            if(CallsList[i].Call_Date__c!=null)
                            gen.writeStringField(System.Label.MYBZ_Date,CallsList[i].Call_Date__c.format(System.Label.MYBZ_DateFormat));   
                            else
                            gen.writeNullField(System.Label.MYBZ_Date);
                            if(CallsList[i].Call_Type__c!=null)
                            gen.writeStringField(System.Label.MYBZ_Type,CallsList[i].Call_Type__c);
                            else
                            gen.writeNullField(System.Label.MYBZ_Type);
                        }
                        else
                        {
                            callsProductNumber+=1;
                            //if(callsProductNumber==2)
                       }
                        
                        //Information       
                        if(CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly))
                        {
                            if(callsProductNumber==2)
                            {
                                if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL))
                                {
                                    gen.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                    usercallcount--;
                                }
                            }
                            else
                            {
                                if((CallsList[i].Product__c!=NULL))
                                {
                                gen.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        
                        
                        if((callsProductNumber<=2)&&(!CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly)))
                        {
                            
                            if(callsProductNumber==2)
                            {
                                
                                if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL)&&(CallsList[i].Product_Position__c==2))
                                {
                                    gen.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                    usercallcount--;
                                }
                            }
                            else
                            {
                               
                             if((CallsList[i].Product__c!=NULL)&&CallsList[i].Product_Position__c==1)
                                {
                                 gen.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        if((i+1 == CallsList.size() )||(!PhysicianID.equals(CallsList[i+1].Physician_ID__c)))
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
                  
              } //end of if next user is different
            
        
        
    } // end of user for


    gen.writeEndObject();
    gen.writeEndArray();
    gen.writeEndObject();
    sdata = gen.getAsString();
    sdata=sdata.replaceall('\n','');
    System.Debug('-sdata' + sdata);
    Object obj=Json.deserializeUntyped(sdata);
    return obj;
    
 }  
 
     /* 
          * @Method Name                    :  callPlanning1
          * @Description                    :  JavaScript remoting to allow Call Planning record for each prescriber as well as calls associated to the same prescriber
                                               to be retrieved from Salesforce in the form of a JSON object in the absence of a territory picker.                                          
          * @Return Type                    :  object
          * @Param                          :   
                                            
    */
    
 
  @RemoteAction  
  global static Object callPlanning1(){       
        
    
     UserId = UserInfo.getUserId();
     User userObj = [SELECT Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
     Role = userObj.MYBZ_Role__c;
     if(Role==System.Label.MYBZ_AccountManager)
     GlobalId=userObj.MYBZ_Reporting_ID__c;
     else
     GlobalId = userObj.Prsnl_Nbr_GLBL__c;
     List<MYBZ_CallPlanningProductJunction__c> CallPlanningsList = new List<MYBZ_CallPlanningProductJunction__c>();
     List<MYBZ_Call__c> CallsList = new List<MYBZ_Call__c>();
     
    if(Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser){
        CallPlanningsList.clear();
        
        MYBZ_Region_Rollup__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Territory LIMIT 1];
        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c,Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:territoryObj.Global_Id__c order by Call_Planning__r.Physician_ID__c,Product__r.Name];
        //CallPlanningsList = [Select Global_ID__c,First_Name__c,Last_Name__c,Product__c,Product__r.name,Tier__c,TRx_Units__c,Previous_TRx_Units__c,Range__c from MYBZ_Call_Planning__c where Global_ID__c=:territoryObj.Global_Id__c order by First_Name__c,Last_Name__c,Product__r.Name,Range__c ];
    }
    if(Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager ){
        
        CallPlanningsList.clear();
        
        MYBZ_Region_Rollup__c districtObj = [SELECT Id, District__c FROM MYBZ_Region_Rollup__c WHERE Global_Id__c =:GlobalId LIMIT 1];
        MYBZ_Region_Rollup__c territoryObj = [SELECT Id, Name, Global_Id__c FROM MYBZ_Region_Rollup__c WHERE District__c =:districtObj.District__c AND Global_Id__c !=null AND Global_Id__c !='' LIMIT 1];
        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:territoryObj.Global_Id__c order by Call_Planning__r.Physician_ID__c,Product__r.Name];
        
    }
    if(Role == System.Label.MYBZ_SalesRepresentative){
        CallPlanningsList.clear();
        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:GlobalId order by Call_Planning__r.Physician_ID__c,Product__r.Name];
        
    }
    if(CallPlanningsList.isempty())
    {
        return null;
    }
    
    CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c, Product__c,Product__r.Name from MYBZ_Call__c where Global_ID__c=:GlobalId order by Physician_ID__c,Call_Date__c desc,Product_Position__c asc ];
    
        //Initialization of variables
    
    //Used to track percentage change values over different ranges.
    Decimal percentageChangePastMonth = 0;
    Decimal percentageChangePastThreeMonths = 0;
    Decimal percentageChangePastSixMonths = 0;
    
    //Tracks if a new physician is found while iterating over call planning records.
    
    //Integer newuserflag=1;
    
    //Tracks if the current record is the first physician record or not.
    Integer firstuserflag=1;
    
    //Tracks if the product has been encountered for the first time for a new physician.
    Integer firstproduct=1;
    
    //Tracks if a new product is encountered for the current physician.
    Integer newproduct=1;
    
    //Tracks the first call record.
    Integer firstCall=1;
    
    //Tracks the call count related to each physician.
    Integer usercallcount=0;
    
    //Initializing PhysicianID as blank. This variable is used to keep track of the PhysicianID as we iterate over call planning and call records.
    String PhysicianID ='';
    
    //String CallID='';
    
    //Initializing CurrentProduct as blank for each new physician.
    String CurrentProduct='';
    
    //Initializing currentCallID as blank. This variable is used to keep track of call IDs as we iterate over the call records.
    String currentCallID='';
    
    //Used to store created JSON in string format
    String sdata ='';
    
    //Tracks if a new call record is encountered.
    Integer newCallID=0;
    
    //Keeps track of the number of call records for each new CallID.
    Integer callsProductNumber = 1;
    
    //Temporary variable to allow us to restore the call count in case end of the call records list is reached. 
    Integer InitialCallCount=0;
    
    //Keeps track of the calls count while iterating over the call records.
    Integer CallsCount=0;
    
    //Returns a new JSON generator.
    JSONGenerator gen = JSON.createGenerator(true);
    
    
    
    //Writes the starting marker of a JSON Object.
    gen.writeStartObject();  
    if(CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c!=null)
    gen.writeStringField('startDate1Month',CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c.format(System.Label.MYBZ_DateFormat));
    else
    gen.writeNullField('startDate1Month');
    if(CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c!=null)
    gen.writeStringField('startDate3Month',CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c.format(System.Label.MYBZ_DateFormat));
    else
    gen.writeNullField('startDate3Month');
    if(CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c!=null)
    gen.writeStringField('startDate6Month',CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c.format(System.Label.MYBZ_DateFormat));
    else
    gen.writeNullField('startDate6Month');
    gen.writeFieldName('data');    
    
    gen.writeStartArray();
    
    //Loop to iterate over all call planning records.
    for(Integer CallPlanningCount=0;CallPlanningCount<CallPlanningsList.size();CallPlanningCount++)
    {
        
        //Determine if a new physician is encountered.
        if(!PhysicianID.equals(CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c))
        {
           
           //Indicates a new physician has been found       
           //newuserflag = 1;
           
           //Initializing currentCallID as blank for each new physician
           currentCallID ='';
           
           //Initializing CurrentProduct as blank for each new physician  
           CurrentProduct='';
           
           PhysicianID=CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c;
           
           //If a new physician record is encountered, start the object else, end the previous object first.
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
           
           //Write the necessary JSON fields
           
          if(CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c!=null)
           gen.writeStringField(System.Label.MYBZ_FirstName,CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c);
           else
           gen.writeNullField(System.Label.MYBZ_FirstName);
           if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c!=null)
           gen.writeStringField(System.Label.MYBZ_LastName,CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c);
           else
           gen.writeNullField(System.Label.MYBZ_LastName);
           if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c!=null)
           gen.writeStringField(System.Label.MYBZ_Tier,String.ValueOf(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c));
           else
           gen.writeNullField(System.Label.MYBZ_Tier);
           gen.writeFieldName(System.Label.MYBZ_Products);
           gen.writeStartArray();
           
           firstproduct = 1;
        }   
                
        //PRODUCTS
        //To check if a new product has been encountered for the current physician
                
        if(CallPlanningsList[CallPlanningCount].Product__c!=null)
        {
            if(!CurrentProduct.equals(CallPlanningsList[CallPlanningCount].Product__r.Name))
            {
                newproduct=1;
                percentageChangePastMonth=0;
                percentageChangePastThreeMonths=0;
                percentageChangePastSixMonths=0;
                CurrentProduct = CallPlanningsList[CallPlanningCount].Product__r.Name;
            
                //Determines if the product has been encountered for the first time for the current physician
            
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
        }
        else
        {
          newproduct=1;
          percentageChangePastMonth=0;
          percentageChangePastThreeMonths=0;
          percentageChangePastSixMonths=0;
          CurrentProduct =''; 
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
        
        if(newproduct==1)
        {
          if(CallPlanningsList[CallPlanningCount].Product__r.Name!=null)
          gen.writeStringField(System.Label.MYBZ_Name,CallPlanningsList[CallPlanningCount].Product__r.Name);
          else
          gen.writeNullField(System.Label.MYBZ_Name);
        }
        
        //Adding TRx values to the JSON if they are not null.
        
        if(CallPlanningsList[CallPlanningCount].TRx_Units_1M__c!=null)
        gen.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastMonth,CallPlanningsList[CallPlanningCount].TRx_Units_1M__c);
        else
        gen.writeNullField(System.Label.MYBZ_ScriptsWrittenPastMonth);
        if(CallPlanningsList[CallPlanningCount].TRx_Units_3M__c!=null)
        gen.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths,CallPlanningsList[CallPlanningCount].TRx_Units_3M__c);
        else
        gen.writeNullField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths);
        if(CallPlanningsList[CallPlanningCount].TRx_Units_6M__c!=null)
        gen.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastSixMonths,CallPlanningsList[CallPlanningCount].TRx_Units_6M__c);
        else
        gen.writeNullField(System.Label.MYBZ_ScriptsWrittenPastSixMonths);
        
        if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=null)
        {
          if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=0)
          {
          percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units_1M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)*100;
          percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
          }
          else
          {
            percentageChangePastMonth=0;
          }
          gen.writeNumberField(System.Label.MYBZ_PercentageChangePastMonth,percentageChangePastMonth);
        }
        else
        gen.writeNullField(System.Label.MYBZ_PercentageChangePastMonth);
        
        if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=null)
        {
          if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=0)
          {
          percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_3M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)*100;
          percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
          }
          else
          {
            percentageChangePastThreeMonths=0;
          }
          gen.writeNumberField(System.Label.MYBZ_PercentageChangePastThreeMonths,percentageChangePastThreeMonths);
        }
        else
        gen.writeNullField(System.Label.MYBZ_PercentageChangePastThreeMonths);  
        
        if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=null)
        {
          if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=0)
          {
          percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_6M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)*100;
          percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
          }
          else
          {
            percentageChangePastSixMonths=0;
          }
          gen.writeNumberField(System.Label.MYBZ_PercentageChangePastSixMonths,percentageChangePastSixMonths);
        }
        else
        gen.writeNullField(System.Label.MYBZ_PercentageChangePastSixMonths);           
        if((CallPlanningCount+1 == CallPlanningsList.size() )||(!PhysicianID.equals(CallPlanningsList[CallPlanningCount+1].Call_Planning__r.Physician_ID__c)))
        {
        gen.writeEndObject();
        gen.writeEndArray();
        
        InitialCallCount=CallsCount;
        
        //If the current call record does not correspond to the current call planning record, go to the next call record. If end of the calls list is reached, restore the callscount.
        
        if(CallsCount<CallsList.Size()&&(!PhysicianID.equals(CallsList[CallsCount].Physician_ID__c)))
                {
                    for(integer a=CallsCount;a<CallsList.Size();a++)
                    {
                        if(!PhysicianID.equals(CallsList[CallsCount].Physician_ID__c))
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
        
        //If the current call record corresponds to the current call planning record, write the required JSON fields.
        
        if(CallsCount<CallsList.Size()&&(PhysicianID.equals(CallsList[CallsCount].Physician_ID__c)))
                {               
                gen.writeFieldName(System.Label.MYBZ_Calls);
                gen.writeStartArray();
                firstCall=1;
                usercallcount=0;
                for(integer i = CallsCount; i<CallsList.Size(); i++)
                {
                    CallsCount = i;
                    
                    //If the call count for a particular physician exceeds five, break out of the loop since only five most recent calls information needs to be passed.
                    if(usercallcount==5)
                    {
                        gen.writeEndObject();
                        gen.writeEndArray();
                        break;
                    }
                    
                    usercallcount++;
                    
                    //Check if the current call record correspond to the current call planning record
                    if(PhysicianID.equals(CallsList[i].Physician_ID__c))
                    {
                         //Check if the current record encountered corresponds to the same call as the previous.
                         if(!currentCallID.equals(CallsList[i].Call_ID__c))
                        {
                            newCallID=1;
                            currentCallID= CallsList[i].Call_ID__c;
                        }
                        else
                        {
                            newCallID=0;
                        }
                        
                        
                        if( newCallID==1 && usercallcount<6)
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
                            
                            //Write the required JSON fields for the new call encountered.
                            if(CallsList[i].Call_Date__c!=null)
                            gen.writeStringField(System.Label.MYBZ_Date,CallsList[i].Call_Date__c.format(System.Label.MYBZ_DateFormat));   
                            else
                            gen.writeNullField(System.Label.MYBZ_Date);
                            if(CallsList[i].Call_Type__c!=null)
                            gen.writeStringField(System.Label.MYBZ_Type,CallsList[i].Call_Type__c);
                            else
                            gen.writeNullField(System.Label.MYBZ_Type);
                        }
                        else
                        {
                            callsProductNumber+=1;
                            //if(callsProductNumber==2)
                       }
                        
                        //Information       
                        if(CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly))
                        {
                            if(callsProductNumber==2)
                            {
                                if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL))
                                {
                                    gen.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                    usercallcount--;
                                }
                            }
                            else
                            {
                                if((CallsList[i].Product__c!=NULL))
                                {
                                gen.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        
                        
                        if((callsProductNumber<=2)&&(!CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly)))
                        {
                            
                            if(callsProductNumber==2)
                            {
                                
                                if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL)&&(CallsList[i].Product_Position__c==2))
                                {
                                    gen.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                    usercallcount--;
                                }
                            }
                            else
                            {
                               
                             if((CallsList[i].Product__c!=NULL)&&CallsList[i].Product_Position__c==1)
                                {
                                 gen.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                }
                            }
                        }
                        if((i+1 == CallsList.size() )||(!PhysicianID.equals(CallsList[i+1].Physician_ID__c)))
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
                  
              } //end of if next user is different
            
        
        
    } // end of user for


    gen.writeEndObject();
    gen.writeEndArray();
    gen.writeEndObject();
    sdata = gen.getAsString();
    sdata=sdata.replaceall('\n','');
    System.Debug('-sdata' + sdata);
    Object obj=Json.deserializeUntyped(sdata);
    return obj;
    
    
 }    
     
}