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
    public MYBZ_MarketShare(){              
    }
    global static integer flag=1;
     
    /* 
        * @Method Name                    :  getAlignment
        * @Description                    :  Helper method to find the alignment information from given global id 
        * @Return Type                    :  List<MYBZ_Market_Share__c>
        * @Param                          :  String           
    */
    global static List<MYBZ_Market_Share__c>  getAlignment(String GlobalId){
        List<MYBZ_Market_Share__c> lstMartShareAlignment = new List<MYBZ_Market_Share__c>();
        if(!String.isBlank(GlobalId)){
            lstMartShareAlignment= [SELECT Territory__c,Territory__r.name,District__c,District__r.name,Region__c, Region__r.name,
                                            Division__c,Division__r.name FROM MYBZ_Market_Share__c WHERE Global_Id__c =:GlobalId Limit 1];
        }
        if(!lstMartShareAlignment.isEmpty()){
            return lstMartShareAlignment;
        }else{
            return null;
        }
    }
    
    /* 
        * @Method Name                    :  fetchUserInfo
        * @Description                    :  Method used to get logged in user's Role and Global id as it forms the basis to fetch records                                               
        * @Return Type                    :  User
        * @Param                          :  null
    */       
    global static List<User> fetchUserInfo(){
        List<User> lstUser = new List<User>();              
        id UserId = UserInfo.getUserId();   
        lstUser = [SELECT name,Prsnl_Nbr_GLBL__c, MYBZ_Role__c, MYBZ_Reporting_ID__c FROM User WHERE Id =:UserId limit 1];
        return lstUser;     
        
    }
     
    /* 
        * @Method Name                    :  getSystemAffiliation
        * @Description                    :  Helper method to find the affiliation information from given global id 
        * @Return Type                    :  void
        * @Param                          :  none   
        
    */
    global static List<MYBZ_System__c>  getSystemAffiliation(String GlobalId){
        
        List<MYBZ_System__c> lstSystem = new List<MYBZ_System__c>();
        if(!String.isBlank(GlobalId)){
            lstSystem = [SELECT Name,System_ID__c,Aligned_Territories__c,Aligned_Districts__c                                    
                                       FROM MYBZ_System__c
                                       WHERE Global_IDs__c INCLUDES (:GlobalID) order by Name];
        }           
        return lstSystem;                                         
    }
    
    /* 
        * @Method Name                    :  getPGPAffiliation
        * @Description                    :  Helper method to find the affiliation information from given global id 
        * @Return Type                    :  void
        * @Param                          :  none   
        
    */
    global static List<MYBZ_PGP__c>  getPGPAffiliation(String GlobalId){
        
        List<MYBZ_PGP__c> lstPGP = new List<MYBZ_PGP__c>();
        if(!String.isBlank(GlobalId)){     
            lstPGP = [SELECT Name, PGP_ID__c, Aligned_Territories__c, Aligned_Districts__c
                                        FROM MYBZ_PGP__c
                                       WHERE Global_IDs__c INCLUDES (:GlobalID) Order By Name ];                            
        }
        return lstPGP;      
    }
    
      
     /* 
        * @Method Name                    :  marketShareControllerNonAff
        * @Description                    :  Method used to generate Marketshare JSON for Non-Aff screen when the default callout is made.                                    
        * @Return Type                    :  object
        * @Param                          :  
    */ 
    @RemoteAction
    global static Object marketShareControllerNonAff(Boolean flagAff) { 
        // Initialisation
        List<User> lstUser = new List<User>();      
        List<MYBZ_Market_Share__c> lstMartShareAlignment = new List<MYBZ_Market_Share__c>();
        List<MYBZ_Market_Share__c> lstMarketShare = new List<MYBZ_Market_Share__c> ();
        
        List<AggregateResult> lstMarketShareDistrict = new List<AggregateResult>();
        List<AggregateResult> lstMarketShareRegion = new List<AggregateResult>();
        List<AggregateResult> lstMarketShareNational = new List<AggregateResult>();
        
        List<MYBZ_Market_Share__c> lstMarketShareDistrictPercentageChange  = new List<MYBZ_Market_Share__c> ();
        List<MYBZ_Market_Share__c> lstMarketShareRegionPercentageChange = new List<MYBZ_Market_Share__c> ();
        List<MYBZ_Market_Share__c> lstMarketShareNationalPercentageChange = new List<MYBZ_Market_Share__c> ();
        
        String GlobalId;
        String Role;
        
        // Fetch user information
        lstUser = fetchUserInfo();
        
        
        //Assignment of Global Id and Role
        if(!lstUser.isEmpty()){
            Role = lstUser[0].MYBZ_Role__c;
            if(flagAff == false && lstUser[0].MYBZ_Role__c == System.Label.MYBZ_AccountManager  && lstUser[0].MYBZ_Reporting_ID__c !=null){
                GlobalId=lstUser[0].MYBZ_Reporting_ID__c;
            }else{
                GlobalId = lstUser[0].Prsnl_Nbr_GLBL__c;
            }
            system.debug('GlobalId'+GlobalId+'Role'+Role);    
            flag=1;
            if(Role !=  System.Label.MYBZ_SuperUser){
                lstMartShareAlignment = getAlignment(GlobalId);
            }else{
                lstMartShareAlignment = [SELECT Region__c, Division__c FROM MYBZ_Market_Share__c WHERE Region__r.name =: System.Label.MYBZ_defaultRegion Limit 1];
            }
           
            if(!lstMartShareAlignment.isEmpty()){
                if( Role !=  System.Label.MYBZ_SuperUser){      
                    lstMarketShare = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                                               DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                               FROM MYBZ_Market_Share__c
                                               WHERE Global_Id__c =:GlobalId and LoadIdentifier__c='NON_AFFLTN' 
                                               Order by Market__c, Year__c, Month__c asc, Product__r.Name desc ];
                }else{                    
                    lstMarketShare = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                                               FROM MYBZ_Market_Share__c
                                               WHERE Region__c =:lstMartShareAlignment[0].Region__c and district__c=null and LoadIdentifier__c='NON_AFFLTN' 
                                               order by Market__c, Year__c, Month__c asc, Product__r.Name desc ];
                 
                }                     
           
            
                lstMarketShareNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  division__c =: lstMartShareAlignment[0].Division__c and territory__c = null and District__c = null and  Region__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                        
                lstMarketShareNationalPercentageChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                       DDD_Dollars__c, DDD_Units__c, TRx__c, Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                        FROM MYBZ_Market_Share__c WHERE division__c =: lstMartShareAlignment[0].Division__c and territory__c = null and District__c = null and  Region__c = null  and lillyProduct__c=true  and LoadIdentifier__c='NON_AFFLTN'];
                    
                if(Role == System.Label.MYBZ_SalesRepresentative||  Role == System.Label.MYBZ_DistrictSalesManager || Role == System.Label.MYBZ_AccountManager ) {     
                    
                    lstMarketShareDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  District__c =: lstMartShareAlignment[0].District__c and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];                
            
            
                    lstMarketShareDistrictPercentageChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                      DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                      FROM MYBZ_Market_Share__c WHERE District__c =: lstMartShareAlignment[0].District__c and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
                } 
            
                if(Role == System.Label.MYBZ_MajorMarketManager || Role == System.Label.MYBZ_SuperUser){             
                                
                    lstMarketShareRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c 
                                                      WHERE  region__c =: lstMartShareAlignment[0].region__c and District__c=null and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                      
            
                    lstMarketShareRegionPercentageChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                     DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                             FROM MYBZ_Market_Share__c WHERE region__c =: lstMartShareAlignment[0].region__c and territory__c = null and District__c=null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
                   
                                                      
                
            
                }
            }
        }
        Object marketShare= marketshareProcessor(lstMarketShare, lstMarketShareNational, lstMarketShareNationalPercentageChange, lstMarketShareRegion, lstMarketShareRegionPercentageChange, lstMarketShareDistrict, lstMarketShareDistrictPercentageChange);
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
        List<MYBZ_Territory__c> lstTerritory = new List<MYBZ_Territory__c>();
        List<MYBZ_District__c> lstDistrict = new List<MYBZ_District__c>();
        List<MYBZ_Region__c> lstRegion = new List<MYBZ_Region__c>();
        List<MYBZ_Market_Share__c> lstMarketShare = new List<MYBZ_Market_Share__c> ();
        
        List<AggregateResult> marketShareListDistrict = new List<AggregateResult>();
        List<AggregateResult> marketShareListRegion  = new List<AggregateResult>();
        List<AggregateResult> marketShareListNational = new List<AggregateResult>();
        
        List<MYBZ_Market_Share__c> marketShareDistrictPercentChange = new List<MYBZ_Market_Share__c>();
        List<MYBZ_Market_Share__c> marketShareRegionPercentChange = new List<MYBZ_Market_Share__c>();
        List<MYBZ_Market_Share__c> marketShareNationalPercentChange = new List<MYBZ_Market_Share__c>();
        
        flag=1;
        if(!String.isBlank(territory)){
            lstTerritory = [SELECT id, name, State__c, State__r.Name, 
                                    State__r.Region__c, State__r.Region__r.Name, 
                                    State__r.Region__r.Parent__c FROM MYBZ_Territory__c
                                    WHERE name = : territory limit 1];
            
                                    
            if(!lstTerritory.isEmpty()){
                if(lstTerritory[0].id != null){

                    lstMarketShare = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, system__r.Name,LE_ID_PGP__c,Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                           FROM MYBZ_Market_Share__c WHERE Territory__c =:lstTerritory[0].id and LoadIdentifier__c='NON_AFFLTN' order by Market__c, Year__c, Month__c asc, Product__r.Name desc ];              
            
            
                }
                if(lstTerritory[0].State__c != null){
                    
                    marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD,  Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  District__c =: lstTerritory[0].State__c and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c];
                          
                
                    marketShareDistrictPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            FROM MYBZ_Market_Share__c WHERE District__c =: lstTerritory[0].State__c 
                                                            and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
                    
                }
                if(lstTerritory[0].State__r.Region__c !=null){                    
                    
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstTerritory[0].State__r.Region__c and District__c=null and territory__c = null  
                                                          and  LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c, Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstTerritory[0].State__r.Region__c and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and  LoadIdentifier__c='NON_AFFLTN' ];
                                
                }
                if(lstTerritory[0].State__r.Region__r.Parent__c !=null){
                    
                    
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD,  Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstTerritory[0].State__r.Region__r.Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null and  LoadIdentifier__c='NON_AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                              FROM MYBZ_Market_Share__c
                                                               WHERE division__c =: lstTerritory[0].State__r.Region__r.Parent__c and territory__c = null and 
                                                               District__c = null and  Region__c = null  and lillyProduct__c=true  
                                                               and  LoadIdentifier__c='NON_AFFLTN' ];
                    
                }
            }
            
        }
        
        if(!String.isBlank(district)){
            lstDistrict = [SELECT id, Region__c, Region__r.Name, Region__r.Parent__c  FROM MYBZ_District__c WHERE name =:district limit 1];
            
            if(!lstDistrict.isEmpty()){
                if(lstDistrict[0].id != null){
                    
                    lstMarketShare = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, system__r.Name,LE_ID_PGP__c,Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                           FROM MYBZ_Market_Share__c WHERE Territory__c =null and District__c=:lstDistrict[0].id and LoadIdentifier__c='NON_AFFLTN' order by Market__c, Year__c, Month__c asc, Product__r.Name desc   ];        
                    
                    marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD,  Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  District__c =: lstDistrict[0].id and territory__c = null  and LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c];
                          
                
                    marketShareDistrictPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            FROM MYBZ_Market_Share__c WHERE District__c =: lstDistrict[0].id 
                                                            and territory__c = null  and lillyProduct__c=true and LoadIdentifier__c='NON_AFFLTN'];
                    
                }
                if(lstDistrict[0].Region__c != null){
                    
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstDistrict[0].Region__c and District__c=null and territory__c = null  
                                                          and  LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c, Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c  
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstDistrict[0].Region__c and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and  LoadIdentifier__c='NON_AFFLTN' ];
                                
                }
                 if(lstDistrict[0].Region__r.Parent__c != null){
                    
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstDistrict[0].Region__r.Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and  LoadIdentifier__c='NON_AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c, Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                              FROM MYBZ_Market_Share__c
                                                               WHERE division__c =: lstDistrict[0].Region__r.Parent__c and territory__c = null and 
                                                               District__c = null and  Region__c = null  and lillyProduct__c=true  
                                                               and  LoadIdentifier__c='NON_AFFLTN' ];
                    
                }
                    
            }
                
        }
        if(!String.isBlank(region)){    
            lstRegion = [SELECT id, name, Parent__c FROM MYBZ_Region__c WHERE name =:region limit 1];
            
            if(!lstRegion.isEmpty()){
                if(lstRegion[0].id != null){
                    
                    lstMarketShare = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, 
                           Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, system__r.Name,LE_ID_PGP__c,Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                           Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c 
                           FROM MYBZ_Market_Share__c WHERE Territory__c =null and District__c=null and region__c =: lstRegion[0].id  and LoadIdentifier__c='NON_AFFLTN' order by Market__c, Year__c, Month__c asc, Product__r.Name desc   ]; 
                    
                    
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstRegion[0].id  and District__c=null and territory__c = null  
                                                           and  LoadIdentifier__c='NON_AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c , Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstRegion[0].id  and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and  LoadIdentifier__c='NON_AFFLTN' ];
                                
                }
                 if(lstRegion[0].Parent__c != null){
                    
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstRegion[0].Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and  LoadIdentifier__c='NON_AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                              FROM MYBZ_Market_Share__c
                                                               WHERE division__c =: lstRegion[0].Parent__c and territory__c = null and 
                                                               District__c = null and  Region__c = null  and lillyProduct__c=true  
                                                               and  LoadIdentifier__c='NON_AFFLTN' ];
                    
                }
            }
                
        }
        
        Object marketShare= marketshareProcessor(lstMarketShare, marketShareListNational, marketShareNationalPercentChange, marketShareListRegion, marketShareRegionPercentChange, marketShareListDistrict,marketShareDistrictPercentChange);
        return marketShare;
    }  
    
    
    
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
        List<User> lstUser = new List<User>();  
        List<MYBZ_Market_Share__c> lstMartShareAlignment = new List<MYBZ_Market_Share__c>();
        List<MYBZ_System__c> sysList = new List<MYBZ_System__c>();
        List<MYBZ_PGP__c> pgplist = new  List<MYBZ_PGP__c>();
        String GlobalId;
        String Role;
        
        // Fetch user information
        lstUser = fetchUserInfo();
        
        
        //Assignment of Global Id and Role
        if(!lstUser.isEmpty()){
            Role = lstUser[0].MYBZ_Role__c;
            GlobalId= lstUser[0].Prsnl_Nbr_GLBL__c;
            
        }
        flag=1;
        
        string Terr = ''; 
        string dist = '';
        string reg = '';
        if(Role == System.Label.MYBZ_SalesRepresentative){
           lstMartShareAlignment = getAlignment(GlobalId);
           if(!lstMartShareAlignment.isEmpty()){
              Terr = lstMartShareAlignment[0].Territory__c;
           }
        }
        
        if(Role == System.Label.MYBZ_AccountManager){           
           lstMartShareAlignment = getAlignment(GlobalId);
           sysList = getSystemAffiliation(GlobalId);
           pgplist = getPGPAffiliation(GlobalId);
           if(!sysList.isEmpty()){
              LE_ID_IHS = sysList[0].System_ID__c;
           }
           else if(!pgplist.isEmpty()){
              LE_ID_PGP = pgplist[0].PGP_ID__c;
           }
           if(!lstMartShareAlignment.isEmpty()){
              dist = lstMartShareAlignment[0].District__r.name;
           }
        }
        Object marketShare= marketshareControllerAffUsingPickerSuperUser(LE_ID_IHS,LE_ID_PGP,reg,dist, Terr);
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
            
        
        flag=1;
          
        List<MYBZ_Market_Share__c> marketShareList =new List<MYBZ_Market_Share__c>();    
        List<AggregateResult> marketShareListNational=new List<AggregateResult>();
        List<AggregateResult> marketShareListDistrict=new List<AggregateResult>();
        List<AggregateResult> marketShareListRegion=new List<AggregateResult>();
        List<MYBZ_Market_Share__c> marketShareNationalPercentChange=new List<MYBZ_Market_Share__c>();
        List<MYBZ_Market_Share__c> marketSharedistrictPercentChange=new List<MYBZ_Market_Share__c>();
        List<MYBZ_Market_Share__c> marketShareRegionPercentChange=new List<MYBZ_Market_Share__c>();
        
        List<MYBZ_Territory__c> lstTerritory = new List<MYBZ_Territory__c>();
        List<MYBZ_District__c> lstDistrict = new List<MYBZ_District__c>();
        List<MYBZ_Region__c> lstRegion = new List<MYBZ_Region__c>();
                         
        if(!String.isBlank(LE_ID_IHS)){
            marketShareList.clear();
            marketShareList = [SELECT Id,Region__c,Gross_Margin__c,DDD_Dollars__c,District__c,Month__c,Year__c,
                                      territory__c,Global_Id__c, Owner__c,Market__c,percentageChangeFromPreviousMonth__c,lillyProduct__c, 
                                      Month_Number__c, Year_Number__c, Product__r.Name, TRx__c,system__r.Name, LE_ID_IHS__c, LE_ID_PGP__c,Previous_Month_TRx__c,
                                      PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,DDD_Units__c,Previous_DDD_Units__c, 
                                      Previous_DDD_Dollars__c FROM MYBZ_Market_Share__c WHERE LE_ID_IHS__c =:LE_ID_IHS  and LE_ID_PGP__c = null and LoadIdentifier__c='AFFLTN' and Division__c = null and Region__c = null and District__c =null and Territory__c = null order by Market__c, Year__c, Month__c asc, Product__r.Name desc  ];
        }
        
        if(!String.isBlank(LE_ID_PGP)){
            marketShareList.clear();
            marketShareList = [SELECT Id,Region__c,Gross_Margin__c,DDD_Dollars__c,District__c,Month__c,Year__c,
                                      territory__c,Global_Id__c, Owner__c,Market__c,percentageChangeFromPreviousMonth__c,lillyProduct__c, 
                                      Month_Number__c, Year_Number__c, Product__r.Name, TRx__c,system__r.Name, LE_ID_IHS__c, LE_ID_PGP__c,Previous_Month_TRx__c,
                                      PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,DDD_Units__c,Previous_DDD_Units__c, 
                                      Previous_DDD_Dollars__c FROM MYBZ_Market_Share__c WHERE LE_ID_PGP__c =:LE_ID_PGP  and LoadIdentifier__c='AFFLTN' and Division__c = null and Region__c = null and District__c =null and Territory__c = null order by Market__c, Year__c, Month__c asc, Product__r.Name desc ];
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
                    marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD,  Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  District__c =: lstTerritory[0].State__c and LE_ID_PGP__c = null and LE_ID_IHS__c =null and territory__c = null  and LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c];
                          
                
                    marketShareDistrictPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            FROM MYBZ_Market_Share__c WHERE District__c =: lstTerritory[0].State__c 
                                                            and territory__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and lillyProduct__c=true and LoadIdentifier__c='AFFLTN'];
                    
                }
                if(lstTerritory[0].State__r.Region__c !=null){
                    marketShareListRegion.clear();
                    marketShareRegionPercentChange.clear();
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstTerritory[0].State__r.Region__c and District__c=null and territory__c = null  
                                                          and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c, Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstTerritory[0].State__r.Region__c and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                                
                }
                if(lstTerritory[0].State__r.Region__r.Parent__c !=null){
                    marketShareListNational.clear();
                    marketShareNationalPercentChange.clear();
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD,  Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstTerritory[0].State__r.Region__r.Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                              FROM MYBZ_Market_Share__c
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
                    marketShareListDistrict = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD,  Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  District__c =: lstDistrict[0].id and LE_ID_PGP__c = null and LE_ID_IHS__c =null and territory__c = null  and LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c];
                          
                
                    marketShareDistrictPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            FROM MYBZ_Market_Share__c WHERE District__c =: lstDistrict[0].id 
                                                            and territory__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and lillyProduct__c=true and LoadIdentifier__c='AFFLTN'];
                    
                }
                if(lstDistrict[0].Region__c != null){
                    marketShareListRegion.clear();
                    marketShareRegionPercentChange.clear();
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstDistrict[0].Region__c and District__c=null and territory__c = null  
                                                          and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c, Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c  
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstDistrict[0].Region__c and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                                
                }
                 if(lstDistrict[0].Region__r.Parent__c != null){
                    marketShareListNational.clear();
                    marketShareNationalPercentChange.clear();
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstDistrict[0].Region__r.Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c, Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                              FROM MYBZ_Market_Share__c
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
                    marketShareListRegion = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  region__c =: lstRegion[0].id  and District__c=null and territory__c = null  
                                                          and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' GROUP BY Month_Number__c, Year_Number__c,Market__c ];
                                                          
                
                    marketShareRegionPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, 
                                                            Year_Number__c,Product__c, Market__c, PercentageChangeDDDDollars__c, 
                                                            PercentageChangeDDDunits__c, DDD_Dollars__c, DDD_Units__c, TRx__c , Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                            FROM MYBZ_Market_Share__c WHERE region__c =: lstRegion[0].id  and territory__c = null 
                                                            and District__c=null  and lillyProduct__c=true and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                                
                }
                 if(lstRegion[0].Parent__c != null){
                    marketShareListNational.clear();
                    marketShareNationalPercentChange.clear();
                    marketShareListNational = [SELECT Market__c mar, SUM(TRx__c) TotTrx, SUM(PREVIOUS_MONTH_TRX__C) TotPrevTrx, SUM(DDD_Units__c) TotDDD, SUM(PREVIOUS_DDD_UNITS__C) TotPrevDDD, Month_Number__c mon, Year_Number__c yr 
                                                          FROM MYBZ_Market_Share__c 
                                                          WHERE  division__c =: lstRegion[0].Parent__c and territory__c = null and District__c = null 
                                                          and  Region__c = null  and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' 
                                                          GROUP BY Month_Number__c, Year_Number__c,Market__c ];
               
                
                    marketShareNationalPercentChange= [SELECT percentageChangeFromPreviousMonth__c,Month_Number__c, Year_Number__c,
                                                              Product__c, Market__c, PercentageChangeDDDDollars__c, PercentageChangeDDDunits__c, 
                                                              DDD_Dollars__c, DDD_Units__c, TRx__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c ,Previous_Month_TRx__c
                                                              FROM MYBZ_Market_Share__c
                                                               WHERE division__c =: lstRegion[0].Parent__c and territory__c = null and 
                                                               District__c = null and  Region__c = null  and lillyProduct__c=true  
                                                               and LE_ID_PGP__c = null and LE_ID_IHS__c =null and  LoadIdentifier__c='AFFLTN' ];
                    
                }
            }
                
        }
       Object marketShare= marketshareProcessor(marketShareList, marketShareListNational, marketShareNationalPercentChange, marketShareListRegion, marketShareNationalPercentChange, marketShareListDistrict, marketShareDistrictPercentChange);
        return marketShare;
   }
   
    /* 
        * @Method Name                    :  marketshareProcessor
        * @Description                    :  Processor method utilised in every call out to form the marketshare JSON
        * @Return Type                    :  object
        * @Param                          :  none
   */
    global static Object marketshareProcessor(List<MYBZ_Market_Share__c> marketShareList, List<AggregateResult> ListmarketShareNational, List<MYBZ_Market_Share__c> ListmarketShareNationalPercentChange,  List<AggregateResult> ListmarketShareRegion, List<MYBZ_Market_Share__c> ListmarketShareRegionPercentChange, List<AggregateResult> ListmarketShareDistrict, List<MYBZ_Market_Share__c> ListmarketSharedistrictPercentChange) {  
        
        
        Map<String,MYBZ_Market_Share__c> nationalmarketshare=new Map<String,MYBZ_Market_Share__c>();
        Map<String,MYBZ_Market_Share__c> districtmarketshare=new Map<String,MYBZ_Market_Share__c>();
        Map<String,MYBZ_Market_Share__c> regionmarketshare=new Map<String,MYBZ_Market_Share__c>();
        
        Map<string, List<AggregateResult>> mapAggNat  = new Map<string, List<AggregateResult>>();
        Map<string, List<AggregateResult>> mapAggdis  = new Map<string, List<AggregateResult>>();
        Map<string, List<AggregateResult>> mapAggreg  = new Map<string, List<AggregateResult>>();
        String JsonString;
        
        
        
        if(!ListmarketShareRegionPercentChange.isEmpty()){
            
            for(MYBZ_Market_Share__c mo: ListmarketShareRegionPercentChange){
                string markProdMonthYearMS =  mo.Market__c+mo.product__c+mo.Month_Number__c+mo.Year_Number__c;   
                regionmarketshare.put(markProdMonthYearMS, mo);
            }
        }
        if(!ListmarketSharedistrictPercentChange.isEmpty()){
            
            for(MYBZ_Market_Share__c mo: ListmarketSharedistrictPercentChange){
                string markProdMonthYearMS =  mo.Market__c+mo.product__c+mo.Month_Number__c+mo.Year_Number__c; 
                districtmarketshare.put(markProdMonthYearMS, mo);
            }
        }
        if(!ListmarketShareNationalPercentChange.isEmpty()){
           
            for(MYBZ_Market_Share__c mo: ListmarketShareNationalPercentChange){
                string markProdMonthYearMS =  mo.Market__c+mo.product__c+mo.Month_Number__c+mo.Year_Number__c;    
                nationalmarketshare.put(markProdMonthYearMS, mo);
            }
        }
        if(!ListmarketShareRegion.isEmpty()){
            
            for(AggregateResult Agg : ListmarketShareRegion ) {
            string markMonthYear = (String)Agg.get('mar') + (String)Agg.get('mon') + (String)Agg.get('yr');
            if(mapAggReg.containsKey((markMonthYear))) {            
             mapAggReg.get(markMonthYear).add(Agg);
            }else {
             mapAggReg.put(markMonthYear , new list<AggregateResult> {Agg});
            }
          }  
        }  
         if(!ListmarketShareNational.isEmpty()){
             
             for(AggregateResult Agg : ListmarketShareNational ) {
            string markMonthYear = (String)Agg.get('mar') + (String)Agg.get('mon') + (String)Agg.get('yr');
            if(mapAggNat.containsKey((markMonthYear))) {            
             mapAggNat.get(markMonthYear).add(Agg);
            }else {
            mapAggNat.put(markMonthYear , new list<AggregateResult> {Agg});
            }
          }    
   
        }
        
        if(!ListmarketShareDistrict.isEmpty()){
            
           for(AggregateResult Agg : ListmarketShareDistrict ) {
            string markMonthYear = (String)Agg.get('mar') + (String)Agg.get('mon') + (String)Agg.get('yr');
            if(mapAggDis.containsKey((markMonthYear))) {            
             mapAggDis.get(markMonthYear).add(Agg);
            }else {
            mapAggDis.put(markMonthYear , new list<AggregateResult> {Agg});
            }
          }  
          
        }
        
        JSONGenerator generator= JSON.createGenerator(true);                 
        generator.writeStartObject();    
        generator.writeFieldName(System.Label.Mybz_markets);
        generator.writeStartArray();
        //Initializing variables
        String Year='';
        String Month;
        String Products='';
        String Market ='';       
        Integer firstMarketIteration=1;           
        Integer firstMonthIteration=1;  
        Integer firstProductIteration=1;
        
        
        for(MYBZ_Market_Share__c ObjMarketShare  : marketShareList ){ 
        
            if(ObjMarketShare.Market__c != null){
                if(!Market.equals(ObjMarketShare.Market__c)){
                    Market = ObjMarketShare.Market__c;                      
                    if(firstMarketIteration!=1){
                        // Month object
                        generator.writeEndArray();  
                        generator.writeEndObject();
                        // End Previous market
                        generator.writeEndArray();
                        generator.writeEndObject();                     
                    }
                        firstMarketIteration = 0;
                        // New Market Starts    
                        generator.writeStartObject();
                        generator.writeStringField(System.Label.MYBZ_market,ObjMarketShare.Market__c);
                  
                        generator.writeFieldName(System.Label.MYBZ_data);
                        generator.writeStartArray();
                        firstMonthiteration=1;
                        Year = '';
                        Month ='';
                        Products='';    
                    }
            }   
                
            if(ObjMarketShare.Year_Number__c != null){
                if(!Year.equals(String.Valueof(ObjMarketShare.Year_Number__c))){
                    Year = String.Valueof(ObjMarketShare.Year_Number__c);
                    Month ='';
                }
            }   
            
            if(ObjMarketShare.Month_Number__c != null){
                if(!Month.equals(String.Valueof(ObjMarketShare.Month_Number__c))){
                    Month = String.Valueof(ObjMarketShare.Month_Number__c);
                    if(firstMonthiteration!=1){
                        // Previous month object
                        generator.writeEndArray();  
                        generator.writeEndObject();
                    }
                        firstMonthiteration=0;                          
                        generator.writeStartObject();   
                        firstProductIteration=1;
                        if(ObjMarketShare.Year_Number__c != null){                          
                            generator.writeStringField(System.Label.MYBZ_month,Month);
                        }
                        generator.writeStringField(System.Label.MYBZ_Year,Year);
                        generator.writeFieldName(System.Label.MYBZ_Products);
                        generator.writeStartArray();
                        Products='';    
                }                   
            }
            
            if(ObjMarketShare.Product__c != null){              
                    
                    firstProductIteration=0;                        
                    generator.writeStartObject(); 
                    if(ObjMarketShare.TRx__c !=null){
                        generator.writeNumberField(System.Label.MYBZ_trx,ObjMarketShare.TRx__c);
                    }else{    
                        generator.writeNullField(System.Label.MYBZ_trx);
                    }
                              
                    if(ObjMarketShare.percentageChangeFromPreviousMonth__c != null){
                        generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,ObjMarketShare.percentageChangeFromPreviousMonth__c);
                    }else{
                        generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx);
                    }
                    generator.writeStringField(System.Label.MYBZ_productName,ObjMarketShare.Product__r.Name);
                    generator.writeBooleanField(System.Label.MYBZ_lillyProduct,ObjMarketShare.lillyProduct__c);
                    
                    if(ObjMarketShare.DDD_Units__c!=null){
                        generator.writeNumberField(System.Label.MYBZ_dddUnits,ObjMarketShare.DDD_Units__c);
                    }
                    else{    
                        generator.writeNullField(System.Label.MYBZ_dddUnits);
                    }
                                  
                    if(ObjMarketShare.Previous_DDD_Units__c != null){
                        generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,ObjMarketShare.PercentageChangeDDDunits__c);
                    }else{
                        generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                    }
                    if(ObjMarketShare.Previous_DDD_Dollars__c  != null){
                        generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,ObjMarketShare.PercentageChangeDDDDollars__c);
                    } else{
                        generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                    }
                    if(ObjMarketShare.DDD_Dollars__c!=null )
                        generator.writeNumberField(System.Label.MYBZ_dddDollars,ObjMarketShare.DDD_Dollars__c);   
                     else 
                    generator.writeNullField(System.Label.MYBZ_dddDollars); 
                    
                    if(ObjmarketShare.Gross_Margin__c!=null )
                        generator.writeNumberField(System.Label.MYBZ_grossMargins,ObjmarketShare.Gross_Margin__c);   
                    else 
                        generator.writeNullField(System.Label.MYBZ_grossMargins);
                        
                    // Clearing global static  variables
                    Decimal TotalTrx = 0;
                    Decimal TotalPrevTrx = 0;
                    Decimal TotalDDD =0;
                    Decimal TotalPrevDDD = 0;
                    Decimal TotalTrxDis=0;
                    Decimal TotalPrevTrxDis=0;
                    Decimal TotalTrxReg=0;
                    Decimal TotalPrevTrxReg=0;
                    Decimal TotalDDDDis=0; 
                    Decimal TotalDDDReg=0; 
                    Decimal TotalPrevDDDDis=0;
                    Decimal TotalPrevDDDReg=0;   
                    string markMonthYearMS =  ObjmarketShare.Market__c+ObjmarketShare.Month_Number__c+ObjmarketShare.Year_Number__c; 
                    string markProdMonthYearMS =  ObjmarketShare.Market__c+ObjmarketShare.product__c+ObjmarketShare.Month_Number__c+ObjmarketShare.Year_Number__c;
                        
                    generator.writeFieldName(System.Label.MYBZ_geolevelcomparison);                     
                    generator.writeStartObject();       
                    // National
                    generator.writeFieldName(System.Label.MYBZ_National);                          
                    generator.writeStartObject();
                    if(ObjmarketShare.lillyProduct__c){
                        if(!mapAggNat.isempty() ) {
                            if(mapAggNat.get(markMonthYearMS)!=null){
                                if(mapAggNat.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                        TotalTrx=(Decimal)mapAggNat.get(markMonthYearMS).get(0).get('TotTrx');                                          
                                    if(mapAggNat.get(markMonthYearMS).get(0).get('TotDDD')!=null)
                                        TotalDDD=(Decimal)mapAggNat.get(markMonthYearMS).get(0).get('TotDDD'); 
                                    if(mapAggNat.get(markMonthYearMS).get(0).get('TotPrevTrx') != null)
                                        TotalPrevTrx = (Decimal)mapAggNat.get(markMonthYearMS).get(0).get('TotPrevTrx');
                                    if(mapAggNat.get(markMonthYearMS).get(0).get('TotPrevDDD')!=null)
                                        TotalPrevDDD=(Decimal)mapAggNat.get(markMonthYearMS).get(0).get('TotPrevDDD');  
                                }
                            }
                            
                            if(TotalTrx!=0){
                                    if(nationalmarketshare.get(markProdMonthYearMS)!=null){
                                        if(nationalmarketshare.get(markProdMonthYearMS).Trx__c != null)
                                            generator.writeNumberField(System.Label.MYBZ_Percentage,(nationalmarketshare.get(markProdMonthYearMS).Trx__c/TotalTrx) );
                                        else
                                            generator.writeNullField(System.Label.MYBZ_Percentage);         
                                                                            
                                        if(TotalPrevTrx!=0 && ObjmarketShare.PREVIOUS_MONTH_TRX__C != null && nationalmarketshare.get(markProdMonthYearMS).PREVIOUS_MONTH_TRX__C != null && nationalmarketshare.get(markProdMonthYearMS).Trx__c != null ){
                                            
                                            Decimal percentageChangeNationalPrevTrx = nationalmarketshare.get(markProdMonthYearMS).PREVIOUS_MONTH_TRX__C/TotalPrevTrx;
                                            generator.writeNumberField(System.Label.MYBZ_PercentageChange,((nationalmarketshare.get(markProdMonthYearMS).Trx__c/TotalTrx) - percentageChangeNationalPrevTrx)) ;
                                                 
                                        }
                                        else{
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                        }                                   
                                    }
                                    else{
                                            generator.writeNullField(System.Label.MYBZ_Percentage);
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                    }                                       
                                    
                            }else if(TotalDDD!=0){
                                    if(nationalmarketshare.get(markProdMonthYearMS)!=null){
                                        if(nationalmarketshare.get(markProdMonthYearMS).DDD_Units__c != null)
                                            generator.writeNumberField(System.Label.MYBZ_Percentage,(nationalmarketshare.get(markProdMonthYearMS).DDD_Units__c /TotalDDD) );
                                        else
                                            generator.writeNullField(System.Label.MYBZ_Percentage);                 
                                                            
                                                                        
                                        if(TotalPrevDDD!=0 && ObjmarketShare.PREVIOUS_DDD_UNITS__C != null && nationalmarketshare.get(markProdMonthYearMS).PREVIOUS_DDD_UNITS__C != null && nationalmarketshare.get(markProdMonthYearMS).DDD_Units__c != null ){
                                            
                                            Decimal percentageChangeNationalPrevDDD = nationalmarketshare.get(markProdMonthYearMS).PREVIOUS_DDD_UNITS__C/TotalPrevDDD;
                                            generator.writeNumberField(System.Label.MYBZ_PercentageChange,((nationalmarketshare.get(markProdMonthYearMS).DDD_Units__c/TotalDDD) - percentageChangeNationalPrevDDD)) ;
                                                 
                                        }
                                        else{
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                        }
                                    }
                                    else{
                                            generator.writeNullField(System.Label.MYBZ_Percentage);
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                    }                               
                                        
                            }else { // if total DDD =0
                                    generator.writeNullField(System.Label.MYBZ_Percentage);
                                    generator.writeNullField(System.Label.MYBZ_PercentageChange);
                            }
                        }else { 
                            //if marketshare  lilly product
                            generator.writeNullField(System.Label.MYBZ_Percentage);
                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                        } 
                        generator.writeEndObject(); 
                        
                        generator.writeFieldName(System.Label.MYBZ_District);                          
                        generator.writeStartObject();
                        if(ObjmarketShare.lillyProduct__c){
                            if(!mapAggDis.isempty() ){
                                if(mapAggDis.get(markMonthYearMS)!=null){
                                    if(mapAggDis.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                        TotalTrxDis=(Decimal)mapAggDis.get(markMonthYearMS).get(0).get('TotTrx');
                                    if(mapAggDis.get(markMonthYearMS).get(0).get('TotDDD')!=null)
                                        TotalDDDDis=(Decimal)mapAggDis.get(markMonthYearMS).get(0).get('TotDDD');
                                    if(mapAggDis.get(markMonthYearMS).get(0).get('TotPrevTrx') != null)
                                        TotalPrevTrxDis = (Decimal)mapAggDis.get(markMonthYearMS).get(0).get('TotPrevTrx');
                                    if(mapAggDis.get(markMonthYearMS).get(0).get('TotPrevDDD')!=null)
                                        TotalPrevDDDDis = (Decimal)mapAggDis.get(markMonthYearMS).get(0).get('TotPrevDDD');             
                                }                        
                            }   
                                   
                            if(TotalTrxDis!=0 ){
                               ////
                                if(districtmarketshare.get(markProdMonthYearMS)!=null){                          
                                 if(districtmarketshare.get(markProdMonthYearMS).Trx__c != null)
                                        generator.writeNumberField(System.Label.MYBZ_Percentage,(districtmarketshare.get(markProdMonthYearMS).Trx__c/TotalTrxDis) );
                                    else
                                        generator.writeNullField(System.Label.MYBZ_Percentage);     
                                                                    
                                    if(TotalPrevTrxDis!=0 && ObjmarketShare.PREVIOUS_MONTH_TRX__C != null && districtmarketshare.get(markProdMonthYearMS).PREVIOUS_MONTH_TRX__C != null && districtmarketshare.get(markProdMonthYearMS).Trx__c != null ){
                                        
                                        Decimal percentageChangeDistrictPrevTrx = districtmarketshare.get(markProdMonthYearMS).PREVIOUS_MONTH_TRX__C/TotalPrevTrxDis;
                                        generator.writeNumberField(System.Label.MYBZ_PercentageChange,((districtmarketshare.get(markProdMonthYearMS).Trx__c/TotalTrxDis) - percentageChangeDistrictPrevTrx)) ;
                                             
                                    }
                                    else{
                                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                    }                                   
                                }
                                else{
                                        generator.writeNullField(System.Label.MYBZ_Percentage);
                                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                }       
                               ////                         
                                    
                            }else if(TotalDDDDis!=0 ){  
                                 ////
                                 if(districtmarketshare.get(markProdMonthYearMS)!=null){
                                    if(districtmarketshare.get(markProdMonthYearMS).DDD_Units__c != null)
                                        generator.writeNumberField(System.Label.MYBZ_Percentage,(districtmarketshare.get(markProdMonthYearMS).DDD_Units__c /TotalDDDDis) );
                                    else
                                        generator.writeNullField(System.Label.MYBZ_Percentage); 
                                                                    
                                    if(TotalPrevDDDDis!=0 && ObjmarketShare.PREVIOUS_DDD_UNITS__C != null && districtmarketshare.get(markProdMonthYearMS).PREVIOUS_DDD_UNITS__C != null && districtmarketshare.get(markProdMonthYearMS).DDD_Units__c != null ){
                                        
                                        Decimal percentageChangeDistirctPrevDDD = districtmarketshare.get(markProdMonthYearMS).PREVIOUS_DDD_UNITS__C/TotalPrevDDDDis;
                                        generator.writeNumberField(System.Label.MYBZ_PercentageChange,((districtmarketshare.get(markProdMonthYearMS).DDD_Units__c/TotalDDDDis) - percentageChangeDistirctPrevDDD)) ;
                                             
                                    }
                                    else{
                                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                    }
                                }
                                else{
                                        generator.writeNullField(System.Label.MYBZ_Percentage);
                                        generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                }   
                                 ////
                            }   
                            else {
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
                        if(ObjmarketShare.lillyProduct__c){
                            if(!mapAggReg.isempty() ){
                                if(mapAggReg.get(markMonthYearMS)!=null){
                                    if(mapAggReg.get(markMonthYearMS).get(0).get('TotTrx')!=null)
                                        TotalTrxReg=(Decimal)mapAggReg.get(markMonthYearMS).get(0).get('TotTrx');
                                    if(mapAggReg.get(markMonthYearMS).get(0).get('TotDDD')!=null)
                                        TotalDDDReg=(Decimal)mapAggReg.get(markMonthYearMS).get(0).get('TotDDD');
                                    if(mapAggReg.get(markMonthYearMS).get(0).get('TotPrevTrx') != null)
                                        TotalPrevTrxReg = (Decimal)mapAggReg.get(markMonthYearMS).get(0).get('TotPrevTrx');
                                    if(mapAggReg.get(markMonthYearMS).get(0).get('TotPrevDDD')!=null)
                                        TotalPrevDDDReg = (Decimal)mapAggReg.get(markMonthYearMS).get(0).get('TotPrevDDD');     
                                }
                            }
                            
                            if(TotalTrxReg!=0){                                                   
                                    ////
                                    if(regionmarketshare.get(markProdMonthYearMS)!=null){                            
                                     if(regionmarketshare.get(markProdMonthYearMS).Trx__c != null)
                                            generator.writeNumberField(System.Label.MYBZ_Percentage,(regionmarketshare.get(markProdMonthYearMS).Trx__c/TotalTrxReg) );
                                        else
                                            generator.writeNullField(System.Label.MYBZ_Percentage);     
                                            
                                        if(TotalPrevTrxReg!=0 && ObjmarketShare.PREVIOUS_MONTH_TRX__C != null && regionmarketshare.get(markProdMonthYearMS).PREVIOUS_MONTH_TRX__C != null && regionmarketshare.get(markProdMonthYearMS).Trx__c != null ){
                                            
                                            Decimal percentageChangeRegionPrevTrx = regionmarketshare.get(markProdMonthYearMS).PREVIOUS_MONTH_TRX__C/TotalPrevTrxReg;
                                            generator.writeNumberField(System.Label.MYBZ_PercentageChange,((regionmarketshare.get(markProdMonthYearMS).Trx__c/TotalTrxReg) - percentageChangeRegionPrevTrx)) ;
                                                 
                                        }
                                        else{
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                        }                                   
                                    }
                                    else{
                                            generator.writeNullField(System.Label.MYBZ_Percentage);
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                    }       
                                   ////     
                            } else if (TotalDDDReg!=0){ 
                                   ////
                                     if(regionmarketshare.get(markProdMonthYearMS)!=null){
                                        if(regionmarketshare.get(markProdMonthYearMS).DDD_Units__c != null)
                                            generator.writeNumberField(System.Label.MYBZ_Percentage,(regionmarketshare.get(markProdMonthYearMS).DDD_Units__c /TotalDDDReg) );
                                        else
                                            generator.writeNullField(System.Label.MYBZ_Percentage); 
                                                                        
                                        if(TotalPrevDDDReg!=0 && ObjmarketShare.PREVIOUS_DDD_UNITS__C != null && regionmarketshare.get(markProdMonthYearMS).PREVIOUS_DDD_UNITS__C != null && regionmarketshare.get(markProdMonthYearMS).DDD_Units__c != null ){
                                            
                                            Decimal percentageChangeRegionPrevDDD = regionmarketshare.get(markProdMonthYearMS).PREVIOUS_DDD_UNITS__C/TotalPrevDDDReg;
                                            generator.writeNumberField(System.Label.MYBZ_PercentageChange,((regionmarketshare.get(markProdMonthYearMS).DDD_Units__c/TotalDDDReg) - percentageChangeRegionPrevDDD)) ;
                                                 
                                        }
                                        else{
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                        }
                                    }
                                    else{
                                            generator.writeNullField(System.Label.MYBZ_Percentage);
                                            generator.writeNullField(System.Label.MYBZ_PercentageChange);
                                    }   
                                 ////                           
                                    
                            }else{ 
                                    //else for if of Total dd unit ==0
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
                                                        
                    // Ending Product       
                    generator.writeEndObject(); 
                }
                    
            }
        
                
        // Month object
        generator.writeEndArray();  
        generator.writeEndObject();
        // End Previous market
        generator.writeEndArray();
        generator.writeEndObject(); 
        
        generator.writeEndArray();    
        generator.writeEndObject();                
               
        JsonString = generator.getAsString();
        System.debug('--MarketShare'+JsonString);
        System.debug('++++Heap size' + Limits.getHeapSize());
        Object marketShare = Json.deserializeUntyped(JsonString); 
        return marketShare;
                   
    }
    
   
    
                
    /* 
        * @Method Name                    :  accountSummary
        * @Description                    :  Method used to generate Marketshare JSON for Account manager(Affiliation screen) on default account summary screen at account level data.hence no geo alignment considered in where clause                               
        * @Return Type                    :  object
        * @Param                          :  boolean
    */ 
    @RemoteAction
    global static Object accountSummary(Boolean flagAff){
    
        system.debug('Inside Account Summary');
        // Initialization
        List<MYBZ_PriorityAccount__c> lstProrityAccount = new List<MYBZ_PriorityAccount__c>();
        List<MYBZ_Market_Share__c> lstMarketShareAlignAM = new List<MYBZ_Market_Share__c>();
        User objUser = new User();
        String GlobalIdAM;
        String Role;
        
        // System/PGP Names
        List<String> lstIHSNamesAM = new List<String>();
        List<String> lstPGPNamesAM= new List<String>();      
        List<User> lstUser = new List<User>();
        
        // Fetch user information
        lstUser = fetchUserInfo();
        
        
        //Assignment of Global Id and Role
        if(!lstUser.isEmpty()){
            Role = lstUser[0].MYBZ_Role__c;
            if(flagAff == false && lstUser[0].MYBZ_Role__c == System.Label.MYBZ_AccountManager  && lstUser[0].MYBZ_Reporting_ID__c !=null){
                GlobalIdAM=lstUser[0].MYBZ_Reporting_ID__c;
            }else{
                GlobalIdAM = lstUser[0].Prsnl_Nbr_GLBL__c;
            }
        }        
                
        if(!String.isBlank(GlobalIdAM)){
            // Prioritised Accounts and Alignment Query  
            lstProrityAccount = [SELECT Global_Id__c, LE_ID_IHS__c,LE_ID_PGP__c,system__c,System__r.name FROM MYBZ_PriorityAccount__c WHERE Global_Id__c =:GlobalIdAM];
            lstMarketShareAlignAM =[SELECT district__c, territory__c  FROM MYBZ_Market_Share__c  WHERE Global_Id__c =:GlobalIdAM and LoadIdentifier__c='NON_AFFLTN' LIMIT 1];

            
            if(!lstProrityAccount.isEmpty()){
                for(MYBZ_PriorityAccount__c objProrityAccount: lstProrityAccount){
                    if(objProrityAccount.LE_ID_PGP__c != '' && objProrityAccount.LE_ID_PGP__c != null){
                        lstPGPNamesAM.add(objProrityAccount.LE_ID_PGP__c);
                    }else{
                        lstIHSNamesAM.add(objProrityAccount.LE_ID_IHS__c);
                    }
                }        
            }
            
        }
        Object marketShare= marketshareProcessorAM(lstIHSNamesAM, lstPGPNamesAM, lstMarketShareAlignAM);
        return marketShare;     
    }                 
   
    
    /* 
        * @Method Name                    :  marketshareProcessorAM
        * @Description                    :  Processor method utilised in every call out to form the marketshare JSON for Account Summary Screen
        * @Return Type                    :  object
        * @Param                          :  List<String>, List<String>, List<MYBZ_Market_Share__c>
   */   
    global static Object marketshareProcessorAM(List<String> lstIHSNames, List<String> lstPGPNames, List<MYBZ_Market_Share__c> lstMarketShareAlign) { 
    
        // Initialization
        String strlstMarketShareAccSum = '';
        String strlstMarketShare;
        Map<String,Decimal> districtGrossMarginAM =new Map<String,Decimal>();
        String JsonString;
        String AFFLTN = 'AFFLTN';
        
        if(!lstMarketShareAlign.isEmpty()){
            Id DistrictId = lstMarketShareAlign[0].district__c;
            strlstMarketShareAccSum = 'SELECT id, Gross_Margin__c,District__c, Month__c ,Year__c ,territory__c,Global_Id__c,Owner__c, Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name FROM MYBZ_Market_Share__c  WHERE LoadIdentifier__c=:AFFLTN and district__c =:DistrictId and territory__c = null';
        
        }
        // Calculation of grossdistrictsummary
        if(!String.isBlank(strlstMarketShareAccSum)){
                
            for(MYBZ_Market_Share__c mo: Database.Query(strlstMarketShareAccSum)){
                string markProdMonthYearMS =  mo.Market__c+mo.product__c+mo.Month_Number__c+mo.Year_Number__c;                
                if(mo.Gross_Margin__c != null){
                    districtGrossMarginAM.put(markProdMonthYearMS,mo.Gross_Margin__c);
                }else{
                    districtGrossMarginAM.put(markProdMonthYearMS,mo.Gross_Margin__c);
                }
            }
        }
        strlstMarketShare = '';
        if(!lstIHSNames.isEmpty() || !lstPGPNames.isEmpty()){
            strlstMarketShare = 'SELECT Id, Region__c, Gross_Margin__c,District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, LE_ID_PGP__c,PGP__r.ID,system__r.Name,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c, Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c, Previous_DDD_Dollars__c,LE_ID_IHS__c,system__c, system__r.ID, PGP__c, PGP__r.name FROM MYBZ_Market_Share__c WHERE LoadIdentifier__c=:AFFLTN and (division__c = null and District__c = null and Region__c = null and territory__c = null) and ((LE_ID_IHS__c in :lstIHSNames and LE_ID_PGP__c = null) or (LE_ID_PGP__c in :lstPGPNames)) order by system__r.Name, PGP__r.name, Market__c, Year__c, Month__c asc, Product__r.Name desc';           
        }
        
    
        
        JSONGenerator generator= JSON.createGenerator(true); 
        
        //Returns a new JSON Generator
        generator = JSON.createGenerator(true);
        
        // generator.writeStartArray();  
        generator.writeStartObject(); 
        
        //Initializing variables
        String Year='';
        String Month;
        String Products='';
        String Market ='';
        String SystemPGPId ='';
        String SystemPGPName ='';
        Integer firstSystemPGPIteration=1;
        Integer firstMarketIteration=1;           
        Integer firstMonthIteration=1;  
        Integer firstProductIteration=1;
        
        if(!String.isBlank(strlstMarketShare)){
            
            //generator.writeStartObject();
            generator.writeFieldName(System.Label.Mybz_summaryData);
            generator.writeStartObject();
            generator.writeFieldName(System.Label.Mybz_accounts);
            generator.writeStartArray();
            // Market Share list must be ordered
            for(MYBZ_Market_Share__c ObjMarketShare  : Database.query(strlstMarketShare)){ 
            
                if(ObjMarketShare.PGP__c == null &&  ObjMarketShare.System__c==null){
                    continue;
                }  
                
                if(ObjMarketShare.PGP__c != null){
                    if(!SystemPGPId.equals(String.Valueof(ObjMarketShare.PGP__c))){
                        if(firstSystemPGPIteration!=1){
                            // Month object
                            generator.writeEndArray();  
                            generator.writeEndObject();
                            // End Previous market
                            generator.writeEndArray();
                            generator.writeEndObject();  
                            generator.writeEndArray();
                            generator.writeEndObject();                     
                        }
                        firstSystemPGPIteration = 0;
                        generator.writeStartObject();
                        SystemPGPId =ObjMarketShare.PGP__c;
                        generator.writeStringField(System.Label.Mybz_name,ObjMarketShare.PGP__r.Name);
                        if(ObjMarketShare.System__c != null){
                            generator.writeStringField(System.Label.mybz_associationName,ObjMarketShare.System__r.Name);
                        }else{
                            generator.writeNullField(System.Label.mybz_associationName); 
                        }
                        generator.writeFieldName(System.Label.Mybz_markets);
                        // MarketShareData Starts
                        generator.writeStartArray();
                        firstMarketIteration=1;
                        Market= '';
                        Year = '';
                        Month='';   
                        Products='';
                        
                    }   
                }else {
                    if(!SystemPGPId.equals(String.Valueof(ObjMarketShare.System__c))){
                        if(firstSystemPGPIteration!=1){
                            // Month object
                            generator.writeEndArray();  
                            generator.writeEndObject();
                            // End Previous market
                            generator.writeEndArray();
                            generator.writeEndObject();  
                            generator.writeEndArray();
                            generator.writeEndObject();                     
                        }
                        firstSystemPGPIteration = 0;
                        generator.writeStartObject();
                        SystemPGPId =ObjMarketShare.System__c;
                        generator.writeStringField(System.Label.Mybz_name,ObjMarketShare.System__r.Name);    
                        generator.writeStringField(System.Label.mybz_associationName,ObjMarketShare.System__r.Name);
                        generator.writeFieldName(System.Label.Mybz_markets);
                        // MarketShareData Starts
                        generator.writeStartArray();
                        firstMarketIteration=1;
                        Market= '';
                        Year = '';
                        Month='';   
                        Products='';                                    
                    }
                }
                
                if(ObjMarketShare.Market__c != null){
                    if(!Market.equals(ObjMarketShare.Market__c)){
                        Market = ObjMarketShare.Market__c;                      
                        if(firstMarketIteration!=1){
                            // Month object
                            generator.writeEndArray();  
                            generator.writeEndObject();
                            // End Previous market
                            generator.writeEndArray();
                            generator.writeEndObject();                     
                        }
                            firstMarketIteration = 0;
                            // New Market Starts    
                            generator.writeStartObject();
                            generator.writeStringField(System.Label.MYBZ_market,ObjMarketShare.Market__c);
                      
                            generator.writeFieldName(System.Label.MYBZ_data);
                            generator.writeStartArray();
                            firstMonthiteration=1;
                            Year = '';
                            Month ='';
                            Products='';    
                        }
                }   
                
                if(ObjMarketShare.Year_Number__c != null){
                    if(!Year.equals(String.Valueof(ObjMarketShare.Year_Number__c))){
                        Year = String.Valueof(ObjMarketShare.Year_Number__c);
                        Month ='';
                    }
                }   
                
                if(ObjMarketShare.Month_Number__c != null){
                    if(!Month.equals(String.Valueof(ObjMarketShare.Month_Number__c))){
                        Month = String.Valueof(ObjMarketShare.Month_Number__c);
                        if(firstMonthiteration!=1){
                            // Previous month object
                            generator.writeEndArray();  
                            generator.writeEndObject();
                        }
                            firstMonthiteration=0;                          
                            generator.writeStartObject();   
                            firstProductIteration=1;
                            if(ObjMarketShare.Year_Number__c != null){                          
                                generator.writeStringField(System.Label.MYBZ_month,Month);
                            }
                            generator.writeStringField(System.Label.MYBZ_Year,Year);
                            generator.writeFieldName(System.Label.MYBZ_Products);
                            generator.writeStartArray();
                            Products='';    
                    }                   
                }
                
                if(ObjMarketShare.Product__c != null){
                    
                        
                        firstProductIteration=0;                        
                        generator.writeStartObject(); 
                        if(ObjMarketShare.TRx__c !=null){
                            generator.writeNumberField(System.Label.MYBZ_trx,ObjMarketShare.TRx__c);
                        }else{    
                            generator.writeNullField(System.Label.MYBZ_trx);
                        }
                                  
                        if(ObjMarketShare.percentageChangeFromPreviousMonth__c != null){
                            generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx,ObjMarketShare.percentageChangeFromPreviousMonth__c);
                        }else{
                            generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthTRx);
                        }
                        generator.writeStringField(System.Label.MYBZ_productName,ObjMarketShare.Product__r.Name);
                        generator.writeBooleanField(System.Label.MYBZ_lillyProduct,ObjMarketShare.lillyProduct__c);
                        
                        if(ObjMarketShare.DDD_Units__c!=null){
                            generator.writeNumberField(System.Label.MYBZ_dddUnits,ObjMarketShare.DDD_Units__c);
                        }
                        else{    
                            generator.writeNullField(System.Label.MYBZ_dddUnits);
                        }
                                      
                        if(ObjMarketShare.Previous_DDD_Units__c != null){
                            generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits,ObjMarketShare.PercentageChangeDDDunits__c);
                        }else{
                            generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDUnits);
                        }
                        if(ObjMarketShare.Previous_DDD_Dollars__c  != null){
                            generator.writeNumberField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars,ObjMarketShare.PercentageChangeDDDDollars__c);
                        } else{
                            generator.writeNullField(System.Label.MYBZ_percentageChangeFromPreviousMonthDDDDollars);
                        }
                        if(ObjMarketShare.DDD_Dollars__c!=null )
                            generator.writeNumberField(System.Label.MYBZ_dddDollars,ObjMarketShare.DDD_Dollars__c);   
                         else 
                        generator.writeNullField(System.Label.MYBZ_dddDollars); 
                        
                        string markProdMonthYearMS =  ObjMarketShare.Market__c+ObjMarketShare.product__c+ObjMarketShare.Month_Number__c+ObjMarketShare.Year_Number__c;
                        
                        if(districtGrossMarginAM.containsKey(markProdMonthYearMS)){  
                            if(districtGrossMarginAM.get(markProdMonthYearMS) != 0 && districtGrossMarginAM.get(markProdMonthYearMS) != null){
                                generator.writeNumberField(System.Label.MYBZ_grossMargins,districtGrossMarginAM.get(markProdMonthYearMS)); 
                            }else{
                                generator.writeNullField(System.Label.MYBZ_grossMargins);
                            }                                  
                        }else{
                            generator.writeNullField(System.Label.MYBZ_grossMargins);
                        }
                        
                        // Ending Product       
                        generator.writeEndObject(); 
                        
                }
            }
                
            // Month object
            generator.writeEndArray();  
            generator.writeEndObject();
            // End Previous market
            generator.writeEndArray();
            generator.writeEndObject();     
            //End PGP/System
            generator.writeEndArray();
            generator.writeEndObject();
            
                            
            //Labels ending
            //generator.writeEndArray();
            
        }
            generator.writeEndArray();    
            generator.writeEndObject();
            JsonString = generator.getAsString();
            System.debug('--MarketShare'+JsonString);
            System.debug('++++Heap size' + Limits.getHeapSize());
            System.debug('++++Heap size' + Limits.getLimitHeapSize());
            Object marketShare = Json.deserializeUntyped(JsonString); 
            return marketShare;
                   
    }                       
                    
}