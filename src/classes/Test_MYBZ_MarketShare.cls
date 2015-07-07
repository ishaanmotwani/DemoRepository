/*
*@ Class Name                                                    : Test_MYBZ_MarketShare
*@ Description                                                   : Test Class for MYBZ_MarketShare
*@ CreatedBy                                                     : 
*@ CreatedOn                                                     : 
*/
@isTest(seeAllData=false)
private class Test_MYBZ_MarketShare {
    
    static MYBZ_Region__c Region = New MYBZ_Region__c();
    static MYBZ_District__c District = New MYBZ_District__c();
    static MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory2 = New MYBZ_Territory__c();
    static List<MYBZ_Market_Share__c> marketShareList =new List<MYBZ_Market_Share__c>();
    static Object Obj;
    
    
    /*
    * @Method Name                    :  createUser
    * @Description                    :  method to create User for inserting data                                  
    * @Return Type                    :  User
    * @Param                          :      
    */
    public static User createUser(String Role){
        Profile pfl = [select id from profile where name='System Administrator'];
        //Declaring the User
        User runAsUser = new User(alias = 'BasicIHS', email='appBasicIhs@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c='xxxxx',MYBZ_Reporting_ID__c='xxxxx');
        
        Insert runAsUser;
        
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'MYBZ_Data_Load_User'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = runAsUser.Id;
            psa.PermissionSetId = ps.Id;
            insert psa;
        }
        Return runAsUser;
    }   
    
    
    /*
    * @Method Name                    :  insertTestMarketShareData
    * @Description                    :  method to testdat for market share        
    * @Return Type                    :  void
    * @Param                          :      
    */
    static void insertTestMarketShareData() {
        
        MYBZ_Product__c IHSProduct = New MYBZ_Product__c();
        IHSProduct.Name='EFFIENT'; 
        Insert IHSProduct;
        system.assert(IHSProduct.id!=null);
        
        MYBZ_Product__c IHSProduct2 = New MYBZ_Product__c();
        IHSProduct2.Name='TestProduct2'; 
        Insert IHSProduct2;
        system.assert(IHSProduct2.id!=null);
        
        MYBZ_Product__c IHSProduct3 = New MYBZ_Product__c();
        IHSProduct3.Name='TestProduct3'; 
        Insert IHSProduct3;
        system.assert(IHSProduct3.id!=null);
        
        MYBZ_IHS_Division__c Div = New MYBZ_IHS_Division__c();
        Div.Name='TestDivision';
        Insert Div;  
        system.assert(Div.id!=null);
        
        Region.Name='TestRegion';
        Region.Parent__c=Div.ID;
        Insert Region;
        system.assert(Region.id!=null);
        
        
        District.Name='TestDistrict';
        District.Region__c=Region.ID;
        Insert District;
        system.assert(District.id!=null);
        
        
        Territory.Name='TestTerritory';
        Territory.State__c = District.id;
        Insert Territory;
        system.assert(Territory.id!=null);
        
        Territory2.Name='TestTerritory2';
        Territory2.State__c = District.id;
        Insert Territory2;
        system.assert(Territory2.id!=null);
        
        MYBZ_Market_Share__c MarketShare = New MYBZ_Market_Share__c();
        MarketShare.Name='TestMarket';
        MarketShare.Market__c = 'Test Market 7';
        MarketShare.Global_Id__c='xxxxx';
        MarketShare.Market__c='test';
        MarketShare.Division__c = Div.id;
        MarketShare.District__c = District.id;
        MarketShare.Month__c=1;
        MarketShare.Owner__c='LILLY';
        MarketShare.Previous_Month_TRx__c=99;
        MarketShare.Product__c=IHSProduct.ID;
        MarketShare.Region__c=Region.ID;
        MarketShare.Territory__c=null;
        MarketShare.TRx__c=100;
        MarketShare.DDD_Dollars__c=1;
        MarketShare.Previous_DDD_Dollars__c=1;
        MarketShare.DDD_Units__c=1;
        MarketShare.Previous_DDD_Units__c=1;
        MarketShare.Year__c=2015;
        MarketShare.LoadIdentifier__c = 'NON_AFFLTN';
        MarketShare.LE_ID_IHS__c = 'Test IHS 1';
        MarketShare.LE_ID_PGP__c = 'Test PGP 1';
        Insert MarketShare;
        system.assert(MarketShare.id!=null);
        
        MYBZ_Market_Share__c MarketShare1 = New MYBZ_Market_Share__c();
        MarketShare1.Name='TestMarket';
        MarketShare1.Market__c = 'Test Market 7';
        MarketShare1.Global_Id__c='xxxxx';
        MarketShare1.Market__c='test';
        MarketShare1.Month__c=1;
        MarketShare1.Owner__c='LILLY';
        MarketShare1.Division__c = Div.id;
        MarketShare1.District__c = District.id;
        MarketShare1.Previous_Month_TRx__c=90;
        MarketShare1.Product__c=IHSProduct2.ID;
        MarketShare1.Region__c=Region.ID;
        MarketShare1.Territory__c=null;
        MarketShare1.TRx__c=80;
        MarketShare1.DDD_Dollars__c=1;
        MarketShare1.Previous_DDD_Dollars__c=1;
        MarketShare1.DDD_Units__c=1;
        MarketShare1.Previous_DDD_Units__c=1;
        MarketShare1.Year__c=2015;
        MarketShare1.Month__c = 1;
        MarketShare1.Year__c = 2015;
        MarketShare1.LE_ID_IHS__c = 'Test IHS 3';
        MarketShare1.LE_ID_PGP__c = 'Test PGP 3';
        MarketShare1.LoadIdentifier__c = 'NON_AFFLTN';
        Insert MarketShare1;
        marketShareList.add(MarketShare1);
        system.assert(MarketShare1.id!=null);
        
        MYBZ_Market_Share__c MarketShare2 = New MYBZ_Market_Share__c();
        MarketShare2.Name='TestMarket';
        MarketShare2.Market__c = 'Test Market 7';
        MarketShare2.Global_Id__c='yyyyy';
        MarketShare2.Market__c='test';
        MarketShare2.Month__c=1;
        MarketShare2.Previous_Month_TRx__c=9;
        MarketShare2.TRx__c=10;
        MarketShare2.DDD_Dollars__c=2;
        MarketShare2.Previous_DDD_Dollars__c=2;        
        MarketShare2.DDD_Units__c=2;
        MarketShare2.Previous_DDD_Units__c=2;
        MarketShare2.Owner__c='COMPETITOR';
        MarketShare2.Previous_Month_TRx__c=1;
        MarketShare2.Product__c=IHSProduct2.ID;
        MarketShare2.Region__c=Region.ID;
        MarketShare2.Territory__c=Territory2.ID;
        MarketShare2.Year__c=2015;
        MarketShare2.Month__c = 2;
        MarketShare2.Year__c = 2015;
        MarketShare2.LE_ID_IHS__c = 'Test IHS 3';
        MarketShare2.LE_ID_PGP__c = 'Test PGP 3';
        MarketShare2.LoadIdentifier__c = 'AFFLTN';
        Insert MarketShare2;
        marketShareList.add(MarketShare2);
        system.assert(MarketShare2.id!=null); 
        
        MYBZ_Market_Share__c MarketShare3 = New MYBZ_Market_Share__c();
        MarketShare3.Name='TestMarket';
        MarketShare3.Global_Id__c='xxxxx';
        MarketShare3.Market__c='test';
        MarketShare3.Month__c=2;
        MarketShare3.Owner__c='LILLY';
        MarketShare3.Previous_Month_TRx__c=8;
        MarketShare3.TRx__c=10;
        MarketShare3.DDD_Dollars__c=3;
        MarketShare3.Previous_DDD_Dollars__c=3;
        MarketShare3.DDD_Units__c=3;
        MarketShare3.Previous_DDD_Units__c=3;
        MarketShare3.Division__c = Div.id;
        MarketShare3.District__c = District.id;
        MarketShare3.Product__c=IHSProduct.ID;
        MarketShare3.Region__c=Region.ID;
        MarketShare3.Territory__c=Territory.ID;
        MarketShare3.Year__c=2015;
        MarketShare3.Month__c = 2;
        MarketShare3.Year__c = 2015;
        MarketShare3.LE_ID_IHS__c = 'Test IHS 2';
        MarketShare3.LE_ID_PGP__c = 'Test PGP 2';
        MarketShare3.LoadIdentifier__c = 'AFFLTN';
        Insert MarketShare3;
        marketShareList.add(MarketShare3);
        system.assert(MarketShare3.id!=null);       
        
        MYBZ_Market_Share__c MarketShare4 = New MYBZ_Market_Share__c();
        MarketShare4.Name='TestMarket';
        MarketShare4.Market__c = 'Test Market 7';
        MarketShare4.Global_Id__c='xxxxx';
        MarketShare4.Market__c='test';
        MarketShare4.Month__c=2;
        MarketShare4.Previous_Month_TRx__c=7;
        MarketShare4.TRx__c=10;
        MarketShare4.DDD_Dollars__c=4;
        MarketShare4.Previous_DDD_Dollars__c=3;
        MarketShare4.DDD_Units__c=4;
        MarketShare4.Previous_DDD_Units__c=4;
        MarketShare4.Owner__c='LILLY';
        MarketShare4.Division__c = Div.id;
        MarketShare4.District__c = District.id;
        MarketShare4.Product__c=IHSProduct2.ID;
        MarketShare4.Region__c=Region.ID;
        MarketShare4.Territory__c=Territory.ID;
        MarketShare4.Year__c=2015;
        MarketShare4.Month__c = 4;
        MarketShare4.Year__c = 2015;
        MarketShare4.LE_ID_IHS__c = 'Test IHS 4';
        MarketShare4.LE_ID_PGP__c = 'Test PGP 4';
        MarketShare4.LoadIdentifier__c = 'NON_AFFLTN';
        Insert MarketShare4;
        marketShareList.add(MarketShare4);
        system.assert(MarketShare4.id!=null); 
        
        MYBZ_Market_Share__c MarketShare5 = New MYBZ_Market_Share__c();
        MarketShare5.Name='TestMarket';
        MarketShare5.Market__c = 'Test Market 7';
        MarketShare5.Global_Id__c='xxxxx';
        MarketShare5.Market__c='test';
        MarketShare5.Month__c=3;
        MarketShare5.Previous_Month_TRx__c=7;
        MarketShare5.TRx__c=15;
        MarketShare5.Owner__c='LILLY';
        MarketShare5.DDD_Dollars__c=5;
        MarketShare5.Previous_DDD_Dollars__c=4;
        MarketShare5.DDD_Units__c=5;
        MarketShare5.Previous_DDD_Units__c=5;
        MarketShare5.Division__c = Div.id;
        MarketShare5.District__c = null;       
        MarketShare5.Product__c=IHSProduct.ID;
        MarketShare5.Region__c=Region.ID;
        MarketShare5.Territory__c=null;
        MarketShare5.Previous_Month_TRx__c=0;
        MarketShare5.TRx__c=10;
        MarketShare5.DDD_Dollars__c=10;
        MarketShare5.Previous_DDD_Dollars__c=0;
        MarketShare5.DDD_Units__c=10;
        MarketShare5.Previous_DDD_Units__c=0;
        MarketShare5.Year__c=2014;
        MarketShare5.Month__c = 5;
        MarketShare5.Year__c = 2015;
        MarketShare5.LE_ID_IHS__c = 'Test IHS 5';
        MarketShare5.LE_ID_PGP__c = 'Test PGP 5';
        MarketShare5.LoadIdentifier__c = 'NON_AFFLTN';
        Insert MarketShare5;
        marketShareList.add(MarketShare5);
        system.assert(MarketShare5.id!=null);
        
        MYBZ_Market_Share__c MarketShare6 = New MYBZ_Market_Share__c();
        MarketShare6.Name='TestMarket';
        MarketShare6.Market__c = 'Test Market 7';
        MarketShare6.Global_Id__c='xxxxx';
        MarketShare6.Market__c='test';
        MarketShare6.Month__c=1;
        MarketShare6.Previous_Month_TRx__c=12;
        MarketShare6.TRx__c=10;
        MarketShare6.DDD_Dollars__c=6;
        MarketShare6.Previous_DDD_Dollars__c=4;
        MarketShare6.DDD_Units__c=1;
        MarketShare6.Previous_DDD_Units__c=1;
        MarketShare6.Owner__c='LILLY';
        MarketShare6.Division__c = Div.id;
        MarketShare6.District__c = District.id;
        MarketShare6.Product__c=IHSProduct.ID;
        MarketShare6.Region__c=Region.ID;
        MarketShare6.Territory__c=Territory.ID;
        MarketShare6.Year__c=2014;
        MarketShare6.Month__c = 6;
        MarketShare6.Year__c = 2015;
        MarketShare6.LoadIdentifier__c = 'NON_AFFLTN';
        Insert MarketShare6;
        marketShareList.add(MarketShare6);
        system.assert(MarketShare6.id!=null);
        
        MYBZ_Market_Share__c MarketShare7 = New MYBZ_Market_Share__c();
        MarketShare7.Name='TestMarket';
        MarketShare7.Market__c = 'Test Market 7';
        MarketShare7.Global_Id__c='xxxxx';
        MarketShare7.Market__c='test';
        MarketShare7.Month__c=3;
        MarketShare7.Owner__c='LILLY';
        MarketShare7.Previous_Month_TRx__c=7;
        MarketShare7.TRx__c=18;
        MarketShare7.Division__c = Div.id;
        MarketShare7.District__c = District.id;
        MarketShare7.DDD_Dollars__c=10;
        MarketShare7.Previous_DDD_Dollars__c=12;
        MarketShare7.DDD_Units__c=1;
        MarketShare7.Previous_DDD_Units__c=1;
        MarketShare7.Previous_Month_TRx__c=0;
        MarketShare7.Product__c=IHSProduct2.ID;
        MarketShare7.Region__c=Region.ID;
        MarketShare7.Territory__c=Territory.ID;        
        MarketShare7.DDD_Dollars__c=10;
        MarketShare7.Previous_DDD_Dollars__c=9;
        MarketShare7.DDD_Units__c=3;
        MarketShare7.Previous_DDD_Units__c=3;
        MarketShare7.Year__c=2015;
        MarketShare7.Month__c = 6;
        MarketShare7.Year__c = 2015;
        MarketShare7.LE_ID_IHS__c = 'Test IHS 3';
        MarketShare7.LE_ID_PGP__c = 'Test PGP 3';
        MarketShare7.LoadIdentifier__c = 'NON_AFFLTN';
        Insert MarketShare7;
        marketShareList.add(MarketShare7);
        system.assert(MarketShare7.id!=null);
        
        MYBZ_Market_Share__c MarketShare8 = New MYBZ_Market_Share__c();
        MarketShare8.Name='TestMarket';
        MarketShare8.Market__c = 'Test Market 1';
        MarketShare8.LoadIdentifier__c = 'AFFLTN';
        MarketShare8.Global_Id__c='yyyyy';
        MarketShare8.Market__c='test';
        MarketShare8.Owner__c='LILLY';
        MarketShare8.DDD_Dollars__c=12;
        MarketShare8.Previous_DDD_Dollars__c=9;
        MarketShare8.DDD_Units__c=1;
        MarketShare8.Previous_DDD_Units__c=1;
        MarketShare8.Previous_Month_TRx__c=0;
        MarketShare8.Product__c=IHSProduct2.ID;
        MarketShare8.Region__c=Region.ID;
        MarketShare8.Territory__c=Territory2.ID;
        MarketShare8.Previous_Month_TRx__c=7;
        MarketShare8.TRx__c=21;
        MarketShare8.DDD_Dollars__c=0;
        MarketShare8.Previous_DDD_Dollars__c=0;
        MarketShare8.DDD_Units__c=0;
        MarketShare8.Previous_DDD_Units__c=0;
        MarketShare8.LE_ID_IHS__c = 'Test IHS 3';
        MarketShare8.LE_ID_PGP__c = 'Test PGP 3';
        MarketShare8.Month__c = 10;
        MarketShare8.Year__c = 2015;
        MarketShare8.Prioritized_Account__c = true;
        Insert MarketShare8;
        marketShareList.add(MarketShare8);
        system.assert(MarketShare8.id!=null);
        
         
        MYBZ_Market_Share__c MarketShare9 = New MYBZ_Market_Share__c();
        MarketShare9.Name='TestMarket 9';
        MarketShare9.Market__c = 'Test Market 1';
        MarketShare9.Global_Id__c='xxxxx';
        MarketShare9.Market__c='test';
        MarketShare9.Owner__c='LILLY';
        MarketShare9.Division__c = Div.id;
        MarketShare9.District__c = District.id;
        MarketShare9.DDD_Dollars__c=15;
        MarketShare9.Previous_DDD_Dollars__c=10;
        MarketShare9.DDD_Units__c=10;
        MarketShare9.Previous_DDD_Units__c=8;
        MarketShare9.Previous_Month_TRx__c=6;
        MarketShare9.Product__c=IHSProduct2.ID;
        MarketShare9.Region__c=Region.ID;
        MarketShare9.Territory__c=Territory2.ID;
        MarketShare9.TRx__c=12;
        MarketShare9.DDD_Dollars__c=0;
        MarketShare9.Previous_DDD_Dollars__c=0;
        MarketShare9.DDD_Units__c=0;
        MarketShare9.Previous_DDD_Units__c=0;
        MarketShare9.LoadIdentifier__c = 'AFFLTN';
        MarketShare9.LE_ID_IHS__c = 'Test IHS 1';
        MarketShare9.LE_ID_PGP__c = 'Test PGP 1';
        MarketShare9.Month__c = 11;
        MarketShare9.Year__c = 2015;
        MarketShare9.Prioritized_Account__c = true;
        Insert MarketShare9;
        marketShareList.add(MarketShare9);
        system.assert(MarketShare9.id!=null);
        
         
        MYBZ_Market_Share__c MarketShare10 = New MYBZ_Market_Share__c();
        MarketShare10.Name='TestMarket';
        MarketShare10.Market__c = 'Test Market 1';
        MarketShare10.Global_Id__c='xxxxx';
        MarketShare10.Market__c='test';
        MarketShare10.Owner__c='LILLY';
        MarketShare9.DDD_Dollars__c=17;
        MarketShare9.Previous_DDD_Dollars__c=10;
        MarketShare9.DDD_Units__c=10;
        MarketShare9.Previous_DDD_Units__c=8;
        MarketShare10.Division__c = Div.id;
        MarketShare10.District__c = District.id;
        MarketShare10.Previous_Month_TRx__c=10;
        MarketShare10.Product__c=IHSProduct2.ID;
        MarketShare10.Region__c=Region.ID;
        MarketShare10.Territory__c=Territory2.ID;
        MarketShare10.TRx__c=70;
        MarketShare10.DDD_Dollars__c=3;
        MarketShare10.Previous_DDD_Dollars__c=4;
        MarketShare10.DDD_Units__c=1;
        MarketShare10.Previous_DDD_Units__c=1;
        MarketShare10.LoadIdentifier__c = 'AFFLTN';
        MarketShare10.LE_ID_IHS__c = 'Test IHS 2';
        MarketShare10.LE_ID_PGP__c = 'Test PGP 2';
        MarketShare10.Month__c = 12;
        MarketShare10.Year__c = 2015;
        MarketShare10.Prioritized_Account__c = true;
        Insert MarketShare10;
        marketShareList.add(MarketShare10);
        system.assert(MarketShare10.id!=null);
        
    }
    
