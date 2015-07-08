/*
*@ Class Name                                                    : MYBZ_MarketShare
*@ Description                                                   : Controller class to prepare JSONs to share data queried from marketshare objects to Angular JS .
Class for retrieving salesforce data in the form of a string and returning as a JSON object via a remote action.
*@ CreatedBy                                                     : Deloitte Consulting
*@ CreatedOn                                                     : 04-20-2015
*                    
*/

global with Sharing  class MYBZ_MarketShare{

    public MYBZ_MarketShare(MYBZ_Region_Rollup_Controller controller) {

    }    
    
    global static List<MYBZ_Market_Share__c> marketShareList =new List<MYBZ_Market_Share__c>();
    global static List<AggregateResult> marketShareListNational=new List<AggregateResult>();
    global static List<AggregateResult> marketShareListDistrict=new List<AggregateResult>();
    global static List<AggregateResult> marketShareListRegion=new List<AggregateResult>();
    global static Map<string, List<AggregateResult>> mapAggNat  = new Map<string, List<AggregateResult>>();
    global static Map<string, List<AggregateResult>> mapAggdis  = new Map<string, List<AggregateResult>>();
    global static Map<string, List<AggregateResult>> mapAggreg  = new Map<string, List<AggregateResult>>();
    global static List<MYBZ_Market_Share__c> marketShareNationalPercentChange=new List<MYBZ_Market_Share__c>();
    global static List<MYBZ_Market_Share__c> marketSharedistrictPercentChange=new List<MYBZ_Market_Share__c>();
    global static List<MYBZ_Market_Share__c> marketShareRegionPercentChange=new List<MYBZ_Market_Share__c>();
    global static Map<String,Decimal> nationalPercentChange=new Map<String,Decimal>();
    global static Map<String,Decimal> districtPercentChange=new Map<String,Decimal>();
    global static Map<String,Decimal> regionPercentChange=new Map<String,Decimal>();
    global static Decimal TotalTrx=0,TotalTrxDis=0,TotalTrxReg=0;
    global static Decimal TotalDDD=0, TotalDDDDis=0, TotalDDDReg=0;    
    global static String Role;
    global static String GlobalId ;
    global static List<MYBZ_Market_Share__c> ms=new List<MYBZ_Market_Share__c>();
    global static List<MYBZ_Market_Share__c> msobj=new List<MYBZ_Market_Share__c>();
    global static Decimal PercentageChangeDDDUnits=0;
    global object marketShare;
    global static integer flag=1;
    global static id UserId;
    
    /* 
        * @Method Name                    :  getAlignment
        * @Description                    :  Helper method to find the alignment information from given global id 
        * @Return Type                    :  void
        * @Param                          :  none   
        
    */
    global static void  getAlignment(){
        ms= [SELECT Territory__c,District__c,Region__c, Division__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId Limit 1];
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
        if(userObj!=null){
            Role = userObj.MYBZ_Role__c;
          
            GlobalId = userObj.Prsnl_Nbr_GLBL__c;
        }
        
        
    }
    
    
     
      /* 
        * @Method Name                    :  marketShareControllerNonAff
        * @Description                    :  Method used to generate Marketshare JSON for Non-Aff screen when the default callout is made.                                    
        * @Return Type                    :  object
        * @Param                          :  
      */ 
      @RemoteAction
        global static Object marketShareControllerNonAff() { 
            fetchUserInfo();
            system.debug('GlobalId'+GlobalId+'Role'+Role);    
            flag=1;
            getAlignment();
                     
             marketShareList.clear(); 
             
             if( Role !=  System.Label.MYBZ_SuperUser){      
                     marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                               FROM MYBZ_Market_Share__c
                               WHERE Global_Id__c =:GlobalId and LoadIdentifier__c='NON_AFFLTN' 
                               ORDER BY Market__c,Month__c, Year__c ASC ];
             }
             else{
             
                    MYBZ_Region__c reg=[SELECT id FROM MYBZ_Region__c WHERE Name =: System.Label.MYBZ_defaultRegion ];
                    marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                               FROM MYBZ_Market_Share__c
                               WHERE Region__c =:reg.Id and district__c=null and LoadIdentifier__c='NON_AFFLTN' 
                               ORDER BY Market__c,Month__c, Year__c ASC ];
             
             }                  
            if(!ms.isEmpty()){
            marketShareListNational.clear();
            marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  division__c =: ms[0].Division__c and territory__c = null and District__c = null and  Region__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
            marketShareNationalPercentChange.clear();
            
            marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c FROM MYBZ_Market_Share__c WHERE division__c =: ms[0].Division__c and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true  and LoadIdentifier__c='NON_AFFLTN'];
            
            if(Role == System.Label.MYBZ_SalesRepresentative||  Role == System.Label.MYBZ_DistrictSalesManager) {
     
            marketShareListDistrict.clear();
            marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c =: ms[0].District__c and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                      
            
            
            marketShareDistrictPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  FROM MYBZ_Market_Share__c WHERE District__c =: ms[0].District__c and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
            } 
            }
            if(Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser){
                
            marketShareListRegion.clear();
            if(!ms.isEmpty()){
            marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__c =: ms[0].region__c and District__c=null and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            
            marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  FROM MYBZ_Market_Share__c WHERE region__c =: ms[0].region__c and territory__c = null and District__c=null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
                   
                                                      
            }
            
            }
           Object marketShare= marketshareProcessor();
            return marketShare;
    }
    
    /* 
        * @Method Name                    :  accountSummary
        * @Description                    :  Method used to generate Marketshare JSON for Account manager(Affiliation screen) on default account summary screen at account level data.hence no geo alignment considered in where clause                               
        * @Return Type                    :  object
        * @Param                          :  
    */ 
    @RemoteAction
    global static Object accountSummary(){
        fetchUserInfo();
             
        flag=0;
        system.debug('Inside summary');
        // Prioritised Account modification
        List<MYBZ_PriorityAccount__c> lstProrityAccount = new List<MYBZ_PriorityAccount__c>();
        List<String> lstIHSNames = new List<String>();
        List<String> lstPGPNames= new List<String>();        
        
        lstProrityAccount = [SELECT Global_Id__c, LE_ID_IHS__c,LE_ID_PGP__c FROM MYBZ_PriorityAccount__c WHERE Global_Id__c =:GlobalId];
        
        if(!lstProrityAccount.isEmpty()){
            for(MYBZ_PriorityAccount__c objProrityAccount: lstProrityAccount){
                if(objProrityAccount.LE_ID_PGP__c != '' && objProrityAccount.LE_ID_PGP__c != null){
                    lstPGPNames.add(objProrityAccount.LE_ID_PGP__c);
                }else{
                    lstIHSNames.add(objProrityAccount.LE_ID_IHS__c);
                }
            }        
        }
        
        System.debug('@@@IHSNames'+lstIHSNames);
        System.debug('@@@lstPGPNames'+lstPGPNames);
        if(!lstIHSNames.isEmpty() || !lstPGPNames.isEmpty()){
            System.debug('@@@Here');
            marketShareList = [SELECT Id, Region__c, Gross_Margin__c,District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, 
                           TRx__c, LE_ID_PGP__c,PGP__r.ID,system__r.Name,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c,LE_ID_IHS__c,system__r.ID, PGP__r.name
                           FROM MYBZ_Market_Share__c 
                           WHERE LoadIdentifier__c='AFFLTN' and (division__c = null and District__c = null and Region__c = null and territory__c = null)
                           and ((LE_ID_IHS__c in :lstIHSNames and LE_ID_PGP__c = null) or (LE_ID_PGP__c in :lstPGPNames))];
            
        }
        System.debug('@@@AccountSummary'+marketShareList);
        Object marketShare= marketshareProcessor();
        return marketShare;             
                           
    }
        
   
    /* 
        * @Method Name                    :  marketshareControllerNonAffUsingPicker
        * @Description                    :  Method used to generate Marketshare JSON for all users for non affiliation screen .
        * @Return Type                    :  object
        * @Param                          :  String containing the values choosen on picker for territory Name, District Name or Region Name
    */
    @RemoteAction    
    global static Object marketshareControllerNonAffUsingPicker(String region, String district, String territory){
        fetchUserInfo();
        system.debug('****region'+region+ '****district'+ district+'****territory'+ territory);        
        flag=1;
        if(region!='' && region!=null)
             msobj=[SELECT division__c,District__c FROM MYBZ_Market_Share__c WHERE Region__r.Name=:region and district__c=null and territory__c=null and LoadIdentifier__c='NON_AFFLTN' LIMIT 1];
        else if(district!='' && district!=null)
             msobj=[SELECT division__c,District__c FROM MYBZ_Market_Share__c WHERE district__r.Name=:district and territory__c=null and LoadIdentifier__c='NON_AFFLTN' LIMIT 1];
        else
             msobj=[SELECT division__c,district__c FROM MYBZ_Market_Share__c WHERE territory__r.Name=:territory and LoadIdentifier__c='NON_AFFLTN' LIMIT 1];
        
        if(!msobj.isEmpty()){
            marketShareListNational.clear();
            marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: msobj[0].Division__c and territory__c = null and District__c = null and  Region__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
            marketShareNationalPercentChange.clear();                           
            marketShareNationalPercentChange= [SELECT Month_Number__c, Year_Number__c,Product__c, Market__c,percentageChangeFromPreviousMonth__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c FROM MYBZ_Market_Share__c WHERE division__c =: msobj[0].Division__c and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
        
        }
        
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager ||Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && district !=null && district !='' ){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c  FROM MYBZ_Market_Share__c  WHERE District__r.Name =:district AND Territory__c = null and LoadIdentifier__c='NON_AFFLTN' ORDER BY Market__c,Month__c, Year__c ASC ]; 
            marketShareListDistrict.clear();                   
            marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__r.Name =: district and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            marketShareDistrictPercentChange.clear();
            marketShareDistrictPercentChange= [SELECT Month_Number__c, Year_Number__c,Product__c, Market__c,percentageChangeFromPreviousMonth__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  FROM MYBZ_Market_Share__c WHERE District__r.Name =: district and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
            
        }
    
        if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && region !=null && region !='' && (district == null || district == '')){  
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                               FROM MYBZ_Market_Share__c WHERE Region__r.Name =: region AND District__c = null and LoadIdentifier__c='NON_AFFLTN' ORDER BY Market__c,Month__c, Year__c ASC ]; 
                               
            marketShareListRegion.clear();
            marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__r.Name =: region and District__c=null and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
            marketShareRegionPercentChange.clear();
            marketShareRegionPercentChange= [SELECT Month_Number__c, Year_Number__c,Product__c, Market__c,percentageChangeFromPreviousMonth__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  FROM MYBZ_Market_Share__c WHERE region__r.Name =: region and territory__c = null and District__c=null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
    
        }
        
        if((Role == System.Label.MYBZ_MajorMarketManager ||Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  || Role == System.Label.MYBZ_SuperUser) && territory !=null && territory !=''){ 
                    marketShareList.clear();
                    marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, system__r.Name,LE_ID_PGP__c,Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                           FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:territory and LoadIdentifier__c='NON_AFFLTN' ORDER BY Market__c,Month__c, Year__c ASC ]; 
            if(!msobj.isEmpty()){               
                    marketShareListDistrict.clear();                   
                    marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c =: msobj[0].district__c and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
                    marketShareDistrictPercentChange.clear();
                    marketShareDistrictPercentChange= [SELECT Month_Number__c, Year_Number__c,Product__c, Market__c,percentageChangeFromPreviousMonth__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  FROM MYBZ_Market_Share__c WHERE District__c =: msobj[0].district__c and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN' ];
                           
            }                 
 
        }
        
       Object marketShare= marketshareProcessor();
         return marketShare;
    }
    
    
    public static String ihs=' LE_ID_PGP__c=null and LE_ID_IHS__c=:LE_ID_IHS';
    public static String pgps=' LE_ID_PGP__c=:LE_ID_PGP';
    public static String a='AFFLTN';
    public static String division='SELECT division__c FROM MYBZ_Market_Share__c WHERE  ';
    public static String strmarketShareListNational=' and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true and LoadIdentifier__c=\''+a+ '\' and ';
    public static String groupBy=' GROUP BY Month_Number__c, Year_Number__c,Market__c';
    global static String orderBy=' ORDER BY Market__c,Month__c, Year__c ASC';
    
          

    
    
    
    /* 
        * @Method Name                    :  marketshareControllerAffUsingPicker
        * @Description                    :  Method used to generate Marketshare JSON for only Sales Rep for non affiliation screen .
        * @Return Type                    :  object
        * @Param                          :  String containing the values chosen on affiliation picker of affiliation screen for IHS or PGP
    */
    @RemoteAction
    global static Object marketshareControllerAffUsingPicker(String LE_ID_IHS, String LE_ID_PGP){
        system.debug('LE_ID_IHS'+LE_ID_IHS);
        system.debug('LE_ID_PGP' + LE_ID_PGP);
        
        flag=1;
        fetchUserInfo();
        string Terr = '';            
        if(Role == System.Label.MYBZ_SalesRepresentative){
           getAlignment();
           if(!ms.isEmpty()){
              Terr = ms[0].Territory__c;
           }
        }
      
        Object marketShare= marketshareControllerAffUsingPickerSuperUser(LE_ID_IHS,LE_ID_PGP,'','', Terr);
        return marketShare;
    
    }
    
    
    /* 
        * @Method Name                    :  marketshareControllerAffUsingPickerSuperUser
        * @Description                    :  Method used to generate Marketshare JSON for all users for affiliation screen .
        * @Return Type                    :  object
        * @Param                          :  String containing the values chosen on geo picker of affiliation screen for territory Name, District Name or Region Name 
                                             string containing the values chosen on affiliation picker of affiliation screen for IHS or PGP
   */
   @RemoteAction
   global static  Object marketshareControllerAffUsingPickerSuperUser(String LE_ID_IHS , String LE_ID_PGP, String region, String district, String terr){
   
   System.debug('@@IHS'+LE_ID_IHS+'@@PGP'+LE_ID_PGP+'@@Reg'+region+'@@District'+district+'@@terr'+terr);
            
        fetchUserInfo();
        flag=1;
        
        List<MYBZ_Territory__c> lstTerritory = new List<MYBZ_Territory__c>();
        List<MYBZ_District__c> lstDistrict = new List<MYBZ_District__c>();
        List<MYBZ_Region__c> lstRegion = new List<MYBZ_Region__c>();
                         
        if(!String.isBlank(LE_ID_IHS)){
            marketShareList.clear();
            marketShareList = [SELECT Id,Region__c,Gross_Margin__c,DDD_Dollars__c,District__c,Month__c,Year__c,
                                      territory__c,Global_Id__c, Owner__c,Market__c,percentageChangeFromPreviousMonth__c,lillyProduct__c, 
                                      Month_Number__c, Year_Number__c, Product__r.Name, TRx__c,system__r.Name, LE_ID_IHS__c, LE_ID_PGP__c,Previous_Month_TRx__c,
                                      PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,DDD_Units__c,Previous_DDD_Units__c, 
                                      Previous_DDD_Dollars__c FROM MYBZ_Market_Share__c WHERE LE_ID_IHS__c =:LE_ID_IHS  and LE_ID_PGP__c = null and LoadIdentifier__c='AFFLTN' and Division__c = null and Region__c = null and District__c =null and Territory__c = null];
        }
        
        if(!String.isBlank(LE_ID_PGP)){
            marketShareList.clear();
            marketShareList = [SELECT Id,Region__c,Gross_Margin__c,DDD_Dollars__c,District__c,Month__c,Year__c,
                                      territory__c,Global_Id__c, Owner__c,Market__c,percentageChangeFromPreviousMonth__c,lillyProduct__c, 
                                      Month_Number__c, Year_Number__c, Product__r.Name, TRx__c,system__r.Name, LE_ID_IHS__c, LE_ID_PGP__c,Previous_Month_TRx__c,
                                      PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,DDD_Units__c,Previous_DDD_Units__c, 
                                      Previous_DDD_Dollars__c FROM MYBZ_Market_Share__c WHERE LE_ID_PGP__c =:LE_ID_PGP  and LoadIdentifier__c='AFFLTN' and Division__c = null and Region__c = null and District__c =null and Territory__c = null];
        }
        
        if(!String.isBlank(terr)){
            lstTerritory = [SELECT id, name, State__c, State__r.Name, 
                                    State__r.Region__c, State__r.Region__r.Name, 
                                    State__r.Region__r.Parent__c FROM MYBZ_Territory__c
                                    WHERE name = : terr limit 1];
                                    
            if(!lstTerritory.isEmpty()){
                if(lstTerritory[0].State__c != null){
                    marketShareListDistrict.clear();
                    marketShareDistrictPercentChange.clear();
                    marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  District__c =: lstTerritory[0].State__c and LE_ID_PGP__c = null and LE_ID_IHS__c =null and territory__c = null  and LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c];
                          
                
                    marketShareDistrictPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  
                                                            FROM MYBZ_Market_Share__c WHERE District__c =: lstTerritory[0].State__c 
                                                            and territory__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and lillyProduct__c=true and LoadIdentifier__c='AFFLTN'];
                    
                }
                if(lstTerritory[0].State__r.Region__c !=null){
                    marketShareListRegion.clear();
                    marketShareRegionPercentChange.clear();
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstTerritory[0].State__r.Region__c and District__c=null and territory__c = null  
                                                          and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstTerritory[0].State__r.Region__c and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                                
                }
                if(lstTerritory[0].State__r.Region__r.Parent__c !=null){
                    marketShareListNational.clear();
                    marketShareNationalPercentChange.clear();
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstTerritory[0].State__r.Region__r.Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c FROM MYBZ_Market_Share__c
                                                               WHERE division__c =: lstTerritory[0].State__r.Region__r.Parent__c and territory__c = null and 
                                                               District__c = null and  Region__c = null  and lillyProduct__c=true  
                                                               and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                    
                }
            }
            
        }
        
        if(!String.isBlank(district)){
            lstDistrict = [SELECT id, Region__c, Region__r.Name, Region__r.Parent__c  FROM MYBZ_District__c WHERE name =:district limit 1];
            
            if(!lstDistrict.isEmpty()){
                if(lstDistrict[0].id != null){
                    marketShareListDistrict.clear();
                    marketShareDistrictPercentChange.clear();
                    marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  District__c =: lstDistrict[0].id and LE_ID_PGP__c = null and LE_ID_IHS__c =null and territory__c = null  and LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c];
                          
                
                    marketShareDistrictPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  
                                                            FROM MYBZ_Market_Share__c WHERE District__c =: lstDistrict[0].id 
                                                            and territory__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and lillyProduct__c=true and LoadIdentifier__c='AFFLTN'];
                    
                }
                if(lstDistrict[0].Region__c != null){
                    marketShareListRegion.clear();
                    marketShareRegionPercentChange.clear();
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstDistrict[0].Region__c and District__c=null and territory__c = null  
                                                          and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstDistrict[0].Region__c and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                                
                }
                 if(lstDistrict[0].Region__r.Parent__c != null){
                    marketShareListNational.clear();
                    marketShareNationalPercentChange.clear();
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstDistrict[0].Region__r.Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c FROM MYBZ_Market_Share__c
                                                               WHERE division__c =: lstDistrict[0].Region__r.Parent__c and territory__c = null and 
                                                               District__c = null and  Region__c = null  and lillyProduct__c=true  
                                                               and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                    
                }
                    
            }
                
        }
        if(!String.isBlank(region)){    
            lstRegion = [SELECT id, name, Parent__c FROM MYBZ_Region__c WHERE name =:region limit 1];
            
            if(!lstRegion.isEmpty()){
                if(lstRegion[0].id != null){
                    marketShareListRegion.clear();
                    marketShareRegionPercentChange.clear();
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstRegion[0].id  and District__c=null and territory__c = null  
                                                          and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c  
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstRegion[0].id  and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                                
                }
                 if(lstRegion[0].Parent__c != null){
                    marketShareListNational.clear();
                    marketShareNationalPercentChange.clear();
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(DDD_Units__c) TotDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstRegion[0].Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c FROM MYBZ_Market_Share__c
                                                               WHERE division__c =: lstRegion[0].Parent__c and territory__c = null and 
                                                               District__c = null and  Region__c = null  and lillyProduct__c=true  
                                                               and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                    
                }
            }
                
        }
       Object marketShare= marketshareProcessor();
        return marketShare;
   }
   
   /* 
        * @Method Name                    :  calculateNational
        * @Description                    :  Method used to calculate the national/region/district level percentage change for each metric TRx/DDD units for 
                                             each product for a month and year.
        * @Return Type                    :  void
        * @Param                          :  none
   */
   global static void calculateNational(){
        mapAggNat.clear();
        mapAggReg.clear();
        mapAggDis.clear();
        if(!marketShareRegionPercentChange.isEmpty()){
            
            for(MYBZ_Market_Share__c mo: marketShareRegionPercentChange){
                string markProdMonthYearMS =  mo.Market__c+mo.product__c+mo.Month_Number__c+mo.Year_Number__c;   
                if(mo.Trx__c != null){
                    regionPercentChange.put(markProdMonthYearMS,mo.percentageChangeFromPreviousMonth__c);
                }else{
                    regionPercentChange.put(markProdMonthYearMS,mo.PercentageChangeDDDunits__c);
                }
            }
        }
        if(!marketSharedistrictPercentChange.isEmpty()){
            
            for(MYBZ_Market_Share__c mo: marketSharedistrictPercentChange){
                string markProdMonthYearMS =  mo.Market__c+mo.product__c+mo.Month_Number__c+mo.Year_Number__c;                
                if(mo.Trx__c != null){
                    districtPercentChange.put(markProdMonthYearMS,mo.percentageChangeFromPreviousMonth__c);
                }else{
                    districtPercentChange.put(markProdMonthYearMS,mo.PercentageChangeDDDunits__c);
                }
            }
        }
        if(!marketShareNationalPercentChange.isEmpty()){
           
            for(MYBZ_Market_Share__c mo: marketShareNationalPercentChange){
                string markProdMonthYearMS =  mo.Market__c+mo.product__c+mo.Month_Number__c+mo.Year_Number__c;                
                if(mo.Trx__c != null){
                    nationalPercentChange.put(markProdMonthYearMS,mo.percentageChangeFromPreviousMonth__c);
                }else{
                    nationalPercentChange.put(markProdMonthYearMS,mo.PercentageChangeDDDunits__c);
                }
            }
        }
        if(!marketShareListRegion.isEmpty()){
            
            for(AggregateResult Agg : marketShareListRegion ) {
            string markMonthYear = (String)Agg.get('mar') + (String)Agg.get('mon') + (String)Agg.get('yr');
            if(mapAggReg.containsKey((markMonthYear))) {            
             mapAggReg.get(markMonthYear).add(Agg);
            }else {
             mapAggReg.put(markMonthYear , new list<AggregateResult> {Agg});
            }
          }  
        }  
         if(!marketShareListNational.isEmpty()){
             
             for(AggregateResult Agg : marketShareListNational ) {
            string markMonthYear = (String)Agg.get('mar') + (String)Agg.get('mon') + (String)Agg.get('yr');
            if(mapAggNat.containsKey((markMonthYear))) {            
             mapAggNat.get(markMonthYear).add(Agg);
            }else {
            mapAggNat.put(markMonthYear , new list<AggregateResult> {Agg});
            }
          }    
   
        }
        
        if(!marketShareListDistrict.isEmpty()){
            
             for(AggregateResult Agg : marketShareListDistrict ) {
            string markMonthYear = (String)Agg.get('mar') + (String)Agg.get('mon') + (String)Agg.get('yr');
            if(mapAggDis.containsKey((markMonthYear))) {            
             mapAggDis.get(markMonthYear).add(Agg);
            }else {
            mapAggDis.put(markMonthYear , new list<AggregateResult> {Agg});
            }
          }  
          
        }
        
    }
    
    /* 
        * @class Name                    :  wrapperpriorityaccounts
        * @Description                    :  wrapper class to hold system or PGP ids which is prioritised for an Account manager.Used
                                             to display AccountSummary
        * @Return Type                    :  void
        * @Param                          :  none
   */
    global class wrapperpriorityaccounts{
        String systemName;
        String pgpName;
        wrapperpriorityaccounts(){       
       }
    }    
    
    /* 
        * @Method Name                    :  marketshareProcessor
        * @Description                    :  Processor method utilised in every call out to form the marketshare JSON
        * @Return Type                    :  object
        * @Param                          :  none
   */
    global static Object marketshareProcessor() {  
        nationalPercentChange.clear();
        districtPercentChange.clear();
        regionPercentChange.clear();
        String JsonString;
        JSONGenerator generator= JSON.createGenerator(true);
        calculateNational();
         // MS record per product for a single PGP market,year,month and product
            map<string , map<String, map<String, map<String, map< string , MYBZ_Market_Share__c>>>>> mapMarketYearMonthProductMarketObj = new map<string,map<string, map<String, map<String, map< string , MYBZ_Market_Share__c >>>>>();    
            
            map<string, Decimal> totalTRxperMonth = new map<string, Decimal>();
            
            map<String, map<String, map<String, map< string , MYBZ_Market_Share__c>>>> mapMSData=new map<String, map<String, map<String, map< string , MYBZ_Market_Share__c>>>>();
            
            map<String,wrapperpriorityaccounts> mapPgpIhs=new map<String,wrapperpriorityaccounts>();
                // creating a map to hold years per marketshare name 
                if(!marketShareList.isEmpty()){
                    for(MYBZ_Market_Share__c mObj  : marketShareList){ 
                        if(flag==0){ //acccount summary begins
                          if(mobj.PGP__r.ID != null){ // its a prioritised PGP
                                    if( mapMarketYearMonthProductMarketObj.containsKey(mobj.PGP__r.ID)){
                                        system.debug('++++mobj.system__r.Name' +mobj.system__r.Name + '+++mobj.PGP__r.Name' +mobj.PGP__r.Name);
                                        wrapperpriorityaccounts wrapAcc = new wrapperpriorityaccounts();
                                        wrapAcc.systemName = mobj.system__r.Name;
                                        wrapAcc.pgpName =mobj.PGP__r.Name;
                                        mapPgpIhs.put(mobj.PGP__r.ID,wrapAcc);
                                        system.debug('+++wrapAcc' + wrapAcc);    
                                       if(mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).containsKey(mObj.Market__c)){
                                           if( mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).get(mObj.Market__c).containsKey(mObj.Month_Number__c)) {
                                             if(mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).containsKey(mObj.Year_Number__c)){
                                                if(mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).containsKey(mObj.Product__r.name))                                  
                                                        mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj); 
                                                else                                        
                                                        mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj);
                                             }
                                             else
                                                mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );
                                                    
                                           }    
                                          else{ 
                                                 
                                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );  
                                                
                                                mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).get(mObj.Market__c).put(mObj.Month_Number__c,yearProdMap);
                                                
                                          } 
                                       }          
                                    else{                                         
                                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );                                  
                                                
                                                map<string,map<string, map<string, MYBZ_Market_Share__c>>> monthyearProdMap =  new map<string,map<string, map<string, MYBZ_Market_Share__c>>>();
                                                monthyearProdMap .put(mObj.Month_Number__c,yearProdMap);
                                                
                                                mapMarketYearMonthProductMarketObj.get(mobj.PGP__r.ID).put(mObj.Market__c, monthyearProdMap);
                                         
                                       }
                                    }    
                                    else{
                                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );                                  
                                                
                                                map<string,map<string, map<string, MYBZ_Market_Share__c>>> monthyearProdMap =  new map<string,map<string, map<string, MYBZ_Market_Share__c>>>();
                                                monthyearProdMap .put(mObj.Month_Number__c,yearProdMap);
                                                
                                                map<string,map<string,map<string, map<string, MYBZ_Market_Share__c>>>> marketmonthYearMap = new map<string,map<string,map<string, map<string, MYBZ_Market_Share__c>>>>();
                                                marketmonthYearMap.put(mObj.Market__c, monthyearProdMap);
                                                
                                                mapMarketYearMonthProductMarketObj.put(mobj.PGP__r.ID, marketmonthYearMap);   
                                                wrapperpriorityaccounts wrapAcc = new wrapperpriorityaccounts();
                                                wrapAcc.systemName = mobj.system__r.Name;
                                                wrapAcc.pgpName =mobj.PGP__r.Name;
                                                mapPgpIhs.put(mobj.PGP__r.ID,wrapAcc);

                                    }                   
                     } 
                        
                   else{ // if its a prioritised system
                       if( mapMarketYearMonthProductMarketObj.containsKey(mobj.System__r.ID)){
                                       wrapperpriorityaccounts wrapAcc = new wrapperpriorityaccounts();
                                        wrapAcc.systemName = mobj.system__r.Name;
                                        wrapAcc.pgpName =null;
                                        mapPgpIhs.put(mobj.System__r.ID,wrapAcc);
                                       if(mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).containsKey(mObj.Market__c)){
                                           if( mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).get(mObj.Market__c).containsKey(mObj.Month_Number__c)) {
                                             if(mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).containsKey(mObj.Year_Number__c)){
                                                if(mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).containsKey(mObj.Product__r.name))                                  
                                                        mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj); 
                                                else                                        
                                                        mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj);
                                             }
                                             else
                                                mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).get(mObj.Market__c).get(mObj.Month_Number__c).put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );
                                                    
                                           }    
                                          else{ 
                                                 
                                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );  
                                                
                                                mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).get(mObj.Market__c).put(mObj.Month_Number__c,yearProdMap);
                                                
                                          } 
                                       }          
                                    else{                                         
                                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );                                  
                                                
                                                map<string,map<string, map<string, MYBZ_Market_Share__c>>> monthyearProdMap =  new map<string,map<string, map<string, MYBZ_Market_Share__c>>>();
                                                monthyearProdMap .put(mObj.Month_Number__c,yearProdMap);
                                                
                                                mapMarketYearMonthProductMarketObj.get(mobj.System__r.ID).put(mObj.Market__c, monthyearProdMap);
                                         
                                       }
                                    }    
                                    else{
                                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );                                  
                                                
                                                map<string,map<string, map<string, MYBZ_Market_Share__c>>> monthyearProdMap =  new map<string,map<string, map<string, MYBZ_Market_Share__c>>>();
                                                monthyearProdMap .put(mObj.Month_Number__c,yearProdMap);
                                                
                                                map<string,map<string,map<string, map<string, MYBZ_Market_Share__c>>>> marketmonthYearMap = new map<string,map<string,map<string, map<string, MYBZ_Market_Share__c>>>>();
                                                marketmonthYearMap.put(mObj.Market__c, monthyearProdMap);
                                                
                                                mapMarketYearMonthProductMarketObj.put(mobj.System__r.ID, marketmonthYearMap);   
                                                wrapperpriorityaccounts wrapAcc = new wrapperpriorityaccounts();
                                                wrapAcc.systemName = mobj.system__r.Name;
                                                wrapAcc.pgpName =null;
                                                mapPgpIhs.put(mobj.System__r.ID,wrapAcc);

                                    }

                   }
                        }//account summary ends
                     else{
                       // non account summary begin
                      if(mapMSData.containsKey(mObj.Market__c)){
                               if( mapMSData.get(mObj.Market__c).containsKey(mObj.Month_Number__c)) {
                                 if(mapMSData.get(mObj.Market__c).get(mObj.Month_Number__c).containsKey(mObj.Year_Number__c)){
                                    if(mapMSData.get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).containsKey(mObj.Product__r.name))                                  
                                            mapMSData.get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj); 
                                    else                                        
                                            mapMSData.get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj);
                                 }
                                 else
                                    mapMSData.get(mObj.Market__c).get(mObj.Month_Number__c).put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );
                                        
                               }    
                              else{
                                    map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                    yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );  
                                    
                                    mapMSData.get(mObj.Market__c).put(mObj.Month_Number__c,yearProdMap);
                                 
                              } 
                           }          
                        else{                                         
                                    map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                    yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );                                  
                                    
                                    map<string,map<string, map<string, MYBZ_Market_Share__c>>> monthyearProdMap =  new map<string,map<string, map<string, MYBZ_Market_Share__c>>>();
                                    monthyearProdMap .put(mObj.Month_Number__c,yearProdMap);
                                    
                                    mapMSData.put(mObj.Market__c, monthyearProdMap);
                             
                           } 
                
                    mapMarketYearMonthProductMarketObj.put(null,mapMSData);
                    
                
                }
                            
                 }//if closes 
               }
               system.debug('mapPgpIhs'+mapPgpIhs);
                generator.writeStartObject();
                if(flag==0){
                generator.writeFieldName(System.Label.Mybz_summaryData);
                generator.writeStartObject();
                generator.writeFieldName(System.Label.Mybz_accounts);
                 generator.writeStartArray();
                }
                system.debug('mapMarketYearMonthProductMarketObj'+mapMarketYearMonthProductMarketObj);
                 for( string pgp : mapMarketYearMonthProductMarketObj.keyset()){
                    //generator.writeFieldName(System.Label.Mybz_summaryData);
                    if(flag==0){ // Account Summary block
                       generator.writeStartObject();
                    
                        if(mapPgpIhs.get(pgp) !=null){ 
                             if(mapPgpIhs.get(pgp).pgpName != null && mapPgpIhs.get(pgp).pgpName != ''){// PGP to be written
                                generator.writeStringField(System.Label.Mybz_name,mapPgpIhs.get(pgp).pgpName);
                                if(mapPgpIhs.get(pgp).systemName != null)
                                 generator.writeStringField(System.Label.mybz_associationName,mapPgpIhs.get(pgp).systemName);
                                else
                                 generator.writeNullField(System.Label.mybz_associationName);   
                             }                       
                             else{      // SYSTEM is written                    
                                if(mapPgpIhs.get(pgp).systemName != null){
                                 generator.writeStringField(System.Label.Mybz_name,mapPgpIhs.get(pgp).systemName);    
                                 generator.writeStringField(System.Label.mybz_associationName,mapPgpIhs.get(pgp).systemName);
                                } 
                                else{
                                 generator.writeNullField(System.Label.Mybz_name);       
                                 generator.writeNullField(System.Label.mybz_associationName);   
                                } 
                             }
                                
                        }            
                 }          
                  generator.writeFieldName(System.Label.Mybz_markets);
                  generator.writeStartArray();
                  system.debug('mapMarketYearMonthProductMarketObj'+mapMarketYearMonthProductMarketObj);
                 for (String Market: mapMarketYearMonthProductMarketObj.get(pgp).keyset()){
                      generator.writeStartObject();
                      generator.writeStringField(System.Label.MYBZ_market,Market);
                      
                       generator.writeFieldName(System.Label.MYBZ_data);
                       generator.writeStartArray();
                      for( String year : mapMarketYearMonthProductMarketObj.get(pgp).get(Market).keyset()){
                          
                         for(String month : mapMarketYearMonthProductMarketObj.get(pgp).get(Market).get(year).keyset()){
                            
                             system.debug('@@@Year'+year);
                             system.debug('@@@Month'+Month);
                             system.debug('@@@Market'+market);
                             generator.writeStartObject();
                             generator.writeStringField(System.Label.MYBZ_month,Year);
                             generator.writeStringField(System.Label.MYBZ_Year,month);
                             generator.writeFieldName(System.Label.MYBZ_Products);
                             generator.writeStartArray();
                             for(string product : mapMarketYearMonthProductMarketObj.get(pgp).get(Market).get(year).get(month).keyset()){
                                 
                              MYBZ_Market_Share__c marketShareObj = mapMarketYearMonthProductMarketObj.get(pgp).get(Market).get(year).get(month).get(product);
                                generator.writeStartObject();
                                
                                  if(marketShareObj.TRx__c !=null){
                                     generator.writeNumberField(System.Label.MYBZ_trx,marketShareObj.TRx__c);
                                  }
                                  else{    
                                     generator.writeNullField(System.Label.MYBZ_trx);
                                  }
                                  
                                  if(marketShareObj.percentageChangeFromPreviousMonth__c != null){
                                      generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,marketShareObj.percentageChangeFromPreviousMonth__c);
                                  }
                                  else{
                                      generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx);
                                  }
                                
                                  generator.writeStringField(System.Label.MYBZ_productName,marketShareObj.Product__r.Name);
                                  generator.writeBooleanField(System.Label.MYBZ_lillyProduct,marketShareObj.lillyProduct__c);
                                  
                                      if(marketShareObj.DDD_Units__c!=null){
                                            generator.writeNumberField(System.Label.MYBZ_dddUnits,marketShareObj.DDD_Units__c);
                                      }
                                      else{    
                                            generator.writeNullField(System.Label.MYBZ_dddUnits);
                                      }
                                      
                                      if(marketShareObj.Previous_DDD_Units__c != null){
                                          generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,marketShareObj.PercentageChangeDDDunits__c);
                                      }
                                      else{
                                          generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                                      }
                                      if(marketShareObj.Previous_DDD_Dollars__c  != null){
                                          generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,marketShareObj.PercentageChangeDDDDollars__c);
                                      }
                                      else{
                                          generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                                      }
                                       if(marketShareObj.DDD_Dollars__c!=null )
                                         generator.writeNumberField(System.Label.MYBZ_dddDollars,marketShareObj.DDD_Dollars__c);   
                                    else 
                                        generator.writeNullField(System.Label.MYBZ_dddDollars);
                                  
                                string markMonthYearMS =  marketShareObj.Market__c+marketShareObj.Month_Number__c+marketShareObj.Year_Number__c; 
                                  
                                if(marketShareObj.Gross_Margin__c!=null )
                                     generator.writeNumberField(System.Label.MYBZ_grossMargins,marketShareObj.Gross_Margin__c);   
                                else 
                                    generator.writeNullField(System.Label.MYBZ_grossMargins);
                                
                               
                                
                        
                        //system.debug(marketShareObj.product__c+''+product);
                        string markProdMonthYearMS =  marketShareObj.Market__c+marketShareObj.product__c+marketShareObj.Month_Number__c+marketShareObj.Year_Number__c;
                    
                        system.debug('nationalPercentChange' + nationalPercentChange);
                        system.debug('regionPercentChange' + regionPercentChange);
                        system.debug('districtPercentChange' + districtPercentChange);
                    system.debug('mapAggNat'+mapAggNat);
                    system.debug('mapAggNat'+mapAggReg);
                    system.debug('mapAggNat'+mapAggDis);
                    if(flag==1){
                    generator.writeFieldName(System.Label.MYBZ_geolevelcomparison);  
                    generator.writeStartObject();
                    generator.writeFieldName(System.Label.MYBZ_National);                          
                    generator.writeStartObject();
                    if(marketShareObj.lillyProduct__c){
                        if(!mapAggNat.isempty() ) {
                            if(mapAggNat.get(markMonthYearMS)!=null){
                                if(mapAggNat.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                    TotalTrx=(Decimal)mapAggNat.get(markMonthYearMS).get(0).get('TotTrx');
                                if(mapAggNat.get(markMonthYearMS).get(0).get('TotDDD')!=null)
                                    TotalDDD=(Decimal)mapAggNat.get(markMonthYearMS).get(0).get('TotDDD');  
                            }
                        }
                        System.debug('@@@TotalTrx'+TotalTrx);
                        System.debug('@@@TotalDDD'+TotalDDD);  
                        if(TotalTrx!=0 && marketShareObj.Trx__c != null){
                                generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.Trx__c/TotalTrx) );
                                system.debug('+++objNatWrapper.Percentage' + (marketShareObj.Trx__c/TotalTrx) );
                                if(nationalPercentChange.get(markProdMonthYearMS)!=null)
                                    generator.writeNumberField(System.Label.MYBZ_PercentageChange,nationalPercentChange.get(markProdMonthYearMS));
                                else
                                     generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                
                        }else if(TotalDDD!=0 && marketShareObj.DDD_Units__c != null){
                                generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.DDD_Units__c/TotalDDD) );
                                system.debug('+++objNatWrapper.Percentage' + (marketShareObj.DDD_Units__c/TotalDDD) );
                                if(nationalPercentChange.get(markProdMonthYearMS)!=null)
                                    generator.writeNumberField(System.Label.MYBZ_PercentageChange,nationalPercentChange.get(markProdMonthYearMS));
                                else
                                     generator.writeNullField(System.Label.MYBZ_PercentageChange);      
                                    
                        }else {
                                generator.writeNullField(System.Label.MYBZ_Percentage);
                                generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        }
                    }else {
                            generator.writeNullField(System.Label.MYBZ_Percentage);
                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                    } 
                     generator.writeEndObject(); 
                    
                    generator.writeFieldName(System.Label.MYBZ_District);                          
                    generator.writeStartObject();
                    if(marketShareObj.lillyProduct__c){
                        if(!mapAggDis.isempty() ){
                            if(mapAggDis.get(markMonthYearMS)!=null){
                                if(mapAggDis.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                    TotalTrxDis=(Decimal)mapAggDis.get(markMonthYearMS).get(0).get('TotTrx');
                                if(mapAggDis.get(markMonthYearMS).get(0).get('TotDDD')!=null)
                                    TotalDDDDis=(Decimal)mapAggDis.get(markMonthYearMS).get(0).get('TotDDD');
                            }                        
                        }    
                    System.debug('@@@TotalTrxDis'+TotalTrxDis);
                    System.debug('@@@TotalDDDDis'+TotalDDDDis);     
                    if(TotalTrxDis!=0 && marketShareObj.Trx__c != null){
                           generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.Trx__c/TotalTrxDis) );
                            
                            if(districtPercentChange.get(markProdMonthYearMS)!=null)
                                generator.writeNumberField(System.Label.MYBZ_PercentageChange,districtPercentChange.get(markProdMonthYearMS));
                            else
                                 generator.writeNullField(System.Label.MYBZ_PercentageChange);
                            
                    }else if(TotalDDDDis!=0 && marketShareObj.DDD_Units__c != null){
                            generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.DDD_Units__c/TotalDDDDis));
                            
                            if(districtPercentChange.get(markProdMonthYearMS)!=null)
                                generator.writeNumberField(System.Label.MYBZ_PercentageChange,districtPercentChange.get(markProdMonthYearMS));
                            else
                                 generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        }   
                        else {
                            generator.writeNullField(System.Label.MYBZ_Percentage);
                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        }
                    } else {
                            generator.writeNullField(System.Label.MYBZ_Percentage);
                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                    }
                        generator.writeEndObject(); 
                        
                         generator.writeFieldName(System.Label.MYBZ_Region);                          
                        generator.writeStartObject();
                    if(marketShareObj.lillyProduct__c){
                        if(!mapAggReg.isempty() ){
                            if(mapAggReg.get(markMonthYearMS)!=null){
                                if(mapAggReg.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                    TotalTrxReg=(Decimal)mapAggReg.get(markMonthYearMS).get(0).get('TotTrx');
                                if(mapAggReg.get(markMonthYearMS).get(0).get('TotDDD')!=null)
                                    TotalDDDReg=(Decimal)mapAggReg.get(markMonthYearMS).get(0).get('TotDDD');
                            }
                        }
                    System.debug('@@@TotalTrxReg'+TotalTrxReg);
                    System.debug('@@@TotalDDDReg'+TotalDDDReg);           
                    if(TotalTrxReg!=0 && marketShareObj.Trx__c != null){
                           generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.Trx__c/TotalTrxReg) );
                          
                            if(regionPercentChange.get(markProdMonthYearMS)!=null)
                                generator.writeNumberField(System.Label.MYBZ_PercentageChange,regionPercentChange.get(markProdMonthYearMS));
                            else
                                 generator.writeNullField(System.Label.MYBZ_PercentageChange);                        
                            
                    } else if (TotalDDDReg!=0 && marketShareObj.DDD_Units__c != null){
                            generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.DDD_Units__c/TotalDDDReg) );
                          
                            if(regionPercentChange.get(markProdMonthYearMS)!=null)
                                generator.writeNumberField(System.Label.MYBZ_PercentageChange,regionPercentChange.get(markProdMonthYearMS));
                            else
                                 generator.writeNullField(System.Label.MYBZ_PercentageChange);
                            
                    }else{
                            generator.writeNullField(System.Label.MYBZ_Percentage);
                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                         }
                    }
                        else {
                            generator.writeNullField(System.Label.MYBZ_Percentage);
                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        }
                    
                        generator.writeEndObject();
                        generator.writeEndObject();
                    }
                        generator.writeEndObject(); 
                        }
                        generator.writeEndArray();  
                        generator.writeEndObject();// month object ends
                                   
                               }
                                //year ends
                             }
                             generator.writeEndArray();
                            generator.writeEndObject();  //market ends
                         }
                         if(flag==0){
                         generator.writeEndArray();
                          generator.writeEndObject();
                         }   
                 }
                     if(flag==0){
                       generator.writeEndArray();
                        generator.writeEndObject();
                        
                         }
                        JsonString = generator.getAsString();
                       System.debug('--MarketShare'+JsonString);
                        Object marketShare = Json.deserializeUntyped(JsonString); 
                        return marketShare;
                   
                      }
                     public MYBZ_MarketShare(){
                   
                     }
     }