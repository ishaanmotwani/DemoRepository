/*
*@ Class Name                                                    : MYBZ_Region_Rollup_Controller
*@ Description                                                   : Controller class to prepare JSONs to share data queried from various objects to Angular JS .
Class for retrieving salesforce data in the form of a string and returning as a JSON object via a remote action.
*@ CreatedBy                                                     : Neelam Dalwani
*@ CreatedOn                                                     : 09-30-2014
*                    
*/

global with sharing class MYBZ_Region_Rollup_Controller
{
    global static Id UserId;
    global static String Role{get;set;}
    global static String GlobalId{get;set;}
    global static String datetimeStamp{get;set;}
    global static String uname{get;set;}
    global static String Page{get;set;}
    
    static String JsonString;
    static Decimal PercentageChangeTRx = 0;
    static Decimal PercentageChangeDDDUnits = 0;
    static Decimal PercentageChangeDDDDollars = 0;   
    
    static JSONGenerator generator;
    static List<MYBZ_Market_Share__c> productTrendsList = new  List<MYBZ_Market_Share__c>();
    
    
    static List<MYBZ_Product_Trend_Detail__c> TrendsDetailsList = new List<MYBZ_Product_Trend_Detail__c>();
    
    
    static List<MYBZ_Market_Share__c> marketShareList = new List<MYBZ_Market_Share__c>();  
    
    static List<MYBZ_Target_Goal__c> targetGoalList = new List<MYBZ_Target_Goal__c>();
    static Set<Decimal> targetGoalYear = new Set<Decimal>();
    static Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>> YearAndMonthTargetGoalMap = new Map<Decimal, Map<Decimal, List<MYBZ_Target_Goal__c>>>();
    
    static List<MYBZ_CallPlanningProductJunction__c> CallPlanningsList = new List<MYBZ_CallPlanningProductJunction__c>();
    static List<MYBZ_Call__c> CallsList = new List<MYBZ_Call__c>();
    
    global MYBZ_Region_Rollup_Controller(){
        fetchUserInfo();
    }
    /* 
* @Method Name                    :  fetchUserInfo
* @Description                    :  Method used to get logged in user's Role and Global id as it forms the basis to fetch 
user related data for reporting .                                        
* @Return Type                    :  void
* @Param                          :  
*/    
    global static void fetchUserInfo(){
        UserId = UserInfo.getUserId();      
        User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        if(userObj!=null ){
            Role = userObj.MYBZ_Role__c;
            if(Role==System.Label.MYBZ_AccountManager && userObj.MYBZ_Reporting_ID__c !=null){
                GlobalId=userObj.MYBZ_Reporting_ID__c;
            }
            else{ 
                GlobalId = userObj.Prsnl_Nbr_GLBL__c;
            }
            uname=userObj.name;
        }
        
        
    }
    
    /* 
* @Method Name                    :  countUsageMetrics
* @Description                    :  method is used to create a new record in usage metrics report object everytime a user
opens up the report with details like datetime,globalid, type of report etc. getting stamped each time.
This object is later used to report on User activity on this application.                                        
* @Return Type                    :  void
* @Param                          :  
*/
    
    public void countUsageMetrics()
    {
        try
        {
            MYBZ_Usage_Metric_Report__c metricsCount =new MYBZ_Usage_Metric_Report__c();
            metricsCount.DateTimeStamp__c=datetimeStamp;
            metricsCount.Global_Id__c=GlobalId;
            metricsCount.Page__c=Page;
            insert metricsCount;
        }
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of countUsageMetrics method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
        }
        
        
    }
    /* 
* @Method Name                    :  alignment
* @Description                    :  JavaScript remoting to allow Alignment record to be retrieved from Salesforce in the form of a JSON object to show alignment dropdown in territory picker.                                        
* @Return Type                    :  object
* @Param                          :  
*/
    
    @RemoteAction 
    global static Object alignment(Boolean flagAff)
    {
        try
        {
            //Call fetch user function so that Role and Global id value is available in this method.
            fetchUserInfo();
            
             UserId = UserInfo.getUserId();      
             User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
            //Changes to align Account manager to DSM for Geo
            if(flagAff == false && userObj.MYBZ_Role__c == System.Label.MYBZ_AccountManager  && userObj.MYBZ_Reporting_ID__c !=null){
              GlobalId=userObj.MYBZ_Reporting_ID__c;
            }
            
            //Returns a new JSON generator.
            generator = JSON.createGenerator(true);
            
            //Set of unique Region id's .
            Set<Id> regionIds = new Set<Id>();
            
            //Set of unique district id's.
            Set<Id> districtIds = new Set<Id>();
            
            //Checking if the division record exist. There will be only one Division record.
            MYBZ_IHS_Division__c divisionObj = [SELECT Id, Name FROM MYBZ_IHS_Division__c LIMIT 1];
            if(divisionObj==null)
            {
                return null;
            }
            else
            {
                //Map of Region name and its global id.
                Map<String, String> RegionNameAndGlobalIdMap = new Map<String, String>();
                //Map of Region name and its associated districts.
                Map<String, Set<String>> RegionNameAndDistrictMap = new Map<String, Set<String>>();
                //Map of District Name and its Global id.
                Map<String, String> DistrictNameAndGlobalIdMap = new Map<String, String>();
                //Map of District name and its associated territory.
                Map<String, Set<String>> DistrictNameAndTerritoryMap = new Map<String, Set<String>>();
                //Map of Territory and its Global id.
                Map<String, String> TerritoryNameAndGlobalIdMap = new Map<String, String>();
               
                
               
                 for(MYBZ_Region_Rollup__c regionObj : [SELECT Id, Region__r.Name, Global_Id__c, Product__r.name, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Region]){
                        if(!RegionNameAndGlobalIdMap.containsKey(regionObj.Region__r.Name)){
                            RegionNameAndGlobalIdMap.put(regionObj.Region__r.Name, regionObj.Global_Id__c);
                        }   
                    }
             
                    for(MYBZ_Region_Rollup__c districtObj : [SELECT Id, Region__r.Name, District__r.Name,Product__r.name,Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_District ]){
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
             
                    for(MYBZ_Region_Rollup__c territoryObj : [SELECT Id, Territory__r.Name, District__r.Name, Product__r.name, Global_Id__c, Alignment_Level__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Territory ]){
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
                 
                // for including PAC NW Geo   
                /*
                   IHS AM Dist/Terr should not come in the picker hence, commenting the below:
                */
                /*List<MYBZ_Market_Share__c> territoryObj = [SELECT Id, Territory__r.Name, Territory__r.State__r.name,Territory__r.state__r.region__r.name , Global_Id__c
                                                             FROM MYBZ_Market_Share__c 
                                                             WHERE Territory__r.state__r.region__r.name LIKE '%PAC NW%' OR Territory__r.Name LIKE '%IHS AM%' ];
                for(MYBZ_Market_Share__c mobj : territoryObj ){
                    if(!RegionNameAndGlobalIdMap.containsKey(mobj.Territory__r.state__r.region__r.name)){
                          RegionNameAndGlobalIdMap.put(mobj.Territory__r.state__r.region__r.name, null);
                    }
                    
                    if(!RegionNameAndDistrictMap.containsKey(mobj.Territory__r.state__r.region__r.name)){
                                            
                        RegionNameAndDistrictMap.put(mobj.Territory__r.state__r.region__r.name, new set<String>{mobj.Territory__r.State__r.name});
                    }
                    else{
                        RegionNameAndDistrictMap.get(mobj.Territory__r.state__r.region__r.name).add(mobj.Territory__r.State__r.name);
                    }
                    if(!DistrictNameAndGlobalIdMap.containsKey(mobj.Territory__r.State__r.name)){
                        DistrictNameAndGlobalIdMap.put(mobj.Territory__r.State__r.name, null);
                    }
                    
                    if(!DistrictNameAndTerritoryMap.containsKey(mobj.Territory__r.State__r.name)){
                        DistrictNameAndTerritoryMap.put(mobj.Territory__r.State__r.name, new set<String>{mobj.Territory__r.Name});
                    }
                    else{
                        DistrictNameAndTerritoryMap.get(mobj.Territory__r.State__r.name).add(mobj.Territory__r.Name);
                    }
                    if(!TerritoryNameAndGlobalIdMap.containsKey(mobj.Territory__r.Name)){
                        TerritoryNameAndGlobalIdMap.put(mobj.Territory__r.Name, mobj.Global_Id__c);
                    }    
                }
                */
                 
                 
                if(!RegionNameAndGlobalIdMap.isEmpty() && !RegionNameAndDistrictMap.isEmpty() && !DistrictNameAndGlobalIdMap.isEmpty() && !DistrictNameAndTerritoryMap.isEmpty() && !TerritoryNameAndGlobalIdMap.isEmpty()){
                    generator.writeStartArray();
                    for(String regionName : RegionNameAndGlobalIdMap.keySet()){
                        //Writes the starting marker of a JSON Object.
                        generator.writeStartObject();
                        //Start of writing the JSON fields.
                        generator.writeStringField(System.Label.MYBZ_Name,regionName);
                        String regionGlobalId = RegionNameAndGlobalIdMap.get(regionName);
                        if(regionGlobalId == null || regionGlobalId == ''){
                            generator.writeNullField(System.Label.MYBZ_globalID); 
                        }
                        else{
                            generator.writeStringField(System.Label.MYBZ_globalID,regionGlobalId);
                        }
                        
                        if(RegionNameAndDistrictMap.containsKey(regionName)){
                            generator.writeFieldName(System.Label.MYBZ_children);
                            
                            generator.writeStartArray();
                            for(String districtName : RegionNameAndDistrictMap.get(regionName)){
                                
                                //Writes the starting marker of a JSON Object.
                                generator.writeStartObject();
                                generator.writeStringField(System.Label.MYBZ_Name,districtName);
                                String districtGlobalId = DistrictNameAndGlobalIdMap.get(districtName);
                                if(districtGlobalId == null || districtGlobalId == ''){
                                    generator.writeNullField(System.Label.MYBZ_globalID);
                                }
                                else{
                                    generator.writeStringField(System.Label.MYBZ_globalID,districtGlobalId);
                                }
                                 
                                 
                                if(DistrictNameAndTerritoryMap.containsKey(districtName)){
                                    generator.writeFieldName(System.Label.MYBZ_children);
                                    
                                    //Writes the starting marker of a JSON Array.
                                    generator.writeStartArray();
                                    for(String territoryName : DistrictNameAndTerritoryMap.get(districtName)){
                                        generator.writeStartObject();
                                        generator.writeStringField(System.Label.MYBZ_Name,territoryName);
                                        String territoryGlobalId = TerritoryNameAndGlobalIdMap.get(territoryName);
                                        if(territoryGlobalId == null || territoryGlobalId == ''){
                                            generator.writeNullField(System.Label.MYBZ_globalID); 
                                        }   
                                        else
                                        {   
                                            generator.writeStringField(System.Label.MYBZ_globalID,TerritoryNameAndGlobalIdMap.get(territoryName));
                                        }
                                        
                                        
                                        generator.writeEndObject();
                                    }
                                    generator.writeEndArray();
                                }
                                generator.writeEndObject();
                            }
                            //Writes the ending marker of a JSON Array.
                            generator.writeEndArray();
                        }
                        //Writes the ending marker of a JSON Object.
                        generator.writeEndObject();
                    }
                    generator.writeEndArray();
                }
                String sdata = generator.getAsString();
                System.debug('--Alignment'+sdata );
                Object obj = Json.deserializeUntyped(sdata);
                
                
                // Begin processing of affiliation data
                List<MYBZ_System__c> sysList;
                List<MYBZ_PGP__c> orphanedPGP_list;
                if(Role == System.Label.MYBZ_SuperUser || GlobalID == null || GlobalID == '')
                {
                    sysList = [SELECT Name, 
                                      System_ID__c, 
                                      Aligned_Territories__c,
                                      Aligned_Districts__c,
                                      (SELECT Name, PGP_ID__c, Aligned_Territories__c, Aligned_Districts__c FROM pgps__r) 
                               FROM MYBZ_System__c];

                    orphanedPGP_list = [SELECT Name, PGP_ID__c, Aligned_Territories__c, Aligned_Districts__c
                                        FROM MYBZ_PGP__c];
                }
                else
                {
                    sysList = [SELECT 
                                    Name, 
                                    System_ID__c, 
                                    Aligned_Territories__c,
                                    Aligned_Districts__c, 
                                    (SELECT Name, PGP_ID__c, Aligned_Territories__c, Aligned_Districts__c FROM pgps__r) 
                               FROM MYBZ_System__c
                               WHERE Global_IDs__c INCLUDES (:GlobalID)];

                    orphanedPGP_list = [SELECT Name, PGP_ID__c, Aligned_Territories__c, Aligned_Districts__c
                                        FROM MYBZ_PGP__c
                                        WHERE Global_IDs__c INCLUDES (:GlobalID)];
                }

                MYBZ_AlignmentWrapper.Affiliation_Data response_affiliationData = new MYBZ_AlignmentWrapper.Affiliation_Data();
                
                response_affiliationData.systems = new List<MYBZ_AlignmentWrapper.IHS_System>();
                for(MYBZ_System__c sys : sysList)
                {
                    List<MYBZ_AlignmentWrapper.PGP> pgps = new List<MYBZ_AlignmentWrapper.PGP>();
                    
                    for(MYBZ_PGP__c pgp : sys.pgps__r)
                    {
                        MYBZ_AlignmentWrapper.PGP response_PGP = new MYBZ_AlignmentWrapper.PGP();
                        response_PGP.name = pgp.name;
                        response_PGP.pgpID = pgp.PGP_ID__c;
                        if(pgp.Aligned_Territories__c != null)
                            response_PGP.alignedTerritories = pgp.Aligned_Territories__c.split(';');
                        if(pgp.Aligned_Districts__c != null)
                            response_PGP.alignedDistricts = pgp.Aligned_Districts__c.split(';');

                        pgps.add(response_PGP);
                    }
                    
                    MYBZ_AlignmentWrapper.IHS_System response_System = new MYBZ_AlignmentWrapper.IHS_System();
                    response_System.name = sys.name;
                    response_System.systemID = sys.System_ID__c;
                    response_System.children = pgps;
                    if(sys.Aligned_Territories__c != null)
                        response_System.alignedTerritories = sys.Aligned_territories__c.split(';');
                    if(sys.Aligned_Districts__c != null)
                        response_System.alignedDistricts = sys.Aligned_Districts__c.split(';');

                    response_affiliationData.systems.add(response_System);
                }

                response_affiliationData.orphanedPGPs = new List<MYBZ_AlignmentWrapper.PGP>();
                for(MYBZ_PGP__c pgp : orphanedPGP_list)
                {
                    MYBZ_AlignmentWrapper.PGP response_PGP = new MYBZ_AlignmentWrapper.PGP();
                    response_PGP.name = pgp.Name;
                    response_PGP.pgpID = pgp.PGP_ID__c;
                    if(pgp.Aligned_Territories__c != null)
                        response_PGP.alignedTerritories = pgp.Aligned_Territories__c.split(';');
                    if(pgp.Aligned_Districts__c != null)
                        response_PGP.alignedDistricts = pgp.Aligned_Districts__c.split(';');

                    response_affiliationData.orphanedPGPs.add(response_PGP);
                }

                MYBZ_AlignmentWrapper.Response response_Alignment = new MYBZ_AlignmentWrapper.Response();
                response_Alignment.affiliationData = response_affiliationData;
                response_Alignment.geoData = obj;

                system.debug('--Alignment'  + JSON.serializePretty(response_Alignment));

                return response_Alignment;
            }
        }    
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of Alignment method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
    }
    

      /* 
* @Method Name                    :  regionRollup
* @Description                    :  JavaScript remoting to allow Region Rollup records to be retrieved from Salesforce in the form of a JSON object to show Region Rollup Report.                                        
* @Return Type                    :  object
* @Param                          :    

*/    
    @RemoteAction 
    global static Object regionRollup(Boolean flagAff)
    {
        try
        {
            //Call fetch user function so that Role and Global id value is available in this method.
            fetchUserInfo();
            
            UserId = UserInfo.getUserId();      
             User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
            //Changes to align Account manager to DSM for Geo
            if(flagAff == false && userObj.MYBZ_Role__c == System.Label.MYBZ_AccountManager  && userObj.MYBZ_Reporting_ID__c !=null){
              GlobalId=userObj.MYBZ_Reporting_ID__c;
            }
            
            //Checking if the division record exist. There will be only one Division record.
            //MYBZ_IHS_Division__c divisionObj = [SELECT Name FROM MYBZ_IHS_Division__c LIMIT 1];
             Boolean flagshowPAC = false ;
             if(Role != System.Label.MYBZ_SuperUser ){
                system.debug('*** user id' + userId);
                String UserDivision ;
                String UserDistrict ;
                String UserRegion ;
                
                /*MYBZ_Region_Rollup__c userDivisionRR = [Select IHS_Division__r.name, GLOBAL_ID__C, Alignment_Level__c from MYBZ_Region_Rollup__c where GLOBAL_ID__C =: GlobalId LIMIT 1];
                string UserDivision = userDivisionRR.IHS_Division__r.name;*/
                List<MYBZ_Market_Share__c> userDivisionRR = new list<MYBZ_Market_Share__c>([Select Division__r.name,District__r.name,Region__r.name, GLOBAL_ID__C from MYBZ_Market_Share__c where GLOBAL_ID__C =: GlobalId LIMIT 1]);
               
                
                if(userDivisionRR.size() != 0){
                   
                   if(userDivisionRR[0].Division__r.name != NULL &&  userDivisionRR[0].Division__r.name != ''){
                      UserDivision = userDivisionRR[0].Division__r.name;
                      if(UserDivision.contains(system.label.MYBZ_PACArea)){
                         flagshowPAC = true;
                      }
                   }
                  
                                
                }              
                
             }
             else flagshowPAC = false;
                
             List<MYBZ_IHS_Division__c> divisionObjList = new List<MYBZ_IHS_Division__c>();
             if(flagshowPAC)
                divisionObjList = [SELECT id,Name FROM MYBZ_IHS_Division__c ];
             else 
                divisionObjList = [SELECT id,Name FROM MYBZ_IHS_Division__c WHERE name =: System.Label.MYBZ_IHSDivision ];
            
            
            //List<MYBZ_IHS_Division__c> divisionObjList = [SELECT id,Name FROM MYBZ_IHS_Division__c];     
             
            //Set of unique Region id's.
            Set<Id> regionIds = new Set<Id>();
            
            //Set of unique district id's.
            Set<Id> districtIds = new Set<Id>();
            
            //Getting the first Region to fetch the metric dates as all the regions have same dates.
            MYBZ_Region_Rollup__c firstRegionNameObj;
            
            //Initializing the date range.
            List<String> rangeData = new List<String>{'oneMonthData','threeMonthData','sixMonthData'};
            
            //Initializing the metric dates.
                List<String> metricDates = new List<String>{'opexStartDates','netProfitStartDates','grossMarginsStartDates','trxStartDates','nrxStartDates','dddStartDates'};
            
            List <MYBZ_Region_Rollup__c> regionList = new List <MYBZ_Region_Rollup__c>();
            List <MYBZ_Region_Rollup__c> districtList = new List <MYBZ_Region_Rollup__c>();
            List <MYBZ_Region_Rollup__c> territoryList = new List <MYBZ_Region_Rollup__c>();
            Map<String,Map<String,MYBZ_Region_Rollup__c>> mapRegionNameAndRegion=new Map<String,Map<String,MYBZ_Region_Rollup__c>>();
            Map<String,Set<String>> mapRegionNameAndDistrictName=new Map<String,Set<String>>();
            Map<String,Map<String,MYBZ_Region_Rollup__c>> mapDistrictNameAndDistrict=new Map<String,Map<String,MYBZ_Region_Rollup__c>>();
            Map<String,Set<String>> mapDistrictNameAndTerritoryName=new Map<String,Set<String>>();
            Map<String, Map<String,MYBZ_Region_Rollup__c>> mapTerritoryNameAndTerritory = new  Map<String, Map<String,MYBZ_Region_Rollup__c>>();
            
            //Fetching all the Region Rollup data at once and then segregating it in form of Region, district, Territory. 
             for(MYBZ_Region_Rollup__c regRoll : [SELECT Region__r.Name, District__r.Name, Territory__r.Name, Gross_Margin_1M__c, Gross_Margin_3M__c, Gross_Margin_6M__c, Gross_Margin_Start_Date_1M__c, Gross_Margin_Start_Date_3M__c, Gross_Margin_Start_Date_6M__c, Net_Profit_1M__c, Net_Profit_3M__c, Net_Profit_6M__c, Net_Profit_Start_Date_1M__c, Net_Profit_Start_Date_3M__c, Net_Profit_Start_Date_6M__c, NRx_1M__c, NRx_3M__c, NRx_6M__c, NRx_Start_Date_1M__c, NRx_Start_Date_3M__c, NRx_Start_Date_6M__c, OPEX_1M__c, OPEX_3M__c, OPEX_6M__c, OPEX_Start_Date_1M__c, OPEX_Start_Date_3M__c, OPEX_Start_Date_6M__c, TRx_1M__c, TRx_3M__c, TRx_6M__c, TRx_Start_Date_1M__c, TRx_Start_Date_3M__c, TRx_Start_Date_6M__c, DDD_Dollars_1M__c, DDD_Dollars_3M__c, DDD_Dollars_6M__c, DDD_Dollars_Start_Date_1M__c, DDD_Dollars_Start_Date_3M__c, DDD_Dollars_Start_Date_6M__c, Global_Id__c, Region__r.Parent__c, Product__r.Name, Alignment_Level__c,Net_Sales_1M__c,Net_Sales_3M__c,Net_Sales_6M__c,Net_Sales_Start_Date_1M__c,Net_Sales_Start_Date_3M__c,Net_Sales_Start_Date_6M__c,IHS_Division__c, IHS_Division__r.name FROM MYBZ_Region_Rollup__c WHERE  IHS_Division__c IN: divisionObjList AND Product__c!=null]){
             
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
                        if(!mapRegionNameAndRegion.get(regionObj.Region__r.Name).containsKey(regionObj.Product__r.Name)){
                            mapRegionNameAndRegion.get(regionObj.Region__r.Name).put(regionObj.Product__r.Name,regionObj);
                        }
                        
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
                        if(!mapDistrictNameAndDistrict.get(districtObj.District__r.Name).containsKey(districtObj.Product__r.Name)){
                            mapDistrictNameAndDistrict.get(districtObj.District__r.Name).put(districtObj.Product__r.Name,districtObj);
                        }
                        
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
                        if(!mapTerritoryNameAndTerritory.get(territoryObj.Territory__r.Name).containsKey(territoryObj.Product__r.Name)){
                            mapTerritoryNameAndTerritory.get(territoryObj.Territory__r.Name).put(territoryObj.Product__r.Name,territoryObj);
                        }
                    }
                }
            }
            
            if(!regionList.isEmpty()){
                for(MYBZ_Region_Rollup__c regionObj : regionList){
                    if(regionObj.Product__r.Name == System.Label.MYBZ_EFFIENT){                    
                        firstRegionNameObj = regionObj;
                        break;
                    }
                }
                //Returns a new JSON generator.
                generator = JSON.createGenerator(true);
                
                //Writes the starting marker of a JSON Object.
                generator.writeStartObject();  
                
                //Start of writing the JSON fields.
                generator.writeStringField(System.Label.MYBZ_Name,System.Label.MYBZ_IHSDivision);
    
                //Start of writing the date fields of all the metrics.
                for(String str : metricDates){
                    if(firstRegionNameObj !=null){
                        generator.writeFieldName(str);
                        generator.writeStartObject();
                        if(str == 'opexStartDates'){
                            if(firstRegionNameObj.OPEX_Start_Date_1M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,firstRegionNameObj.OPEX_Start_Date_1M__c);
                            }
                            if(firstRegionNameObj.OPEX_Start_Date_3M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,firstRegionNameObj.OPEX_Start_Date_3M__c);
                            }
                            if(firstRegionNameObj.OPEX_Start_Date_6M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,firstRegionNameObj.OPEX_Start_Date_6M__c);
                            }
                        }
                        else if(str == 'netProfitStartDates'){
                            if(firstRegionNameObj.Net_Profit_Start_Date_1M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,firstRegionNameObj.Net_Profit_Start_Date_1M__c);
                            }
                            if(firstRegionNameObj.Net_Profit_Start_Date_3M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,firstRegionNameObj.Net_Profit_Start_Date_3M__c);
                            }
                            if(firstRegionNameObj.Net_Profit_Start_Date_6M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,firstRegionNameObj.Net_Profit_Start_Date_6M__c);
                            }
                        }
                        else if(str == 'grossMarginsStartDates'){
                            if(firstRegionNameObj.Gross_Margin_Start_Date_1M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,firstRegionNameObj.Gross_Margin_Start_Date_1M__c);
                            }
                            if(firstRegionNameObj.Gross_Margin_Start_Date_3M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,firstRegionNameObj.Gross_Margin_Start_Date_3M__c);
                            }
                            if(firstRegionNameObj.Gross_Margin_Start_Date_6M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,firstRegionNameObj.Gross_Margin_Start_Date_6M__c);
                            }
                        }
                        else if(str == 'trxStartDates'){
                            if(firstRegionNameObj.TRx_Start_Date_1M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,firstRegionNameObj.TRx_Start_Date_1M__c);
                            }
                            if(firstRegionNameObj.TRx_Start_Date_3M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,firstRegionNameObj.TRx_Start_Date_3M__c);
                            }
                            if(firstRegionNameObj.TRx_Start_Date_6M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,firstRegionNameObj.TRx_Start_Date_6M__c);
                            }
                        }
                        else if(str == 'nrxStartDates'){
                            if(firstRegionNameObj.NRx_Start_Date_1M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,firstRegionNameObj.NRx_Start_Date_1M__c);
                            }
                            if(firstRegionNameObj.NRx_Start_Date_3M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,firstRegionNameObj.NRx_Start_Date_3M__c);
                            }
                            if(firstRegionNameObj.NRx_Start_Date_6M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,firstRegionNameObj.NRx_Start_Date_6M__c);
                            }
                        }
                        else if(str == 'dddStartDates'){
                            if(firstRegionNameObj.DDD_Dollars_Start_Date_1M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_oneMonthDataStartDate,firstRegionNameObj.DDD_Dollars_Start_Date_1M__c);
                            }
                            if(firstRegionNameObj.DDD_Dollars_Start_Date_3M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_threeMonthDataStartDate,firstRegionNameObj.DDD_Dollars_Start_Date_3M__c);
                            }
                            if(firstRegionNameObj.DDD_Dollars_Start_Date_6M__c != null){
                                generator.writeDateTimeField(System.Label.MYBZ_sixMonthDataStartDate,firstRegionNameObj.DDD_Dollars_Start_Date_6M__c);
                            }
                        }
                        
                        //Writes the ending marker of a JSON Object.
                        generator.writeEndObject();
                    }
                }
                if(!mapRegionNameAndRegion.isEmpty()){
                    generator.writeFieldName(System.Label.MYBZ_children);
                    generator.writeStartArray();
                    for(String regionName : mapRegionNameAndRegion.keySet())
                    {
                        generator.writeStartObject(); 
                        generator.writeStringField(System.Label.MYBZ_Name,regionName);
                        if(!mapRegionNameAndRegion.get(regionName).isEmpty())
                        {
                            Map<String,MYBZ_Region_Rollup__c> regionsMap = mapRegionNameAndRegion.get(regionName);
                            for(String str : rangeData){
                                generator.writeFieldName(str);
                                generator.writeStartArray();
                                
                                //Start of writing fields of region as per the range.
                                for(String eachProduct : regionsMap.keySet()){
                                    MYBZ_Region_Rollup__c tempRegionObj = regionsMap.get(eachProduct);
                                    if(str == 'oneMonthData'){
                                        generator.writeStartObject();
                                        if(tempRegionObj.Product__c!=null){
                                            generator.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_Name);
                                        }
                                        if(tempRegionObj.TRx_1M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_1M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_trxValue);
                                        }   
                                        if(tempRegionObj.NRx_1M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_1M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_nrxValue);
                                        }   
                                        if(tempRegionObj.OPEX_1M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_1M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_opex);
                                        }   
                                        if(tempRegionObj.Gross_Margin_1M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_1M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_grossMargins);
                                        }
                                        if(tempRegionObj.Net_Profit_1M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_1M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_netProfit);
                                        }
                                        if(tempRegionObj.DDD_Dollars_1M__c !=null){
                                            generator.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_1M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_dddDollars);
                                        }
                                        if(tempRegionObj.Region__r.name.contains(system.label.MYBZ_PACArea)) {
                                            if(tempRegionObj.Net_Sales_1M__c !=null ){
                                                generator.writeNumberField(System.Label.MYBZ_newSales,tempRegionObj.Net_Sales_1M__c);
                                            }
                                            else
                                            {
                                                generator.writeNullField(System.Label.MYBZ_newSales);
                                            } 
                                        }
                                        generator.writeEndObject();
                                        
                                          
                                    }
                                    if(str == 'threeMonthData'){
                                        generator.writeStartObject();
                                        if(tempRegionObj.Product__c!=null){
                                            generator.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_Name);
                                        }
                                        if(tempRegionObj.TRx_3M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_3M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_trxValue);
                                        }   
                                        if(tempRegionObj.NRx_3M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_3M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_nrxValue);
                                        }   
                                        if(tempRegionObj.OPEX_3M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_3M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_opex);
                                        }   
                                        if(tempRegionObj.Gross_Margin_3M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_3M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_grossMargins);
                                        }
                                        if(tempRegionObj.Net_Profit_3M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_3M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_netProfit);
                                        }
                                        if(tempRegionObj.DDD_Dollars_3M__c !=null){
                                            generator.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_3M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_dddDollars);
                                        }   
                                        
                                        if(tempRegionObj.Region__r.name.contains(system.label.MYBZ_PACArea)) {                                      
                                            if(tempRegionObj.Net_Sales_3M__c !=null){
                                                generator.writeNumberField(System.Label.MYBZ_newSales,tempRegionObj.Net_Sales_3M__c);
                                            }
                                            else
                                            {
                                                generator.writeNullField(System.Label.MYBZ_newSales);
                                            }  
                                        }               
                                        generator.writeEndObject();
                                    }
                                    if(str == 'sixMonthData'){
                                        generator.writeStartObject();
                                        if(tempRegionObj.Product__c!=null){
                                            generator.writeStringField(System.Label.MYBZ_Name,tempRegionObj.Product__r.Name);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_Name);
                                        }
                                        if(tempRegionObj.TRx_6M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_trxValue,tempRegionObj.TRx_6M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_trxValue);
                                        }   
                                        if(tempRegionObj.NRx_6M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_nrxValue,tempRegionObj.NRx_6M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_nrxValue);
                                        }   
                                        if(tempRegionObj.OPEX_6M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_opex,tempRegionObj.OPEX_6M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_opex);
                                        }   
                                        if(tempRegionObj.Gross_Margin_6M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_grossMargins,tempRegionObj.Gross_Margin_6M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_grossMargins);
                                        }
                                        if(tempRegionObj.Net_Profit_6M__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_netProfit,tempRegionObj.Net_Profit_6M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_netProfit);
                                        }
                                        if(tempRegionObj.DDD_Dollars_6M__c !=null){
                                            generator.writeNumberField(System.Label.MYBZ_dddDollars,tempRegionObj.DDD_Dollars_6M__c);
                                        }
                                        else
                                        {
                                            generator.writeNullField(System.Label.MYBZ_dddDollars);
                                        }
                                        if(tempRegionObj.Region__r.name.contains(system.label.MYBZ_PACArea)) {
                                            if(tempRegionObj.Net_Sales_6M__c !=null){
                                                generator.writeNumberField(System.Label.MYBZ_newSales,tempRegionObj.Net_Sales_6M__c);
                                            }
                                            else
                                            {
                                                generator.writeNullField(System.Label.MYBZ_newSales);
                                            }
                                        }   
                                        generator.writeEndObject();
                                    }
                                }
                                generator.writeEndArray();
                            }
                        }
                        
                        if(!mapRegionNameAndDistrictName.get(regionName).isEmpty()){
                            generator.writeFieldName(System.Label.MYBZ_children);
                            generator.writeStartArray();
                            
                            //Start of writing fields of district as per the range.
                            for(String distName : mapRegionNameAndDistrictName.get(regionName))
                            {
                                generator.writeStartObject(); 
                                generator.writeStringField(System.Label.MYBZ_Name,distName);                           
                                if(!mapDistrictNameAndDistrict.get(distName).isEmpty())
                                {
                                    Map<String,MYBZ_Region_Rollup__c> distMap = mapDistrictNameAndDistrict.get(distName);
                                    for(String str : rangeData){
                                        generator.writeFieldName(str);
                                        generator.writeStartArray();
                                        for(String eachProduct : distMap.keySet()){
                                            MYBZ_Region_Rollup__c tempdistObj = distMap.get(eachProduct);
                                            if(str == 'oneMonthData'){
                                                generator.writeStartObject();
                                                
                                                if(tempdistObj.Product__c!=null){
                                                    generator.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_Name);
                                                }
                                                if(tempdistObj.TRx_1M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_1M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_trxValue);
                                                }   
                                                if(tempdistObj.NRx_1M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_1M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_nrxValue);
                                                }   
                                                if(tempdistObj.OPEX_1M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_1M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_opex);
                                                }           
                                                if(tempdistObj.Gross_Margin_1M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_1M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_grossMargins);
                                                }
                                                if(tempdistObj.Net_Profit_1M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_1M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_netProfit);
                                                }
                                                if(tempdistObj.DDD_Dollars_1M__c !=null){
                                                    generator.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_1M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_dddDollars);
                                                }
                                                if(tempdistObj.District__r.Name.contains(system.label.MYBZ_PACDistrict)) {
                                                    if(tempdistObj.Net_Sales_1M__c !=null){
                                                        generator.writeNumberField(System.Label.MYBZ_newSales,tempdistObj.Net_Sales_1M__c);
                                                    }
                                                    else
                                                    {
                                                        generator.writeNullField(System.Label.MYBZ_newSales);
                                                    } 
                                                }
                                                generator.writeEndObject();
                                            }
                                            if(str == 'threeMonthData'){
                                                generator.writeStartObject();
                                                if(tempdistObj.Product__c!=null){
                                                    generator.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_Name);
                                                }
                                                if(tempdistObj.TRx_3M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_3M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_trxValue);
                                                }   
                                                if(tempdistObj.NRx_3M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_3M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_nrxValue);
                                                }   
                                                if(tempdistObj.OPEX_3M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_3M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_opex);
                                                }   
                                                if(tempdistObj.Gross_Margin_3M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_3M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_grossMargins);
                                                }
                                                if(tempdistObj.Net_Profit_3M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_3M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_netProfit);
                                                }
                                                if(tempdistObj.DDD_Dollars_3M__c !=null){
                                                    generator.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_3M__c);
                                                }
                                                else
                                                { 
                                                    generator.writeNullField(System.Label.MYBZ_dddDollars);
                                                }
                                                if(tempdistObj.District__r.Name.contains(system.label.MYBZ_PACDistrict)) {
                                                    if(tempdistObj.Net_Sales_3M__c !=null){
                                                        generator.writeNumberField(System.Label.MYBZ_newSales,tempdistObj.Net_Sales_3M__c);
                                                    }
                                                    else
                                                    {
                                                        generator.writeNullField(System.Label.MYBZ_newSales);
                                                    } 
                                                }   
                                                generator.writeEndObject();
                                            }
                                            if(str == 'sixMonthData'){
                                                generator.writeStartObject();
                                                if(tempdistObj.Product__c!=null){
                                                    generator.writeStringField(System.Label.MYBZ_Name,tempdistObj.Product__r.Name);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_Name);
                                                }
                                                if(tempdistObj.TRx_6M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_trxValue,tempdistObj.TRx_6M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_trxValue);
                                                }   
                                                if(tempdistObj.NRx_6M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_nrxValue,tempdistObj.NRx_6M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_nrxValue);
                                                }   
                                                if(tempdistObj.OPEX_6M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_opex,tempdistObj.OPEX_6M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_opex);
                                                }   
                                                if(tempdistObj.Gross_Margin_6M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_grossMargins,tempdistObj.Gross_Margin_6M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_grossMargins);
                                                }
                                                if(tempdistObj.Net_Profit_6M__c!=null){
                                                    generator.writeNumberField(System.Label.MYBZ_netProfit,tempdistObj.Net_Profit_6M__c);
                                                }
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_netProfit);
                                                }
                                                if(tempdistObj.DDD_Dollars_6M__c !=null){
                                                    generator.writeNumberField(System.Label.MYBZ_dddDollars,tempdistObj.DDD_Dollars_6M__c);
                                                }   
                                                else
                                                {
                                                    generator.writeNullField(System.Label.MYBZ_dddDollars);
                                                }
                                                if(tempdistObj.District__r.Name.contains(system.label.MYBZ_PACDistrict)) {
                                                    if(tempdistObj.Net_Sales_6M__c !=null){
                                                        generator.writeNumberField(System.Label.MYBZ_newSales,tempdistObj.Net_Sales_6M__c);
                                                    }
                                                    else
                                                    {
                                                        generator.writeNullField(System.Label.MYBZ_newSales);
                                                    } 
                                                }   
                                                generator.writeEndObject();
                                            }
                                        }
                                        generator.writeEndArray();
                                    }
                                }
                                if(!mapDistrictNameAndTerritoryName.get(distName).isEmpty()){
                                    generator.writeFieldName(System.Label.MYBZ_children);
                                    generator.writeStartArray();
                                    for(String terrName : mapDistrictNameAndTerritoryName.get(distName))
                                    {
                                        generator.writeStartObject(); 
                                        
                                         //Start of writing fields of territory as per the range.
                                        generator.writeStringField(System.Label.MYBZ_Name,terrName);
                                        
                                        if(!mapTerritoryNameAndTerritory.get(terrName).isEmpty())
                                        {
                                            Map<String,MYBZ_Region_Rollup__c> terrMap = mapTerritoryNameAndTerritory.get(terrName);
                                            for(String str : rangeData){
                                                generator.writeFieldName(str);
                                                generator.writeStartArray();
                                                for(String eachProduct : terrMap.keySet()){
                                                    MYBZ_Region_Rollup__c tempTerrtObj = terrMap.get(eachProduct);
                                                    if(str == 'oneMonthData'){
                                                        generator.writeStartObject();
                                                        if(tempTerrtObj.Product__c!=null){
                                                            generator.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_Name);
                                                        }
                                                        if(tempTerrtObj.TRx_1M__c!=null){
                                                            generator.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_1M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_trxValue);
                                                        }   
                                                        if(tempTerrtObj.NRx_1M__c!=null){
                                                            generator.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_1M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_nrxValue);
                                                        }
                                                        if(tempTerrtObj.DDD_Dollars_1M__c !=null){
                                                            generator.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_1M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_dddDollars);
                                                        }
                                                       // if(tempTerrtObj.Territory__r.Name.contains('IHS AM')) {
                                                       if(tempTerrtObj.District__r.Name.contains(system.label.MYBZ_PACDistrict)){
                                                            if(tempTerrtObj.Net_Sales_1M__c !=null){
                                                                generator.writeNumberField(System.Label.MYBZ_newSales,tempTerrtObj.Net_Sales_1M__c);
                                                            }
                                                            else
                                                            {
                                                                generator.writeNullField(System.Label.MYBZ_newSales);
                                                            } 
                                                        }                                                       
                                                        generator.writeEndObject();
                                                    }
                                                    if(str == 'threeMonthData'){
                                                        generator.writeStartObject();
                                                        if(tempTerrtObj.Product__c!=null){
                                                            generator.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_Name);
                                                        }
                                                        if(tempTerrtObj.TRx_3M__c!=null){
                                                            generator.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_3M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_trxValue);
                                                        }   
                                                        if(tempTerrtObj.NRx_3M__c!=null){
                                                            generator.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_3M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_nrxValue);
                                                        }
                                                        if(tempTerrtObj.DDD_Dollars_3M__c !=null){
                                                            generator.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_3M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_dddDollars);
                                                        }
                                                       if(tempTerrtObj.District__r.Name.contains(system.label.MYBZ_PACDistrict)){
                                                            if(tempTerrtObj.Net_Sales_3M__c !=null){
                                                                generator.writeNumberField(System.Label.MYBZ_newSales,tempTerrtObj.Net_Sales_3M__c);
                                                            }
                                                            else
                                                            {
                                                                generator.writeNullField(System.Label.MYBZ_newSales);
                                                            } 
                                                        }   
                                                        generator.writeEndObject();
                                                    }
                                                    if(str == 'sixMonthData'){
                                                        generator.writeStartObject();
                                                        if(tempTerrtObj.Product__c!=null){
                                                            generator.writeStringField(System.Label.MYBZ_Name,tempTerrtObj.Product__r.Name);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_Name);
                                                        }
                                                        if(tempTerrtObj.TRx_6M__c!=null){
                                                            generator.writeNumberField(System.Label.MYBZ_trxValue,tempTerrtObj.TRx_6M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_trxValue);
                                                        }   
                                                        if(tempTerrtObj.NRx_6M__c!=null){
                                                            generator.writeNumberField(System.Label.MYBZ_nrxValue,tempTerrtObj.NRx_6M__c);
                                                        }
                                                        else
                                                        {
                                                            generator.writeNullField(System.Label.MYBZ_nrxValue);
                                                        }
                                                        if(tempTerrtObj.DDD_Dollars_6M__c !=null){
                                                            generator.writeNumberField(System.Label.MYBZ_dddDollars,tempTerrtObj.DDD_Dollars_6M__c);
                                                        }
                                                        else
                                                        {   
                                                            generator.writeNullField(System.Label.MYBZ_dddDollars);
                                                        }
                                                        if(tempTerrtObj.District__r.Name.contains(system.label.MYBZ_PACDistrict)){
                                                            if(tempTerrtObj.Net_Sales_6M__c !=null){
                                                                generator.writeNumberField(System.Label.MYBZ_newSales,tempTerrtObj.Net_Sales_6M__c);
                                                            }
                                                            else
                                                            {
                                                                generator.writeNullField(System.Label.MYBZ_newSales);
                                                            }  
                                                        }   
                                                        generator.writeEndObject();
                                                    }
                                                }
                                                generator.writeEndArray();
                                            }
                                        }
                                        generator.writeEndObject(); 
                                    }
                                    generator.writeEndArray();
                                }
                                generator.writeEndObject();
                            }
                            generator.writeEndArray();
                        }
                        generator.writeEndObject();
                    }
                    
                    //Writes the ending marker of a JSON Array.
                    generator.writeEndArray();
                }
                
                //Writes the ending marker of a JSON Object.
                generator.writeEndObject();
            }
            JsonString = generator.getAsString();
            System.debug('--RegionRollup1'+JsonString );
            Object RegionRollupObject = Json.deserializeUntyped(JsonString);
            return RegionRollupObject;
        }
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of RegionRollup1 method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
    }
    
    

    /* 
* @Method Name                    :  targetGoalUsingPicker
* @Description                    :  JavaScript remoting to allow TargetGoal record associated with particular district to be retrieved from Salesforce in the form of a JSON object                                         
* @Return Type                    :  object
* @Param                          :   Region - The region associated to the territory selected, District - The district associated to the territory selected
Territory - The territory selected via a territory picker.  

*/    
    @RemoteAction 
    global static Object targetGoalUsingPicker(String region, String district, String territory)
    {   
        try{
            // fetching logged in user information like Role,global id etc.
            fetchUserInfo();
            
            // Query for target Goal records based on the role of logged in user and alignment chosen using territory picker, decides the data available on report
            if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) && district != null && district != ''){
                targetGoalList.clear();
                targetGoalList = [SELECT Id, Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c ,Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:district AND Territory__c = null   ORDER BY Month__c, Year__c ASC ];
            }
            if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) && territory != null && territory != ''){
                targetGoalList.clear();
                targetGoalList = [SELECT Id, Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c ,Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Territory__r.Name =: territory ORDER BY Month__c, Year__c ASC ];
            }
            if(Role == System.Label.MYBZ_MajorMarketManager && district !=null && district !=''){
                targetGoalList.clear();
                targetGoalList = [SELECT Id, Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c ,Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:district AND Territory__c = null ORDER BY Month__c, Year__c ASC];
            }
            if(Role == System.Label.MYBZ_SuperUser && district != null && district != ''){
                targetGoalList.clear();
                targetGoalList = [SELECT Id,Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c , Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__r.Name =:district AND Territory__c = null ORDER BY Month__c, Year__c ASC];
            }
            if(Role == System.Label.MYBZ_SuperUser && territory != null && territory != ''){
                targetGoalList.clear();
                targetGoalList = [SELECT Id, Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c ,Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Territory__r.Name =: territory ORDER BY Month__c, Year__c ASC ];
            }
        }    
        catch(Exception E){
            system.debug('Exception occurred during execution of Target Goal method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
            
        }
        
        
        
        // Call to method which processes target Goal JSON based on target goal list queried above
        Object targetGoalObject = targetGoalProcessor();
        System.debug('TargetGoalObject--'+targetGoalObject);
        return targetGoalObject;
        
    }
    
    /* 
* @Method Name                    :  TargetGoal
* @Description                    :  JavaScript remoting to allow TargetGoal record associated with particular district to be retrieved from Salesforce in the form of a JSON object                                         
* @Return Type                    :  object
* @Param                          :   

*/    
    @RemoteAction 
    global static Object targetGoal(Boolean flagAff)
    {
        try{
            // fetching logged in user information like Role,global id etc.
            fetchUserInfo();            
            
            UserId = UserInfo.getUserId();      
             User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
            //Changes to align Account manager to DSM for Geo
            if(flagAff == false && userObj.MYBZ_Role__c == System.Label.MYBZ_AccountManager  && userObj.MYBZ_Reporting_ID__c !=null){
              GlobalId=userObj.MYBZ_Reporting_ID__c;
            }
            
            // Query for target Goal records based on the role of logged in user, decides the data available on report
            if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager)){
                targetGoalList.clear();
                targetGoalList = [SELECT Id,Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c , Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Global_Id__c =:GlobalId AND Territory__c = null ORDER BY Month__c, Year__c ASC];
            }
            else if(Role == System.Label.MYBZ_MajorMarketManager){
                targetGoalList.clear();
                MYBZ_Region_Rollup__c regionRollupObj = [SELECT Id, District__c FROM MYBZ_Region_Rollup__c WHERE Global_Id__c =:GlobalId LIMIT 1];
                
                targetGoalList = [SELECT Id, Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c ,Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__c =:regionRollupObj.District__c AND Territory__c = null ORDER BY Month__c, Year__c ASC];
            }
            else if(Role == System.Label.MYBZ_SalesRepresentative){
                targetGoalList.clear();
                targetGoalList = [SELECT Id, Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c ,Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE Global_Id__c =:GlobalId ORDER BY Month__c, Year__c ASC];
                
            }
            else if(Role == System.Label.MYBZ_SuperUser){
                targetGoalList.clear();  
                MYBZ_District__c districtObj = [SELECT Id,Region__r.name FROM MYBZ_District__c WHERE Region__r.name =: System.Label.MYBZ_defaultRegion LIMIT 1];
                if(districtObj!=null){
                    targetGoalList = [SELECT Id, Baseline__c,actualDddUnits__c,Product_Weight_DDD__c,Product_Weight_TRx__c ,Global_Id__c, Month__c, Year__c, Product__r.Name, TRx_Goal__c, TRx_Goal_Attainment__c FROM MYBZ_Target_Goal__c WHERE District__c =:districtObj.Id AND Territory__c = null ORDER BY Month__c, Year__c ASC];
                }
            }
        }
        catch(Exception E){
            system.debug('Exception occurred during execution of Target Goal method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        // Call to method which processes target Goal JSON based on target goal list queried above
        Object targetGoalObject = targetGoalProcessor();
        System.debug('TargetGoalObject--'+targetGoalObject);
        return targetGoalObject;
    }
    
    /* 
* @Method Name                    :  targetGoalProcessor
* @Description                    :  Utility method for creating JSONS associated with Target Goal Report
* @Return Type                    :  object
* @Param                          :   */    

    global static Object targetGoalProcessor()
    {
        // Map variable to collate data set of months associated with each year for which target goal records are found
        Map<Decimal, Set<Decimal>> YearAndMonthsMap = new Map<Decimal, Set<Decimal>>();
                try{
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
            object TargetGoalObject;
            if(!targetGoalYear.isEmpty() && !YearAndMonthTargetGoalMap.isEmpty()){
                generator = JSON.createGenerator(true);
                generator.writeStartArray();
                for(Decimal year : targetGoalYear){
                    if(YearAndMonthTargetGoalMap.containsKey(year)){
                        Map<Decimal, List<MYBZ_Target_Goal__c>> TempMonthAndTargetGoalMap = YearAndMonthTargetGoalMap.get(year);
                        for(Decimal month : TempMonthAndTargetGoalMap.keySet()){
                            generator.writeStartObject();
                            generator.writeNumberField(System.Label.MYBZ_month,month);
                            generator.writeNumberField(System.Label.MYBZ_Year,year);
                            if(TempMonthAndTargetGoalMap.get(month) !=null){
                                generator.writeFieldName(System.Label.MYBZ_goals);
                                generator.writeStartArray();
                                for(MYBZ_Target_Goal__c targetGoalObj : TempMonthAndTargetGoalMap.get(month)){
                                    generator.writeStartObject();
                                    generator.writeStringField(System.Label.MYBZ_productName,targetGoalObj.Product__r.Name);
                                     if(targetGoalObj.TRx_Goal__c !=null)
                                        generator.writeNumberField(System.Label.MYBZ_goalSet,targetGoalObj.TRx_Goal__c);
                                    else
                                        generator.writeNullField(System.Label.MYBZ_goalSet);
                                    if(targetGoalObj.TRx_Goal_Attainment__c !=null)
                                        generator.writeNumberField(System.Label.MYBZ_goalMet,targetGoalObj.TRx_Goal_Attainment__c);
                                    else
                                        generator.writeNullField(System.Label.MYBZ_goalMet);
                                    if(targetGoalObj.Baseline__c !=null)
                                        generator.writeNumberField(System.Label.MYBZ_Baseline,targetGoalObj.Baseline__c);
                                   else
                                       generator.writeNullField(System.Label.MYBZ_Baseline);
                                   if(targetGoalObj.actualDddUnits__c !=null)
                                        generator.writeNumberField(System.Label.MYBZ_actualDddUnits,targetGoalObj.actualDddUnits__c);
                                   else
                                       generator.writeNullField(System.Label.MYBZ_actualDddUnits);
                                    if(targetGoalObj.Product_Weight_DDD__c !=null)
                                     generator.writeNumberField(System.Label.MYBZ_Product_Weight_DDD_c,targetGoalObj.Product_Weight_DDD__c);
                                   else
                                       generator.writeNullField(System.Label.MYBZ_Product_Weight_DDD_c);
                                    if(targetGoalObj.Product_Weight_TRx__c !=null)
                                     generator.writeNumberField(System.Label.MYBZ_Product_Weight_TRx,targetGoalObj.Product_Weight_TRx__c);
                                    else
                                       generator.writeNullField(System.Label.MYBZ_Product_Weight_TRx);
                                    generator.writeEndObject();
                                }
                                generator.writeEndArray();
                            }
                            generator.writeEndObject();
                        }
                    }
                }
                generator.writeEndArray();
                JsonString = generator.getAsString();
                System.debug('--TargetGoal1'+JsonString);
                TargetGoalObject = Json.deserializeUntyped(JsonString);
            }
            return TargetGoalObject;
        }
        catch(Exception E)
        {
            system.debug('Exception occurred during execution of TargetGoal Processor method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }

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
    global static Object callPlanningUsingPicker(String region, String district, String territory)
    {       
        try{   
            
            fetchUserInfo();      
            if(Role == System.Label.MYBZ_SalesRepresentative){
                CallPlanningsList.clear();
                CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c, Call_Planning__r.Data_Load_Date__c, Call_Planning__r.LoadIdentifier__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:GlobalId AND Call_Planning__r.LoadIdentifier__c='NON_AFFLTN' order by Call_Planning__r.Physician_ID__c,Product__r.Name];
                CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c, Product__c,Product__r.Name, Territory__r.State__c, LoadIdentifier__c, Range__c from MYBZ_Call__c where Global_ID__c=:GlobalId AND LoadIdentifier__c='NON_AFFLTN' order by Physician_ID__c,Call_Date__c desc,Call_ID__c asc,Range__c asc, Product_Position__c asc ];
                
            }
            if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  || Role == System.Label.MYBZ_SuperUser) && territory != null && territory !=''){
                CallPlanningsList.clear();
                CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Call_Planning__r.Territory__r.Name, Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c,Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c, Call_Planning__r.Data_Load_Date__c, Call_Planning__r.LoadIdentifier__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Territory__r.Name=:territory AND Call_Planning__r.LoadIdentifier__c='NON_AFFLTN' order by Call_Planning__r.Physician_ID__c,Product__r.Name];
                CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c, Product__c,Product__r.Name,Territory__c,Territory__r.Name, Territory__r.state__c, LoadIdentifier__c, Range__c from MYBZ_Call__c where Territory__r.Name=:territory AND LoadIdentifier__c='NON_AFFLTN' order by Physician_ID__c,Call_Date__c desc,Call_ID__c asc, Range__c asc, Product_Position__c asc ];
            }
            if(Role == System.Label.MYBZ_MajorMarketManager){
                CallPlanningsList.clear();
                MYBZ_Region_Rollup__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Territory LIMIT 1];
                CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c, Call_Planning__r.Data_Load_Date__c, Call_Planning__r.LoadIdentifier__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:territoryObj.Global_Id__c AND Call_Planning__r.LoadIdentifier__c='NON_AFFLTN' order by Call_Planning__r.Physician_ID__c,Product__r.Name];
            }

        }
        Catch(Exception e)
        {
            system.debug('Exception occurred during execution of TargetGoal Processor method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        Object callPlanningObject = callPlanningProcessor();
        System.debug('callPlanningObject--'+callPlanningObject);
        return callPlanningObject; 
    }
    
    /* 
* @Method Name                    :  callPlanning
* @Description                    :  JavaScript remoting to allow Call Planning record for each prescriber as well as calls associated to the same prescriber
to be retrieved from Salesforce in the form of a JSON object in the absence of a territory picker.                                          
* @Return Type                    :  object
* @Param                          :   */
    
    @RemoteAction 
    global static Object callPlanning()
    {       
        try{    
            fetchUserInfo();
            if(Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser){
                CallPlanningsList.clear();                
                MYBZ_Region_Rollup__c territoryObj = [SELECT Id, Global_Id__c FROM MYBZ_Region_Rollup__c WHERE Alignment_Level__c = :System.Label.MYBZ_Territory LIMIT 1];
                if(territoryObj!=null){ 
                    CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c,Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c,Call_Planning__r.LoadIdentifier__c, Call_Planning__r.Data_Load_Date__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:territoryObj.Global_Id__c AND Call_Planning__r.LoadIdentifier__c='NON_AFFLTN' order by Call_Planning__r.Physician_ID__c,Product__r.Name];
                }
            }
            if(Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager ){
                CallPlanningsList.clear();                
                MYBZ_Region_Rollup__c districtObj = [SELECT Id, District__c FROM MYBZ_Region_Rollup__c WHERE Global_Id__c =:GlobalId LIMIT 1];
                if(districtObj!=null){
                    MYBZ_Region_Rollup__c territoryObj = [SELECT Id, Name, Global_Id__c FROM MYBZ_Region_Rollup__c WHERE District__c =:districtObj.District__c AND Global_Id__c !=null AND Global_Id__c !='' LIMIT 1];
                    if(territoryObj!=null){
                        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c,Call_Planning__r.LoadIdentifier__c,Call_Planning__r.Data_Load_Date__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:territoryObj.Global_Id__c AND Call_Planning__r.LoadIdentifier__c='NON_AFFLTN' order by Call_Planning__r.Physician_ID__c,Product__r.Name];
                    }
                }
            }
            if(Role == System.Label.MYBZ_SalesRepresentative){
                CallPlanningsList.clear();
                CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c,Call_Planning__r.LoadIdentifier__c,Call_Planning__r.Data_Load_Date__c from MYBZ_CallPlanningProductJunction__c where Call_Planning__r.Global_ID__c=:GlobalId AND Call_Planning__r.LoadIdentifier__c='NON_AFFLTN' order by Call_Planning__r.Physician_ID__c,Product__r.Name];
                CallsList = [select Name,Global_ID__c,First_Name__c,Last_Name__c,Physician_ID__c, Call_ID__c,Call_Type__c,Product_Position__c,Call_Date__c, Product__c,Product__r.Name, Territory__r.state__c, LoadIdentifier__c, Range__c from MYBZ_Call__c where Global_ID__c=:GlobalId AND LoadIdentifier__c='NON_AFFLTN' order by Physician_ID__c,Call_Date__c desc,Call_ID__c asc, Range__c asc, Product_Position__c asc ];
            }
        }
        Catch(Exception e)
        {
            system.debug('Exception occurred during execution of Processor method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        
        Object callPlanningObject = callPlanningProcessor();
        System.debug('callPlanningObject--'+callPlanningObject);
        return callPlanningObject; 
    }
    
    /* 
* @Method Name                    :  CallPlanningProcessor
* @Description                    :  Utility method for Creating JSONs associated with Call planning Report                                         
* @Return Type                    :  object
* @Param                          :   

*/
    
    global static Object callPlanningProcessor(){
        try{
            if(CallPlanningsList.isempty())
            {
                return null;
            } 
            
            DateTime districtLastCallDate = null;
            if(CallsList != null){
                Set<Id> districtIds = new Set<Id>();
                for(MYBZ_Call__c call : CallsList)
                    districtIds.add(call.Territory__r.State__c);
                

                districtLastCallDate = (DateTime)[SELECT MAX(Call_Date__c)
                                                  FROM MYBZ_Call__c
                                                  WHERE Territory__c IN (SELECT Id FROM MYBZ_Territory__c WHERE State__c IN :districtIds)][0].get('expr0');
            }


            //Initialization of variables            
            //Used to track percentage change values over different ranges.
            Decimal percentageChangePastMonth = 0;
            Decimal percentageChangePastThreeMonths = 0;
            Decimal percentageChangePastSixMonths = 0;
            
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
            JsonString ='';
            
            //Tracks if a new call record is encountered.
            Integer newCallID=0;
            
            //Keeps track of the number of call records for each new CallID.
            Integer callsProductNumber = 1;
            
            //Temporary variable to allow us to restore the call count in case end of the call records list is reached. 
            Integer InitialCallCount=0;
            
            //Keeps track of the calls count while iterating over the call records.
            Integer CallsCount=0;
            
            //Keeps track of new calls per physician
            Integer NewCallCount=0;
            
            //Set to keep track of ranges per physician
            Set<string> RangeSet = new Set<string>();
            
            //Returns a new JSON generator.
            generator = JSON.createGenerator(true);
            
            //Writes the starting marker of a JSON Object.
            generator.writeStartObject();

            //Writes the last call date at the district level
            if(districtLastCallDate != null)
                generator.writeDateTimeField('districtLastCallDate', districtLastCallDate);

            if(CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c!=null){
                generator.writeStringField('startDate1Month',CallPlanningsList[0].Call_Planning__r.Start_Date_1M__c.format(System.Label.MYBZ_DateFormat));
            }
            else
            {
                
                generator.writeNullField('startDate1Month');
            }
            if(CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c!=null){
                generator.writeStringField('startDate3Month',CallPlanningsList[0].Call_Planning__r.Start_Date_3M__c.format(System.Label.MYBZ_DateFormat));
            }
            else
            {
                
                generator.writeNullField('startDate3Month');
            }
            if(CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c!=null){
                generator.writeStringField('startDate6Month',CallPlanningsList[0].Call_Planning__r.Start_Date_6M__c.format(System.Label.MYBZ_DateFormat));
            }
            else
            {    
                generator.writeNullField('startDate6Month');
            }
            if(CallPlanningsList[0].Call_Planning__r.Data_Load_Date__c!=null){
                generator.writeStringField('dataLoadDate',CallPlanningsList[0].Call_Planning__r.Data_Load_Date__c.format(System.Label.MYBZ_DateFormat));
            }
            else
            {    
                generator.writeNullField('dataLoadDate');
            }
            generator.writeFieldName('data');    
            
            generator.writeStartArray();
            
            //Loop to iterate over all call planning records.
            for(Integer CallPlanningCount=0;CallPlanningCount<CallPlanningsList.size();CallPlanningCount++)
            {
                
                //Determine if a new physician is encountered.
                if(!PhysicianID.equals(CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c))
                {
                    
                    
                    //Initializing currentCallID as blank for each new physician
                    currentCallID ='';
                    
                    //Initializing CurrentProduct as blank for each new physician  
                    CurrentProduct='';
                    
                    //Each physician should have their own ranges recorded
                    RangeSet.clear();
                    
                    PhysicianID=CallPlanningsList[CallPlanningCount].Call_Planning__r.Physician_ID__c;
                    
                    //If a new physician record is encountered, start the object else, end the previous object first.
                    if(firstuserflag==1)
                    {
                        
                        generator.writeStartObject();
                        firstuserflag=0;
                    }
                    else
                    {
                        generator.writeEndObject();
                        generator.writeStartObject();
                    }
                    
                    //Write the necessary JSON fields
                    
                    if(CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c!=null){
                        generator.writeStringField(System.Label.MYBZ_FirstName,CallPlanningsList[CallPlanningCount].Call_Planning__r.First_Name__c);
                    }
                    else
                    {    
                        generator.writeNullField(System.Label.MYBZ_FirstName);
                    }
                    if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c!=null){
                        generator.writeStringField(System.Label.MYBZ_LastName,CallPlanningsList[CallPlanningCount].Call_Planning__r.Last_Name__c);
                    }
                    else
                    {
                        
                        generator.writeNullField(System.Label.MYBZ_LastName);
                    }
                    if(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c!=null){
                        generator.writeStringField(System.Label.MYBZ_Tier,String.ValueOf(CallPlanningsList[CallPlanningCount].Call_Planning__r.Tier__c));
                    }
                    else
                    {    
                        
                        generator.writeNullField(System.Label.MYBZ_Tier);
                    }
                    generator.writeFieldName(System.Label.MYBZ_Products);
                    generator.writeStartArray();
                    
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
                            generator.writeStartObject();
                            firstproduct=0;
                        }
                        else
                        {
                            generator.writeEndObject();
                            generator.writeStartObject();
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
                        generator.writeStartObject();
                        firstproduct=0;
                    }
                    else
                    {
                        generator.writeEndObject();
                        generator.writeStartObject();
                    }     
                }
                
                if(newproduct==1)
                {
                    if(CallPlanningsList[CallPlanningCount].Product__r.Name!=null)
                        generator.writeStringField(System.Label.MYBZ_Name,CallPlanningsList[CallPlanningCount].Product__r.Name);
                    
                    else
                        
                        generator.writeNullField(System.Label.MYBZ_Name);
                    
                }
                
                //Adding TRx values to the JSON if they are not null.
                
                if(CallPlanningsList[CallPlanningCount].TRx_Units_1M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastMonth,CallPlanningsList[CallPlanningCount].TRx_Units_1M__c);
                }
                else
                {    
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastMonth);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_3M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths,CallPlanningsList[CallPlanningCount].TRx_Units_3M__c);
                }
                else
                { 
                    
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastThreeMonths);
                }
                if(CallPlanningsList[CallPlanningCount].TRx_Units_6M__c!=null){
                    generator.writeNumberField(System.Label.MYBZ_ScriptsWrittenPastSixMonths,CallPlanningsList[CallPlanningCount].TRx_Units_6M__c);
                }
                else
                {
                    generator.writeNullField(System.Label.MYBZ_ScriptsWrittenPastSixMonths);
                }
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c!=-1)
                    {
                        percentageChangePastMonth=((CallPlanningsList[CallPlanningCount].TRx_Units_1M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_1M__c)*100;
                        percentageChangePastMonth=percentageChangePastMonth.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastMonth=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastMonth,percentageChangePastMonth);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastMonth);
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c!=-1)
                    {
                        percentageChangePastThreeMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_3M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_3M__c)*100;
                        percentageChangePastThreeMonths=percentageChangePastThreeMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastThreeMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastThreeMonths,percentageChangePastThreeMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastThreeMonths);  
                
                if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=null)
                {
                    if(CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=0&&CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c!=-1)
                    {
                        percentageChangePastSixMonths=((CallPlanningsList[CallPlanningCount].TRx_Units_6M__c-CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)/CallPlanningsList[CallPlanningCount].Previous_TRx_Units_6M__c)*100;
                        percentageChangePastSixMonths=percentageChangePastSixMonths.SetScale(2,RoundingMode.CEILING);
                    }
                    else
                    {
                        percentageChangePastSixMonths=0;
                    }
                    generator.writeNumberField(System.Label.MYBZ_PercentageChangePastSixMonths,percentageChangePastSixMonths);
                }
                else
                    generator.writeNullField(System.Label.MYBZ_PercentageChangePastSixMonths);           
                if((CallPlanningCount+1 == CallPlanningsList.size() )||(!PhysicianID.equals(CallPlanningsList[CallPlanningCount+1].Call_Planning__r.Physician_ID__c)))
                {
                    generator.writeEndObject();
                    generator.writeEndArray();
                    
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
                        generator.writeFieldName(System.Label.MYBZ_Calls);
                        generator.writeStartArray();
                        firstCall=1;
                        usercallcount=0;
                        NewCallCount=0;
                        for(integer i = CallsCount; i<CallsList.Size(); i++)
                        {
                            CallsCount = i;
                            
                            //If the call count for a particular physician exceeds five, break out of the loop since only five most recent calls information needs to be passed.
                            if(NewCallCount==5&&(!currentCallID.equals(CallsList[i].Call_ID__c)))
                            {
                                generator.writeEndObject();
                                generator.writeEndArray();
                                generator.writeFieldName('range');
                                generator.writeStartArray();
                                if(!RangeSet.isEmpty())
                                {
                                    for(string range : RangeSet)
                                    {
                                        if(range!=null)
                                        {
                                        generator.writeString(range);
                                        }
                                    }
                                }
                                generator.writeEndArray();
                                break;
                            }
                            
                            //usercallcount++;
                            
                            //Check if the current call record correspond to the current call planning record
                            if(PhysicianID.equals(CallsList[i].Physician_ID__c))
                            {
                            
                                //Keep track of the call range 
                                RangeSet.add(CallsList[i].Range__c);
                                
                                //Check if the current record encountered corresponds to the same call as the previous.
                                if(!currentCallID.equals(CallsList[i].Call_ID__c))
                                {
                                    newCallID=1;
                                    currentCallID= CallsList[i].Call_ID__c;
                                    NewCallCount++;
                                }
                                else
                                {
                                    newCallID=0;
                                }
                                
                                
                                if( newCallID==1 && NewCallCount<6)
                                {
                                    callsProductNumber = 1;
                                    if(firstCall==1)
                                    {
                                        generator.writeStartObject();
                                        firstCall=0;
                                    }
                                    else
                                    {
                                        generator.writeEndObject();
                                        generator.writeStartObject();
                                    }
                                    
                                    //Write the required JSON fields for the new call encountered.
                                    if(CallsList[i].Call_Date__c!=null)
                                        generator.writeStringField(System.Label.MYBZ_Date,CallsList[i].Call_Date__c.format(System.Label.MYBZ_DateFormat));   
                                    
                                    else
                                        
                                        generator.writeNullField(System.Label.MYBZ_Date);
                                    
                                    if(CallsList[i].Call_Type__c!=null)
                                        generator.writeStringField(System.Label.MYBZ_Type,CallsList[i].Call_Type__c);
                                    
                                    else
                                        
                                        generator.writeNullField(System.Label.MYBZ_Type);
                                    
                                }
                                else
                                {
                                    callsProductNumber+=1;
                                    
                                }
                                
                                //Information       
                                if(CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly))
                                {
                                    if(callsProductNumber==2)
                                    {
                                        //usercallcount--;
                                        if(CallsList[i-1].Product__c!=NULL)
                                        {
                                            if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL))
                                            {
                                                generator.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                            }
                                        }   
                                        
                                        
                                    }
                                    else
                                    {
                                        if((CallsList[i].Product__c!=NULL)&&callsProductNumber==1)
                                        {
                                            generator.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                        }
                                    }
                                }
                                
                                
                                if((callsProductNumber<=2)&&(!CallsList[i].Call_Type__c.equals(System.Label.MYBZ_SampleOnly)))
                                {
                                    
                                    if(callsProductNumber==2)
                                    {
                                        usercallcount--;
                                        
                                        if(CallsList[i-1].Product__c!=NULL)
                                        {
                                            if(!CallsList[i].Product__r.Name.equals(CallsList[i-1].Product__r.Name)&&(CallsList[i].Product__c!=NULL)&&(CallsList[i].Product_Position__c==2))
                                            {
                                                generator.writeStringField(System.Label.MYBZ_Product2,CallsList[i].Product__r.Name);
                                            }
                                        }   
                                        
                                        
                                        
                                        
                                    }
                                    else
                                    {
                                        
                                        if((CallsList[i].Product__c!=NULL)&&CallsList[i].Product_Position__c==1)
                                        {
                                            generator.writeStringField(System.Label.MYBZ_Product1,CallsList[i].Product__r.Name);
                                        }
                                    }
                                }
                                if((i+1 == CallsList.size() )||(!PhysicianID.equals(CallsList[i+1].Physician_ID__c)))
                                {
                                    //closing all calls
                                    
                                    generator.writeEndObject();
                                    generator.writeEndArray();
                                    generator.writeFieldName('range');
                                    generator.writeStartArray();
                                    if(!RangeSet.isEmpty())
                                    {
                                        for(string range : RangeSet)
                                        {
                                            if(range!=null)
                                            {
                                            generator.writeString(range);
                                            }
                                        }
                                    }
                                    generator.writeEndArray();
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
            
            
            generator.writeEndObject();
            generator.writeEndArray();
            generator.writeEndObject();
            JsonString = generator.getAsString();
            JsonString=JsonString.replaceall('\n','');
            System.Debug('--CallPlanning' + JsonString);
            Object CallPlanningObject=Json.deserializeUntyped(JsonString);
            return CallPlanningObject;
        }
        catch(Exception E) 
        {
            system.debug('Exception occurred during execution of CallPlanning method' + e);
            GLBL_Error_Log__c errLog = new GLBL_Error_Log__c(Error_Datetime__c= DateTime.Now(),
                                                             Error_Message__c= e.getMessage(),
                                                             Running_User__c = UserInfo.getUserId() ,
                                                             Stack_Trace__c = e.getStackTraceString()); 
            insert errlog;
            return null ;
        }
        
    }
}