    /*
    * @Method Name                    :  testAsSalesRepAlignment
    * @Description                    :  method to test as Sales Representative(Role) generation of JSONS for MarketShare Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSalesRepAlignment() {
        String jsonrespasString;
        User runAsUser = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_SalesRepresentative);  
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SalesRepresentative);
        
        System.runas(runAsUserDataLoad){ 
        
            // Insertion of Test Dat
            insertTestMarketShareData();
        
        }
        System.runas(runAsUser){ 
            
            Test.startTest();
            
                MYBZ_MarketShare controller = new MYBZ_MarketShare();
                
                Obj=MYBZ_MarketShare.marketShareControllerNonAff();
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, District.Name, Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, null);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(Region.Name, District.Name, Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
               
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', 'Test PGP 1'); 
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, 'Test PGP 1');  
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', null); 
                system.assert(Obj!=null); 
                jsonrespasString = Obj+''; 
                //system.assert(jsonrespasString.contains('TestDivision'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, null);      
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                //system.assert(jsonrespasString.contains('TestDivision'));
                        
                /*Obj=MYBZ_MarketShare.marketshareControllerAffiliation();
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';*/
                //system.assert(jsonrespasString.contains('TestDivision'));
            Test.stopTest();
        }
     }
     
     
     /*
    * @Method Name                    :  testAsAccountManager
    * @Description                    :  method to test as Account Manager(Role) generation of JSONS for MarketShare Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsAccountManager() {
        String jsonrespasString;
        User runAsUser = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_AccountManager);  
         // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        }
        System.runas(runAsUser){ 
            
            Test.startTest();
                MYBZ_MarketShare controller = new MYBZ_MarketShare();
                MYBZ_MarketShare.marketShareControllerNonAff();
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, District.Name, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, null);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(Region.Name, District.Name, Territory.Name);            
                MYBZ_MarketShare.accountSummary();
                
                MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', 'Test PGP 1'); 
                MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, 'Test PGP 1');  
                MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', null);   
                MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, null);      
                         
                //MYBZ_MarketShare.marketshareControllerAffiliation();
            Test.stopTest();
           
        }
     }
     
    /*
    * @Method Name                    :  testAsDistrictSalesManager
    * @Description                    :  method to test as District Sales Manager(Role) generation of JSONS for MarketShare Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsDistrictSalesManager() {
        String jsonrespasString;
        User runAsUser = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_DistrictSalesManager);  
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        }
        System.runas(runAsUser){ 
            Test.startTest();
            
                MYBZ_MarketShare controller = new MYBZ_MarketShare();
                MYBZ_MarketShare.marketShareControllerNonAff();
                //MYBZ_MarketShare.marketshareControllerAffiliation();
                
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, District.Name, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, null);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(Region.Name, District.Name, Territory.Name);
                
                MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', 'Test PGP 1'); 
                MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, 'Test PGP 1');  
                MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', null);   
                MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, null);      
                         
                //MYBZ_MarketShare.marketshareControllerAffiliation();
                
            Test.stopTest();
        }
     }
     
    /*
    * @Method Name                    :  testAsSuperUser
    * @Description                    :  method to test as Super User(Role) generation of JSONS for MarketShare Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSuperUser() {
        String jsonrespasString;
        User runAsUser = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_SuperUser);
         
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        } 
        
        System.runas(runAsUser){ 
            
            Test.startTest();
                MYBZ_MarketShare controller = new MYBZ_MarketShare();
                MYBZ_MarketShare.marketShareControllerNonAff();
                //MYBZ_MarketShare.marketshareControllerAffiliation();
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, District.Name, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, null);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(Region.Name, District.Name, Territory.Name);
                //MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', 'Test PGP 1');        
                
                MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('Test IHS 1', 'Test PGP 1', Region.Name, District.Name, null); 
                MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser(null, 'Test PGP 1', Region.Name, District.Name, null);
                MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser(null, null, Region.Name, District.Name, null);
                MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('Test IHS 1', 'null', Region.Name, District.Name, null);
                MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('Test IHS 1', 'Test PGP 1', null, District.Name, null); 
           Test.stopTest();
        }
            
     }
     
     /*
    * @Method Name                    :  testAsMarketManager
    * @Description                    :  method to test as Market Manager(Role) generation of JSONS for MarketShare Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsMarketManager() {
        String jsonrespasString;
        User runAsUser = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_MajorMarketManager);  
        
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        }
        System.runas(runAsUser){ 
            
            Test.startTest();
                MYBZ_MarketShare controller = new MYBZ_MarketShare();
                MYBZ_MarketShare.marketShareControllerNonAff();
                //MYBZ_MarketShare.marketshareControllerAffiliation();
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, District.Name, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, Territory.Name);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(null, null, null);
                MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(Region.Name, District.Name, Territory.Name);
                MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', 'Test PGP 1'); 
                MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, 'Test PGP 1');  
                MYBZ_MarketShare.marketshareControllerAffUsingPicker('Test IHS 1', null);   
                MYBZ_MarketShare.marketshareControllerAffUsingPicker(null, null);
             Test.stopTest();      
                            
            //MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('Test IHS 1', 'Test PGP 1', Region.id, District.id, Territory.id); 
        }
            
     }

     static testMethod void testAsAdmin() {
        
            // Insertion of Test Dat
            User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
            System.runas(runAsUserDataLoad){ 
                insertTestMarketShareData();
            }
            List<MYBZ_Market_Share__c> newMarketShareList =new List<MYBZ_Market_Share__c>();
            newMarketShareList = [SELECT Id, Region__c, District__c, Month__c ,Year__c ,territory__c,Global_Id__c, Owner__c, LE_ID_IHS__c, LE_ID_PGP__c, System__c, System__r.Name, 
                               Market__c, percentageChangeFromPreviousMonth__c,lillyProduct__c, Month_Number__c, Year_Number__c, Product__r.Name, TRx__c, Gross_Margin__c,DDD_Dollars__c,PercentageChangeDDDunits__c,PercentageChangeDDDDollars__c,
                               Previous_Month_TRx__c, DDD_Units__c,Previous_DDD_Units__c  FROM MYBZ_Market_Share__c  ORDER BY Market__c,Month__c, Year__c ASC ]; 
            System.debug('@@@@Here--->'+newMarketShareList);
            
            Test.startTest();
                MYBZ_Region_Rollup_Controller controller1 = new MYBZ_Region_Rollup_Controller();
                MYBZ_MarketShare controllerParam = new MYBZ_MarketShare(controller1);
                MYBZ_MarketShare controller = new MYBZ_MarketShare();
                
                MYBZ_MarketShare.marketShareList.addAll(newMarketShareList);
                MYBZ_MarketShare.flag = 0;
                MYBZ_MarketShare.marketshareProcessor();
                MYBZ_MarketShare.flag = 1;
                MYBZ_MarketShare.marketshareProcessor();
                
                
                MYBZ_MarketShare.TotalTrx = 100;
                MYBZ_MarketShare.TotalTrxDis=50;
                MYBZ_MarketShare.TotalTrxReg=150;
                MYBZ_MarketShare.flag = 0;
                MYBZ_MarketShare.marketshareProcessor();
                
                MYBZ_MarketShare.flag = 1;
                MYBZ_MarketShare.marketshareProcessor();
                
                List<AggregateResult> marketShareListNational=new List<AggregateResult>();
                marketShareListNational = [select Market__c mar, SUM(TRx__c) TotTrx,Month_Number__c mon, Year_Number__c yr 
                                                      FROM MYBZ_Market_Share__c GROUP BY Month_Number__c, Year_Number__c,Market__c];
                MYBZ_MarketShare.marketShareListNational.addAll(marketShareListNational);
                MYBZ_MarketShare.marketShareListDistrict.addAll(marketShareListNational);
                MYBZ_MarketShare.marketShareListRegion.addAll(marketShareListNational);
                MYBZ_MarketShare.calculateNational();
                
                MYBZ_MarketShare.marketShareNationalPercentChange.addAll(newMarketShareList);
                MYBZ_MarketShare.calculateNational();
                MYBZ_MarketShare.marketSharedistrictPercentChange.addAll(newMarketShareList);
                MYBZ_MarketShare.calculateNational();
                MYBZ_MarketShare.marketShareRegionPercentChange.addAll(newMarketShareList);
                MYBZ_MarketShare.calculateNational();
            Test.stopTest();
            
        
        
     }
}