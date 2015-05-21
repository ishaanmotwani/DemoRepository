global with Sharing  class MYBZ_MarketShare{

    global static Integer j,k,m,n;
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
    //global static MYBZ_Region__c reg;
    global static String Role;
    global static String GlobalId ;
    global static MYBZ_Market_Share__c ms;
    global static Decimal PercentageChangeDDDUnits=0;
    
    global static integer flag=1;
     global static id UserId;
    
    global static void getAlignment(){
        ms= [select Territory__c,District__c,Region__c, Division__c from MYBZ_Market_Share__c where Global_Id__c =:GlobalId Limit 1];
    }
       
     global static void fetchUserInfo(){
        UserId = UserInfo.getUserId();      
        User userObj = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId];
        if(userObj!=null){
            Role = userObj.MYBZ_Role__c;
          
            GlobalId = userObj.Prsnl_Nbr_GLBL__c;
            
            //uname=userObj.name;
        }
        
        
    }
    //Non-Aff and by defualt
      @RemoteAction 
    global static void marketShareControllerNonAff() { 
            fetchUserInfo();
                 
            flag=1;
            getAlignment();
            
             marketShareList.clear();          
             marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                               FROM MYBZ_Market_Share__c 
                               WHERE Global_Id__c =:GlobalId and LoadIdentifier__c='NA' 
                               ORDER BY Market__c,Month__c, Year__c ASC];
                                 
            marketShareListNational.clear();
            marketShareListNational = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  division__c =: ms.Division__c and territory__c = null and District__c = null and  Region__c = null  and LoadIdentifier__c='NA' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
            marketShareNationalPercentChange.clear();
            marketShareNationalPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =: ms.Division__c and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true  and LoadIdentifier__c='NA'];
            
            if(Role == System.Label.MYBZ_SalesRepresentative||  Role == System.Label.MYBZ_DistrictSalesManager) {
     
            marketShareListDistrict.clear();
            marketShareListDistrict = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c =: ms.District__c and territory__c = null  and LoadIdentifier__c='NA' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            
            marketShareDistrictPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__c =: ms.District__c and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NA'];
            
            }
            if(Role == System.Label.MYBZ_MajorMarketManager){
                
            marketShareListRegion.clear();
            marketShareListRegion = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__c =: ms.region__c and District__c=null and territory__c = null  and LoadIdentifier__c='NA' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            
            marketShareRegionPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE region__c =: ms.region__c and territory__c = null and District__c=null  and lillyProduct__c=true and LoadIdentifier__c='NA'];
                   
                                                      
            }
            
          /*  if(Role == System.Label.MYBZ_SuperUser){
                marketShareList.clear();
                MYBZ_Region__c reg=[Select id from MYBZ_Region__c where Name =: System.Label.MYBZ_defaultRegion ];
     
                marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                               FROM MYBZ_Market_Share__c  WHERE Region__c =:reg.Id and district__c=null and LoadIdentifier__c='NA' ORDER BY Market__c,Month__c, Year__c ASC];
      
            }*/
            marketshareProcessor();          
    }
    
    
    
    //Aff and by default
    @RemoteAction 
   /* global static void marketshareControllerAffiliation(){
       
            MYBZ_Market_Share__c objSys=[SELECT system__r.Name FROM MYBZ_Market_Share__c WHERE Global_Id__c =: GlobalId ORDER BY system__r.Name LIMIT 1];
            system.debug('sys'+objSys.system__r.Name );
          // MYBZ_Region__c reg=[Select id from MYBZ_Region__c where Name =: System.Label.MYBZ_defaultRegion ];
           if(Role == System.Label.MYBZ_SalesRepresentative ){
                
              getAlignment();
                marketShareList.clear();
      
                marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, LE_ID_PGP__c,system__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c 
                           WHERE District__c=:ms.District__c and territory__c='' and LoadIdentifier__c='A' 
                           ORDER BY Market__c,Month__c, Year__c ASC];
                           
                          
    
            }
            if(Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager || Role == System.Label.MYBZ_MajorMarketManager){
                marketShareList.clear(); 
                 getAlignment();
              
                marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, LE_ID_PGP__c,system__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c 
                           WHERE Global_Id__c =:GlobalId and LoadIdentifier__c='NON_AFFLTN' ]; 
          

                marketShareListNational.clear();
                marketShareListNational = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  division__c =: ms.Division__c and territory__c = null and District__c = null and  Region__c = null  and system__c='a4wg00000003DC3AAM' and pgp__c=null GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            marketShareNationalPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =: ms.Division__c and territory__c = null and District__c = null and  Region__c = null  and system__c='a4wg00000003DC3AAM' and pgp__c=null and lillyProduct__c=true];
            
            marketShareListDistrict.clear();
                marketShareListDistrict = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c =: ms.District__c and territory__c = null  and system__c='a4wg00000003DC3AAM' and pgp__c=null GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            marketShareListRegion.clear();
                marketShareListRegion = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__c =: ms.region__c and District__c=null and territory__c = null  and system__c='a4wg00000003DC3AAM' and pgp__c=null GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            marketShareDistrictPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__c =: ms.District__c and territory__c = null  and system__c='a4wg00000003DC3AAM' and pgp__c=null and lillyProduct__c=true];
            
            marketShareRegionPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE region__c =: ms.region__c and territory__c = null and District__c=null  and system__c='a4wg00000003DC3AAM' and pgp__c=null and lillyProduct__c=true];
            
            
            }
            if(Role == System.Label.MYBZ_SuperUser){
                marketShareList.clear();                
                marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, 
                           Previous_Month_TRx__c, DDD_Units__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c  WHERE Region__c =:reg.Id and district__c=null and LoadIdentifier__c='A' ORDER BY Market__c,Month__c, Year__c ASC];
 
            }
    

    
    }*/
    
    global static void accountSummary(){
        fetchUserInfo();
                    //for account summary page
      
        flag=0;
        system.debug('Inside summary');
        marketShareList = [SELECT Id, Region__c, Gross_Margin__c,District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, LE_ID_PGP__c,system__r.Name,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c 
                           WHERE Global_Id__c =:GlobalId and LoadIdentifier__c='A' ]; 
         marketshareProcessor();             
                           
    }
        
    @future 
    //Non Aff and Geo picker
    global static void marketshareControllerNonAffUsingPicker(String region, String district, String territory){
        fetchUserInfo();
                
        flag=1;MYBZ_Market_Share__c mssobj;
        if(region!='' && region!=null)
             mssobj=[Select division__c FROM MYBZ_Market_Share__c WHERE Region__r.Name=:region and district__c=null and territory__c=null and LoadIdentifier__c='NA' LIMIT 1];
        else if(district!='' && district!=null)
             mssobj=[Select division__c FROM MYBZ_Market_Share__c WHERE district__r.Name=:district and territory__c=null and LoadIdentifier__c='NA' LIMIT 1];
        else
             mssobj=[Select division__c,district__c FROM MYBZ_Market_Share__c WHERE territory__r.Name=:territory and LoadIdentifier__c='NA' LIMIT 1];
      //  MYBZ_Market_Share__c mobj=[Select division__c,district__c,territory__c FROM MYBZ_Market_Share__c WHERE (territory__c=:territory OR District__c=:district OR Region__c=:region) LIMIT 1];
        marketShareListNational.clear();
        marketShareListNational = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  division__c =: mssobj.Division__c and territory__c = null and District__c = null and  Region__c = null  and LoadIdentifier__c='NA' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
        marketShareNationalPercentChange.clear();                           
        marketShareNationalPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =: mssobj.Division__c and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true and LoadIdentifier__c='NA'];
        
        
            if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager ||Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && district !=null && district !='' ){
            marketShareList.clear();
            marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c  FROM MYBZ_Market_Share__c  WHERE District__r.Name =:district AND Territory__c = null and LoadIdentifier__c='NA' ORDER BY Market__c,Month__c, Year__c ASC]; 
            marketShareListDistrict.clear();                   
            marketShareListDistrict = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__r.Name =: district and territory__c = null  and LoadIdentifier__c='NA' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            marketShareDistrictPercentChange.clear();
            marketShareDistrictPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__r.Name =: district and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NA'];
            
            }
    
        if((Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser) && region !=null && region !='' && (district == null || district == '')){  
        marketShareList.clear();
        marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c WHERE Region__r.Name =: region AND District__c = null and LoadIdentifier__c='NA' ORDER BY Market__c,Month__c, Year__c ASC]; 
                           
        marketShareListRegion.clear();
        marketShareListRegion = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__r.Name =: region and District__c=null and territory__c = null  and LoadIdentifier__c='NA' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
        marketShareRegionPercentChange.clear();
        marketShareRegionPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE region__r.Name =: region and territory__c = null and District__c=null  and lillyProduct__c=true and LoadIdentifier__c='NA'];
    
        }
        if((Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  || Role == System.Label.MYBZ_SuperUser) && territory !=null && territory !=''){ 
                    marketShareList.clear();
                    marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, system__r.Name,LE_ID_PGP__c,Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c WHERE Territory__r.Name =:territory and LoadIdentifier__c='NA' ORDER BY Market__c,Month__c, Year__c ASC]; 
                           
                    marketShareListDistrict.clear();                   
                    marketShareListDistrict = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c =: mssobj.district__c and territory__c = null  and LoadIdentifier__c='NA' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
                    marketShareDistrictPercentChange.clear();
                    marketShareDistrictPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__c =: mssobj.district__c and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NA'];
                           
                           
 
        }
        marketshareProcessor();
    }
    public static String ihs=' LE_ID_PGP__c=null and LE_ID_IHS__c=:LE_ID_IHS';
    public static String pgps=' LE_ID_PGP__c=:LE_ID_PGP';
    public static String a='A';
    public static String division='Select division__c FROM MYBZ_Market_Share__c WHERE  ';
    public static String strmarketShareListNational=' and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true and LoadIdentifier__c=\''+a+ '\' and ';
    public static String groupBy=' GROUP BY Month_Number__c, Year_Number__c,Market__c';
    global static String orderBy=' ORDER BY Market__c,Month__c, Year__c ASC';
    global static String getDivision,getmarketShareListNational,getmarketShareNationalPercentChange,getmarketShareList,getmarketShareListDistrict,getmarketShareDistrictPercentChange,getmarketShareRegionPercentChange,getmarketShareListRegion;
    global static String strMarketShareList='SELECT Id,Region__c,Gross_Margin__c,DDD_Dollars__c,District__c,Month__c,Year__c,territory__c,Global_Id__c, Owner__c,Market__c,percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c,system__r.Name,LE_ID_PGP__c,Previous_Month_TRx__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,DDD_Units__c,Previous_DDD_Units__c FROM MYBZ_Market_Share__c where LoadIdentifier__c=\''+a+ '\' and '  ;       

    global static String strmarketShareListDistrict='select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr FROM MYBZ_Market_Share__c WHERE  District__c !=null and  lillyProduct__c=true and territory__c = null and LoadIdentifier__c=\''+a+ '\' and '  ;
    global static String strmarketShareListRegion='select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr FROM MYBZ_Market_Share__c WHERE  region__c!=null and District__c =null and  lillyProduct__c=true and territory__c = null and LoadIdentifier__c=\''+a+ '\' and ' ;
    
    global static String strmarketShareDistrictPercentChange= 'Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__c !=null and  lillyProduct__c=true and territory__c=null and LoadIdentifier__c=\''+a+ '\' and ';
    
    global static String strmarketShareRegionPercentChange= 'Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE region__c!=null and District__c =null and  lillyProduct__c=true and territory__c=null and LoadIdentifier__c=\''+a+ '\' and ';
    
    //String marketShareNationalPercentChange=
    
    global static void marketshareControllerAffUsingPicker(String LE_ID_IHS, String LE_ID_PGP){
         system.debug('LE_ID_IHS'+LE_ID_IHS);
        flag=1;
        fetchUserInfo();
                    
        if(String.isBlank(LE_ID_IHS))
                    getDivision=division+pgps+' Limit 1' ;
                else
                    getDivision=division+ihs+' Limit 1' ;
                
        MYBZ_Market_Share__c mobj=database.query(getDivision);
        String id=mobj.division__c;
        If(String.isBlank(LE_ID_IHS)){
            getmarketShareListNational='select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+pgps+groupBy ;
            
            getmarketShareNationalPercentChange='Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+pgps;
            
        }
        else{
            getmarketShareListNational='select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+ihs+groupBy ;
            
            getmarketShareNationalPercentChange='Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+ihs;
        }
        system.debug('getmarketShareNationalPercentChange'+getmarketShareNationalPercentChange+'getmarketShareListNational'+getmarketShareListNational);
       // MYBZ_Market_Share__c mobj= [Select division__c FROM MYBZ_Market_Share__c WHERE (LE_ID_IHS__c=:LE_ID_IHS OR LE_ID_PGP__c=:LE_ID_PGP) LIMIT 1];
        marketShareListNational.clear();
        //LE_ID_IHS=''?LE_ID_PGP__c=:LE_ID_PGP:LE_ID_IHS__c=:LE_ID_IHS
       /* marketShareListNational = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  division__c =: mobj.Division__c and territory__c = null and District__c = null and  Region__c = null  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
        marketShareListNational=database.query(getmarketShareListNational);
        
        marketShareNationalPercentChange.clear();                           
      //  marketShareNationalPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =: mobj.Division__c and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true and ((LE_ID_IHS__c=:LE_ID_IHS and LE_ID_PGP__c='') OR (LE_ID_IHS__c='' and LE_ID_PGP__c=:LE_ID_PGP)) and LoadIdentifier__c='A' ];
        
        
        
        marketShareNationalPercentChange=database.query(getmarketShareNationalPercentChange);
        //add specific district data
        if(Role == System.Label.MYBZ_SalesRepresentative ||  Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager  ){ // he will see pgp, system, assign to his district
                    marketShareList.clear();
                   /* marketShareList = [SELECT Id, Region__c, Gross_Margin__c,DDD_Dollars__c,District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, system__r.Name,LE_ID_PGP__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c where ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' and district__c!=null
                           ORDER BY Market__c,Month__c, Year__c ASC];*/
                //dangerous
        
        if(Role == System.Label.MYBZ_SalesRepresentative )
            getAlignment();
           system.debug('LE_ID_IHS'+LE_ID_IHS);                
        if((LE_ID_IHS==''|| LE_ID_IHS==null) && (Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) ) {
            getmarketShareList=strMarketShareList+pgps+' and district__c!=null and Global_Id__c=:GlobalId '+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+' Global_Id__c=:GlobalId '+pgps+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+'  Global_Id__c=:GlobalId '+pgps;
        }
        else if(LE_ID_IHS!='' &&LE_ID_IHS!=null&& (Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager) ){
            getmarketShareList=strMarketShareList+ihs+' and district__c!=null and Global_Id__c=:GlobalId '+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+'  Global_Id__c=:GlobalId '+ihs+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+'  Global_Id__c=:GlobalId '+ihs;
        }
        else if(LE_ID_IHS=='' || LE_ID_IHS==null && Role == System.Label.MYBZ_SalesRepresentative ){
            getmarketShareList=strMarketShareList+pgps+' and district__c!=null and district__c=\''+String.escapeSingleQuotes(ms.district__c)+'\''+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+' Global_Id__c=:GlobalId '+pgps+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+'  Global_Id__c=:GlobalId '+pgps;
            
        }
        else{
            getmarketShareList=strMarketShareList+ihs+' and district__c!=null and district__c=\''+String.escapeSingleQuotes(ms.district__c)+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+' Global_Id__c=:GlobalId '+ihs+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+' Global_Id__c=:GlobalId '+ihs;
        }
        
                marketShareList=database.query(getmarketShareList);    
                           
                    marketShareListDistrict.clear();                   
               /*     marketShareListDistrict = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c !=null and territory__c = null  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
                    marketShareListDistrict=database.query(getmarketShareListDistrict);
                                                      
                    marketShareDistrictPercentChange.clear();
                 /*   marketShareDistrictPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__c!=null and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='A'  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c=''))];*/
                 marketShareDistrictPercentChange=database.query(getmarketShareDistrictPercentChange);          
  
        }

      
        if(Role == System.Label.MYBZ_MajorMarketManager  ) {
                    marketShareList.clear();
                  /*  marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, LE_ID_PGP__c,system__r.Name,Gross_Margin__c,DDD_Dollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c where ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' and district__c=null  
                           ORDER BY Market__c,Month__c, Year__c ASC];*/
                          
                          
        if(String.isBlank(LE_ID_IHS)) {
            getmarketShareList=strMarketShareList+pgps+'  district__c=null and Global_Id__c=:GlobalId '+orderBy;
            getmarketShareListRegion=strmarketShareListRegion+' Global_Id__c=:GlobalId '+pgps+groupBy;
            getmarketShareRegionPercentChange=strmarketShareRegionPercentChange+'  Global_Id__c=:GlobalId '+pgps;
        }
        else{
            getmarketShareList=strMarketShareList+ihs+' and district__c=null and Global_Id__c=:GlobalId '+orderBy;
            getmarketShareListRegion=strmarketShareListRegion+'  Global_Id__c=:GlobalId '+ihs+groupBy;
            getmarketShareRegionPercentChange=strmarketShareRegionPercentChange+' Global_Id__c=:GlobalId '+ihs;
        }
                  
                    marketShareList=database.query(getmarketShareList);                       
                    marketShareListRegion.clear();  
                    marketShareListRegion=database.query(getmarketShareListRegion);                 
               /*     marketShareListRegion = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__c!=null and District__c =null and territory__c = null  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A'GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
                                                      
                    marketShareRegionPercentChange.clear();
                    marketShareRegionPercentChange=database.query(getmarketShareRegionPercentChange);
                  /*  marketShareRegionPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE region__c!=null and District__c =null and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='A'  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c=''))];*/
       
        }
      
        marketshareProcessor();
    
    }
    
    //Aff and by default
    @RemoteAction 
    global static void marketshareControllerAffiliation(){
        flag=1;
         fetchUserInfo();
        MYBZ_Market_Share__c objSys=[SELECT LE_ID_IHS__c,division__c FROM MYBZ_Market_Share__c WHERE Global_Id__c =: GlobalId and  LoadIdentifier__c='A' ORDER BY LE_ID_IHS__c LIMIT 1];
        system.debug('sys'+objSys.LE_ID_IHS__c );
        
        getmarketShareListNational='select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(objSys.division__c)+'\''+strmarketShareListNational+' and LE_ID_IHS__c=\''+String.escapeSingleQuotes(objSys.LE_ID_IHS__c)+groupBy ;
            
        getmarketShareNationalPercentChange='Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(objSys.division__c)+'\''+strmarketShareListNational+' and LE_ID_IHS__c=:objSys.LE_ID_IHS__c';
        
         marketShareList.clear();
         
         if(Role == System.Label.MYBZ_SalesRepresentative )
            getAlignment();
                           
        if(Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager)  {
            getmarketShareList=strMarketShareList+'  LE_ID_IHS__c=:objSys.LE_ID_IHS__c and district__c!=null and Global_Id__c=:GlobalId '+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+' Global_Id__c=:GlobalId and LE_ID_IHS__c=:objSys.LE_ID_IHS__c'+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+'  Global_Id__c=:GlobalId '+' and LE_ID_IHS__c=:objSys.LE_ID_IHS__c';
        }
       
        else if(Role == System.Label.MYBZ_SalesRepresentative ){
            getmarketShareList=strMarketShareList+'LE_ID_IHS__c=:objSys.LE_ID_IHS__c and district__c!=null and district__c=\''+String.escapeSingleQuotes(ms.district__c)+'\''+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+' LE_ID_IHS__c=:objSys.LE_ID_IHS__c and district__c=\''+String.escapeSingleQuotes(ms.district__c)+'\''+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+'  LE_ID_IHS__c=:objSys.LE_ID_IHS__c and district__c=\''+String.escapeSingleQuotes(ms.district__c)+'\'';
            
        }
        
        
                marketShareList=database.query(getmarketShareList);    
                           
                    marketShareListDistrict.clear();                   
               /*     marketShareListDistrict = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c !=null and territory__c = null  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
                    marketShareListDistrict=database.query(getmarketShareListDistrict);
                                                      
                    marketShareDistrictPercentChange.clear();
                 /*   marketShareDistrictPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__c!=null and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='A'  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c=''))];*/
                 marketShareDistrictPercentChange=database.query(getmarketShareDistrictPercentChange);    

                if(Role == System.Label.MYBZ_MajorMarketManager){
                    marketShareList.clear();
                  /*  marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, LE_ID_PGP__c,system__r.Name,Gross_Margin__c,DDD_Dollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c where ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' and district__c=null  
                           ORDER BY Market__c,Month__c, Year__c ASC];*/
      
                    getmarketShareList=strMarketShareList+' LE_ID_IHS__c==:objSys.LE_ID_IHS__c and Global_Id__c=:GlobalId and district__c=null '+orderBy;
                    getmarketShareListRegion=strmarketShareListRegion+' Global_Id__c=:GlobalId '+groupBy;
                    getmarketShareRegionPercentChange=strmarketShareRegionPercentChange+' Global_Id__c=:GlobalId ';
        
                  
                    marketShareList=database.query(getmarketShareList);                       
                    marketShareListRegion.clear();  
                    marketShareListRegion=database.query(getmarketShareListRegion);                 
               /*     marketShareListRegion = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__c!=null and District__c =null and territory__c = null  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A'GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
                                                      
                    marketShareRegionPercentChange.clear();
                    marketShareRegionPercentChange=database.query(getmarketShareRegionPercentChange);
                    
                }
  
        }
        
        
        
        
        @RemoteAction 
    
    global static void marketshareControllerAffUsingPickerSuperUser(String LE_ID_IHS , String LE_ID_PGP,String region, String district, String terr){
        flag=1;
        fetchUserInfo();
                  system.debug('LE_ID_IHS'+LE_ID_IHS);
       // MYBZ_Market_Share__c mobj= [Select division__c FROM MYBZ_Market_Share__c WHERE ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) LIMIT 1];
       
       //repititive
       if(String.isBlank(LE_ID_IHS))
                    getDivision=division+pgps+' Limit 1' ;
                else
                    getDivision=division+ihs+' Limit 1' ;
                
        MYBZ_Market_Share__c mobj=database.query(getDivision);
        String id=mobj.division__c;
       
       if(String.isBlank(LE_ID_IHS)){
            getmarketShareListNational='select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+pgps+groupBy ;
            
            getmarketShareNationalPercentChange='Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+pgps;
            
        }
        else{
            getmarketShareListNational='select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+ihs+groupBy ;
            
            getmarketShareNationalPercentChange='Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =\''+String.escapeSingleQuotes(id)+'\''+strmarketShareListNational+ihs;
        }
        marketShareListNational.clear();
        /*marketShareListNational = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  division__c =: mobj.Division__c and territory__c = null and District__c = null and  Region__c = null  and LoadIdentifier__c='A' and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
        marketShareListNational=database.query(getmarketShareListNational);
        marketShareNationalPercentChange.clear();    
        marketShareNationalPercentChange=database.query(getmarketShareNationalPercentChange);       
      /*  marketShareNationalPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE division__c =: mobj.Division__c and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true and LoadIdentifier__c='A' and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c=''))];*/
        
        if(Role == System.Label.MYBZ_SuperUser && ((district!='' && district!=null) || (terr!='' && terr!=null))) { //selected district and System
                marketShareList.clear();
               /* marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, LE_ID_PGP__c,system__r.Name,Gross_Margin__c,DDD_Dollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c where ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' and District__r.Name =:district
                           ORDER BY Market__c,Month__c, Year__c ASC];*/
                           if((terr!='' || terr!=null)){
                            MYBZ_territory__c objterr= [Select state__r.NAme from MYBZ_territory__c WHERE  name=:terr];
                            district=objterr.state__r.NAme;
                           }
                           
        if(String.isBlank(LE_ID_IHS)) {
            getmarketShareList=strMarketShareList+pgps+' and district__c!=null and District__r.Name =:district'+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+pgps+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+pgps;
        }
        else{
            getmarketShareList=strMarketShareList+ihs+' and district__c!=null and District__r.Name =:district'+orderBy;
            getmarketShareListDistrict=strmarketShareListDistrict+ihs+groupBy;
            getmarketShareDistrictPercentChange=strmarketShareDistrictPercentChange+ihs;
        }
                           
                    marketShareListDistrict.clear();                   
                    /*marketShareListDistrict = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c !=null and territory__c = null  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A'GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
                                                      
                    marketShareDistrictPercentChange.clear();
                   /* marketShareDistrictPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE District__c!=null and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='A'  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c=''))];*/
                  
        marketShareList=database.query(getmarketShareList);    
        marketShareListDistrict=database.query(getmarketShareListDistrict);
        marketShareDistrictPercentChange=database.query(getmarketShareDistrictPercentChange); 
                 
        }//selects system and district
 
        if(Role == System.Label.MYBZ_SuperUser && (region!='' && region!=null) ){     
                marketShareList.clear();
                /*marketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, system__r.Name,LE_ID_PGP__c,Gross_Margin__c,DDD_Dollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c 
                           FROM MYBZ_Market_Share__c WHERE ((LE_ID_IHS__c=:LE_ID_IHS and LE_ID_PGP__c='') OR (LE_ID_IHS__c='' and LE_ID_PGP__c=:LE_ID_PGP)) and Region__r.Name =: region AND District__c = null and LoadIdentifier__c='A' 
                           ORDER BY Market__c,Month__c, Year__c ASC]; */
                           
            if(String.isBlank(LE_ID_IHS)) {
            getmarketShareList=strMarketShareList+pgps+' and district__c=null and Region__r.Name =:region'+orderBy;
            getmarketShareListRegion=strmarketShareListRegion+pgps+groupBy;
            getmarketShareRegionPercentChange=strmarketShareRegionPercentChange+pgps;
        }
        else{
            getmarketShareList=strMarketShareList+ihs+' and district__c=null and Region__r.Name =:region'+orderBy;
            getmarketShareListRegion=strmarketShareListRegion+ihs+groupBy;
            getmarketShareRegionPercentChange=strmarketShareRegionPercentChange+ihs;
        }
                           
                    marketShareListRegion.clear();                 
                 /*   marketShareListRegion = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__c!=null and District__c =null and territory__c = null  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c='')) and LoadIdentifier__c='A' GROUP BY Month_Number__c, Year_Number__c,Market__c ];*/
                                                      
                    marketShareRegionPercentChange.clear();
                /*    marketShareRegionPercentChange= [Select TRx__c,Previous_Month_TRx__c FROM MYBZ_Market_Share__c WHERE region__c!=null and District__c =null and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='A'  and ((LE_ID_PGP__c=:LE_ID_IHS==null?LE_ID_PGP:LE_ID_IHS) OR ((LE_ID_IHS__c=:LE_ID_PGP==null?LE_ID_IHS:LE_ID_PGP) and LE_ID_PGP__c=''))];*/
                    
            marketShareListRegion=database.query(getmarketShareListRegion);     
            marketShareList=database.query(getmarketShareList); 
            marketShareRegionPercentChange=database.query(getmarketShareRegionPercentChange);                   
          
        }
          marketshareProcessor();
 }
    global static void calculateNational(){
        mapAggNat.clear();
        mapAggReg.clear();
        mapAggDis.clear();
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
        
        if(!marketShareListNational.isEmpty()){
            
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

    
global static void marketshareProcessor() {  
    nationalPercentChange.clear();
    districtPercentChange.clear();
    regionPercentChange.clear();
    String JsonString;
    JSONGenerator generator= JSON.createGenerator(true);
    calculateNational();
     // MS record per product for a single PGP market,year,month and product
        map<String , map<String, map<String, map<String, map< string , MYBZ_Market_Share__c>>>>> mapMarketYearMonthProductMarketObj = new map<String,map<string, map<String, map<String, map< string , MYBZ_Market_Share__c >>>>>();    
        
        map<string, Decimal> totalTRxperMonth = new map<string, Decimal>();
        
        map<String, map<String, map<String, map< string , MYBZ_Market_Share__c>>>> mapMSData=new map<String, map<String, map<String, map< string , MYBZ_Market_Share__c>>>>();
        
        map<String,String> mapPgpIhs=new map<String,String>();
            // creating a map to hold years per marketshare name 
            if(!marketShareList.isEmpty()){
                for(MYBZ_Market_Share__c mObj  : marketShareList){ 
                    if(flag==0){
                    if( mapMarketYearMonthProductMarketObj.containsKey(mobj.LE_ID_PGP__c)){
                        mapPgpIhs.put(mobj.LE_ID_PGP__c,mobj.system__r.Name);
                       if(mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).containsKey(mObj.Market__c)){
                           if( mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).get(mObj.Market__c).containsKey(mObj.Month_Number__c)) {
                             if(mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).get(mObj.Market__c).get(mObj.Month_Number__c).containsKey(mObj.Year_Number__c)){
                                if(mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).containsKey(mObj.Product__r.name))                                  
                                        mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj); 
                                else                                        
                                        mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).get(mObj.Market__c).get(mObj.Month_Number__c).get(mObj.Year_Number__c).put(mObj.Product__r.name, mObj);
                             }
                             else
                                mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).get(mObj.Market__c).get(mObj.Month_Number__c).put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );
                                    
                           }    
                          else{ 
                                 
                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );  
                                
                                mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).get(mObj.Market__c).put(mObj.Month_Number__c,yearProdMap);
                                
                          } 
                       }          
                    else{                                         
                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );                                  
                                
                                map<string,map<string, map<string, MYBZ_Market_Share__c>>> monthyearProdMap =  new map<string,map<string, map<string, MYBZ_Market_Share__c>>>();
                                monthyearProdMap .put(mObj.Month_Number__c,yearProdMap);
                                
                                mapMarketYearMonthProductMarketObj.get(mobj.LE_ID_PGP__c).put(mObj.Market__c, monthyearProdMap);
                         
                       }
                    }    
                    else{
                                map<string, map<string, MYBZ_Market_Share__c>> yearProdMap = new map<string, map<string,MYBZ_Market_Share__c>>();
                                yearProdMap .put(mObj.Year_Number__c, new  map<string, MYBZ_Market_Share__c> {mObj.Product__r.name => mObj } );                                  
                                
                                map<string,map<string, map<string, MYBZ_Market_Share__c>>> monthyearProdMap =  new map<string,map<string, map<string, MYBZ_Market_Share__c>>>();
                                monthyearProdMap .put(mObj.Month_Number__c,yearProdMap);
                                
                                map<string,map<string,map<string, map<string, MYBZ_Market_Share__c>>>> marketmonthYearMap = new map<string,map<string,map<string, map<string, MYBZ_Market_Share__c>>>>();
                                marketmonthYearMap.put(mObj.Market__c, monthyearProdMap);
                                
                                mapMarketYearMonthProductMarketObj.put(mObj.LE_ID_PGP__c, marketmonthYearMap);   
                                mapPgpIhs.put(mObj.LE_ID_PGP__c,mObj.system__c);

                    }                   
                 }

                 else{
                 
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
                if(flag==0){
                   generator.writeStartObject();
                
                    if(pgp=='' || pgp==null)
                         generator.writeNullField(System.Label.Mybz_name);
                     else
                        generator.writeStringField(System.Label.Mybz_name,pgp);
                 
                    if(!(mapPgpIhs.get(pgp)== null)) 
                        generator.writeStringField(System.Label.mybz_associationName,mapPgpIhs.get(pgp));
                    else 
                        generator.writeNullField(System.Label.mybz_associationName);
                                
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
                        
                         generator.writeStartObject();
                         generator.writeStringField(System.Label.MYBZ_month,Month);
                         generator.writeStringField(System.Label.MYBZ_Year,Year);
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
                              
                              if(marketShareObj.PercentageChangeDDDunits__c != null){
                                  generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,marketShareObj.PercentageChangeDDDunits__c);
                              }
                              else{
                                  generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                              }
                              
                            string markMonthYearMS =  marketShareObj.Market__c+marketShareObj.Month_Number__c+marketShareObj.Year_Number__c; 
                            
                            if(marketShareObj.Gross_Margin__c!=null )
                                 generator.writeNumberField(System.Label.MYBZ_grossMargins,marketShareObj.Gross_Margin__c);   
                            else 
                                generator.writeNullField(System.Label.MYBZ_grossMargins);
                            
                            if(marketShareObj.DDD_Dollars__c!=null )
                                 generator.writeNumberField(System.Label.MYBZ_dddDollars,marketShareObj.DDD_Dollars__c);   
                            else 
                                generator.writeNullField(System.Label.MYBZ_dddDollars);
                            
                    
                    system.debug(marketShareObj.product__c+''+product);
                    string markProdMonthYearMS =  marketShareObj.Market__c+product+marketShareObj.Month_Number__c+marketShareObj.Year_Number__c;
                    for(MYBZ_Market_Share__c obj:marketShareNationalPercentChange){
            
                                if(obj.trx__c!=null && (obj.Previous_Month_TRx__c!=null && obj.Previous_Month_TRx__c!=0))
                                    nationalPercentChange.put(markProdMonthYearMS,obj.trx__c-obj.Previous_Month_TRx__c/obj.Previous_Month_TRx__c);
                                else
                                    nationalPercentChange.put(markProdMonthYearMS,0);
                
                    }
                    for(MYBZ_Market_Share__c obj:marketShareDistrictPercentChange){
                            
                            if(obj.trx__c!=null && (obj.Previous_Month_TRx__c!=null && obj.Previous_Month_TRx__c!=0))
                                districtPercentChange.put(markProdMonthYearMS,obj.trx__c-obj.Previous_Month_TRx__c/obj.Previous_Month_TRx__c);
                            else
                                districtPercentChange.put(markProdMonthYearMS,0);
                
                    }
                    for(MYBZ_Market_Share__c obj:marketShareRegionPercentChange){
            
                            if(obj.trx__c!=null && (obj.Previous_Month_TRx__c!=null && obj.Previous_Month_TRx__c!=0))
                                regionPercentChange.put(markProdMonthYearMS,obj.trx__c-obj.Previous_Month_TRx__c/obj.Previous_Month_TRx__c);
                            else
                                regionPercentChange.put(markProdMonthYearMS,0);
                
                    }
                system.debug('nationalPercentChange' + nationalPercentChange);
                
              /*  if(!mapAggNat.isempty(markMonthYearMS) ){
                    if(mapAggNat.get(markMonthYearMS)!=null){
                    //for(AggregateResult mshare: mapAggNat.get(markMonthYearMS)){
                                
                                    system.debug(markMonthYearMS);
                                  //   system.debug('++markMonthYearMS' + markMonthYearMS + mshare); 
                                  if(mshare.get('TotTrx')!=null)
                                       TotalTrx += (Decimal)mshare.get('TotTrx');  
                                }
                    //} 
                }*/
            /*    if(!mapAggDis.isempty() ){
                    if(mapAggDis.get(markMonthYearMS)!=null){
                    for(AggregateResult mshare: mapAggDis.get(markMonthYearMS)){
                                
                                    system.debug(markMonthYearMS);
                                  //   system.debug('++markMonthYearMS' + markMonthYearMS + mshare); 
                                   if(mshare.get('TotTrx')!=null)
                                       TotalTrxDis += (Decimal)mshare.get('TotTrx');  
                                }
                    } 
                }*/
              /*  if(!mapAggReg.isempty() ){
                    if(mapAggReg.get(markMonthYearMS)!=null){
                    for(AggregateResult mshare: mapAggReg.get(markMonthYearMS)){
                                
                                    system.debug(markMonthYearMS);
                                
                                   if(mshare.get('TotTrx')!=null)
                                       TotalTrxReg += (Decimal)mshare.get('TotTrx');  
                                }
                    } 
                }*/
                system.debug('mapAggNat'+mapAggNat);
                system.debug('mapAggNat'+mapAggReg);
                system.debug('mapAggNat'+mapAggDis);
                generator.writeFieldName(System.Label.MYBZ_National);                          
                generator.writeStartObject();
                if(marketShareObj.lillyProduct__c){
                    if(!mapAggNat.isempty() )
                        if(mapAggNat.get(markMonthYearMS)!=null)
                            if(mapAggNat.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                TotalTrx=(Decimal)mapAggNat.get(markMonthYearMS).get(0).get('TotTrx');
                if(TotalTrx!=0 && marketShareObj.Trx__c != null){
                       generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.Trx__c/TotalTrx) *100);
                        system.debug('+++objNatWrapper.Percentage' + (marketShareObj.Trx__c/TotalTrx) *100);
                        if(nationalPercentChange.get(markProdMonthYearMS)!=null)
                            generator.writeNumberField(System.Label.MYBZ_PercentageChange,nationalPercentChange.get(markProdMonthYearMS));
                        else
                             generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        
                        }
                        else{
                        generator.writeNullField(System.Label.MYBZ_Percentage);
                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        }
                    }   
                    else {
                        generator.writeNullField(System.Label.MYBZ_Percentage);
                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                    }
                
                    generator.writeEndObject(); 
                    
                generator.writeFieldName(System.Label.MYBZ_District);                          
                generator.writeStartObject();
                if(marketShareObj.lillyProduct__c){
                    if(!mapAggDis.isempty() )
                        if(mapAggDis.get(markMonthYearMS)!=null)
                            if(mapAggDis.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                TotalTrxDis=(Decimal)mapAggDis.get(markMonthYearMS).get(0).get('TotTrx');
                            
                        
                    
                if(TotalTrxDis!=0 && marketShareObj.Trx__c != null){
                       generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.Trx__c/TotalTrxDis) *100);
                        
                        if(districtPercentChange.get(markProdMonthYearMS)!=null)
                            generator.writeNumberField(System.Label.MYBZ_PercentageChange,districtPercentChange.get(markProdMonthYearMS));
                        else
                             generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        
                        }
                        else{
                        generator.writeNullField(System.Label.MYBZ_Percentage);
                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        }
                    }   
                    else {
                        generator.writeNullField(System.Label.MYBZ_Percentage);
                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                    }
                
                    generator.writeEndObject(); 
                    
                     generator.writeFieldName(System.Label.MYBZ_Region);                          
                    generator.writeStartObject();
                if(marketShareObj.lillyProduct__c){
                    if(!mapAggReg.isempty() )
                        if(mapAggReg.get(markMonthYearMS)!=null)
                            if(mapAggReg.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                TotalTrxReg=(Decimal)mapAggReg.get(markMonthYearMS).get(0).get('TotTrx');
                if(TotalTrxReg!=0 && marketShareObj.Trx__c != null){
                       generator.writeNumberField(System.Label.MYBZ_Percentage,(marketShareObj.Trx__c/TotalTrxReg) *100);
                      
                        if(regionPercentChange.get(markProdMonthYearMS)!=null)
                            generator.writeNumberField(System.Label.MYBZ_PercentageChange,regionPercentChange.get(markProdMonthYearMS));
                        else
                             generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        
                        }
                        else{
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
                    Object MarketShareObject = Json.deserializeUntyped(JsonString); 
               
                  }
                 public MYBZ_MarketShare(){
               
                 }
     }