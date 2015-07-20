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
    static MYBZ_System__c objSystem = new MYBZ_System__c();
    static MYBZ_PGP__c PGP = new MYBZ_PGP__c();
    static List<MYBZ_Market_Share__c> marketShareList =new List<MYBZ_Market_Share__c>();
    static List<MYBZ_Market_Share__c> lstMarketShare = new List<MYBZ_Market_Share__c>();
    static Object Obj;
    
    /*
	* @Method Name                    :  createUserToRun
	* @Description                    :  method to create User of certain Role                                  
	* @Return Type                    :  User
	* @Param                          :      
	*/
    public static User createUserToRun(String Role, String Globalid){
        Profile pfl = [select id from profile where name='GSO Basic User_Platform'];
        //Declaring the User
        User runAsUser = new User(alias = 'BasicIHS', email='appBasicIhs@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c=Globalid,MYBZ_Reporting_ID__c='114017');
        
        Insert runAsUser;
        
        System.runAs(new User(Id = Userinfo.getUserId())) {
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'MYBZ_Reps_and_Managers'];
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = runAsUser.Id;
            psa.PermissionSetId = ps.Id;
            insert psa;
        }
        Return runAsUser;
    }   
    
    
    
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
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c='xxxx',MYBZ_Reporting_ID__c='xxxxx');
        
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
        
        MYBZ_Product__c IHSProduct1 = New MYBZ_Product__c();
        IHSProduct1.Name='LILLY Product 1'; 
        Insert IHSProduct1;
        system.assert(IHSProduct1.id!=null);
        
        MYBZ_Product__c IHSProduct2 = New MYBZ_Product__c();
        IHSProduct2.Name='LILLY Product 2'; 
        Insert IHSProduct2;
        system.assert(IHSProduct2.id!=null);
        
        MYBZ_Product__c IHSProduct3 = New MYBZ_Product__c();
        IHSProduct3.Name='COMPETITOR Product 3'; 
        Insert IHSProduct3;
        system.assert(IHSProduct3.id!=null);
        
        MYBZ_Product__c IHSProduct4 = New MYBZ_Product__c();
        IHSProduct4.Name='COMPETITOR Product 4'; 
        Insert IHSProduct4;
        system.assert(IHSProduct3.id!=null);
        
        MYBZ_Product__c IHSProduct5 = New MYBZ_Product__c();
        IHSProduct5.Name='COMPETITOR Product 5'; 
        Insert IHSProduct5;
        system.assert(IHSProduct5.id!=null);
        
        MYBZ_Product__c IHSProduct6 = New MYBZ_Product__c();
        IHSProduct6.Name='COMPETITOR Product 6'; 
        Insert IHSProduct6;
        system.assert(IHSProduct6.id!=null);
        
        MYBZ_IHS_Division__c Div = New MYBZ_IHS_Division__c();
        Div.Name='TestDivision';
        Insert Div;  
        system.assert(Div.id!=null);
        
        Region.Name=System.Label.MYBZ_defaultRegion;
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
        
        
        
        objSystem.System_ID__c ='XYZ';
        objSystem.Global_IDs__c = '1;2;3;4';
        objSystem.Aligned_Territories__c = 'TestTerritory;TestTerritory2';
        objSystem.Aligned_Districts__c = 'TestDistrict';
        objSystem.Name = 'Test IHS 1';
        insert objSystem;
        system.assert(objSystem.id!=null);
        
       
        PGP.PGP_ID__c ='ABC';
        PGP.Global_IDs__c = '1;2;3;4';
        PGP.Aligned_Territories__c = 'TestTerritory;TestTerritory2';
        PGP.Aligned_Districts__c = 'TestDistrict';
        PGP.Address__c = 'Test Address';
        PGP.System__c = objSystem.id;
        PGP.Name = 'Test PGP 1';
        insert PGP;
        system.assert(PGP.id!=null);
        
        List<MYBZ_PriorityAccount__c> lstPriorityAcccount = new List<MYBZ_PriorityAccount__c>();
        MYBZ_PriorityAccount__c objPriorityAcccount1 = new MYBZ_PriorityAccount__c();
        objPriorityAcccount1.Global_Id__c = '3';
        objPriorityAcccount1.LE_ID_IHS__c = 'XYZ';
        objPriorityAcccount1.System__c = objSystem.id;
        lstPriorityAcccount.add(objPriorityAcccount1);
        
        
        MYBZ_PriorityAccount__c objPriorityAcccount2 = new MYBZ_PriorityAccount__c();
        objPriorityAcccount2.Global_Id__c = '3';
        objPriorityAcccount2.LE_ID_PGP__c = 'ABC';
        objPriorityAcccount2.PGP__c = PGP.id;
        lstPriorityAcccount.add(objPriorityAcccount2);
        
        insert lstPriorityAcccount;
        

		// NON Affliation division level dataa
		
        MYBZ_Market_Share__c MarketShare1 = New MYBZ_Market_Share__c();
        MarketShare1.Name='TestMarket';
        MarketShare1.Market__c = 'Test Market 1';
        MarketShare1.Global_Id__c='1';        
        MarketShare1.Month__c=1;
        MarketShare1.Month_Number__c = '1';
        MarketShare1.Year_Number__c = '2015';
        MarketShare1.Year__c=2015;        
        MarketShare1.Owner__c='LILLY';
        MarketShare1.Product__c=IHSProduct1.ID;
        MarketShare1.Division__c = Div.id;
        MarketShare1.Region__c=null;
        MarketShare1.District__c = null;           
        MarketShare1.Territory__c=null;
        MarketShare1.TRx__c=80;
        MarketShare1.Previous_Month_TRx__c=90;
        MarketShare1.DDD_Dollars__c=null;
        MarketShare1.Previous_DDD_Dollars__c=null;
        MarketShare1.DDD_Units__c=null;
        MarketShare1.Previous_DDD_Units__c=null;
        MarketShare1.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare1);
        
        
        MYBZ_Market_Share__c MarketShare2 = New MYBZ_Market_Share__c();
        MarketShare2.Name='TestMarket';
        MarketShare2.Market__c = 'Test Market 1';
        MarketShare2.Global_Id__c='1';        
        MarketShare2.Month__c=2;
        MarketShare2.Month_Number__c = '2';
        MarketShare2.Year_Number__c = '2015';
        MarketShare2.Year__c=2015;        
        MarketShare2.Owner__c='LILLY';
        MarketShare2.Product__c=IHSProduct1.ID;
        MarketShare2.Division__c = Div.id;
        MarketShare2.Region__c=null;
        MarketShare2.District__c = null;           
        MarketShare2.Territory__c=null;
        MarketShare2.TRx__c=100;
        MarketShare2.Previous_Month_TRx__c=80;
        MarketShare2.DDD_Dollars__c=null;
        MarketShare2.Previous_DDD_Dollars__c=null;
        MarketShare2.DDD_Units__c=null;
        MarketShare2.Previous_DDD_Units__c=null;
        MarketShare2.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare2);

		MYBZ_Market_Share__c MarketShare3 = New MYBZ_Market_Share__c();
        MarketShare3.Name='TestMarket';
        MarketShare3.Market__c = 'Test Market 1';
        MarketShare3.Global_Id__c='1';        
        MarketShare3.Month__c=3;
        MarketShare3.Month_Number__c = '3';
        MarketShare3.Year_Number__c = '2015';
        MarketShare3.Year__c=2015;        
        MarketShare3.Owner__c='LILLY';
        MarketShare3.Product__c=IHSProduct1.ID;
        MarketShare3.Division__c = Div.id;
        MarketShare3.Region__c=null;
        MarketShare3.District__c = null;           
        MarketShare3.Territory__c=null;
        MarketShare3.TRx__c=100;
        MarketShare3.Previous_Month_TRx__c=80;
        MarketShare3.DDD_Dollars__c=null;
        MarketShare3.Previous_DDD_Dollars__c=null;
        MarketShare3.DDD_Units__c=null;
        MarketShare3.Previous_DDD_Units__c=null;
        MarketShare3.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare3);
        
        
        MYBZ_Market_Share__c MarketShare4 = New MYBZ_Market_Share__c();
        MarketShare4.Name='TestMarket';
        MarketShare4.Market__c = 'Test Market 1';
        MarketShare4.Global_Id__c='1';        
        MarketShare4.Month__c=1;
        MarketShare4.Month_Number__c = '1';
        MarketShare4.Year_Number__c = '2015';
        MarketShare4.Year__c=2015;        
        MarketShare4.Owner__c='COMPETITOR';
        MarketShare4.Product__c=IHSProduct4.ID;
        MarketShare4.Division__c = Div.id;
        MarketShare4.Region__c=null;
        MarketShare4.District__c = null;           
        MarketShare4.Territory__c=null;
        MarketShare4.TRx__c=80;
        MarketShare4.Previous_Month_TRx__c=90;
        MarketShare4.DDD_Dollars__c=null;
        MarketShare4.Previous_DDD_Dollars__c=null;
        MarketShare4.DDD_Units__c=null;
        MarketShare4.Previous_DDD_Units__c=null;
        MarketShare4.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare4);
        
        
        MYBZ_Market_Share__c MarketShare5 = New MYBZ_Market_Share__c();
        MarketShare5.Name='TestMarket';
        MarketShare5.Market__c = 'Test Market 1';
        MarketShare5.Global_Id__c='1';        
        MarketShare5.Month__c=2;
        MarketShare5.Month_Number__c = '2';
        MarketShare5.Year_Number__c = '2015';
        MarketShare5.Year__c=2015;        
        MarketShare5.Owner__c='COMPETITOR';
        MarketShare5.Product__c=IHSProduct4.ID;
        MarketShare5.Division__c = Div.id;
        MarketShare5.Region__c=null;
        MarketShare5.District__c = null;           
        MarketShare5.Territory__c=null;
        MarketShare5.TRx__c=100;
        MarketShare5.Previous_Month_TRx__c=80;
        MarketShare5.DDD_Dollars__c=null;
        MarketShare5.Previous_DDD_Dollars__c=null;
        MarketShare5.DDD_Units__c=null;
        MarketShare5.Previous_DDD_Units__c=null;
        MarketShare5.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare5);

		MYBZ_Market_Share__c MarketShare6 = New MYBZ_Market_Share__c();
        MarketShare6.Name='TestMarket';
        MarketShare6.Market__c = 'Test Market 1';
        MarketShare6.Global_Id__c='1';        
        MarketShare6.Month__c=3;
        MarketShare6.Month_Number__c = '3';
        MarketShare6.Year_Number__c = '2015';
        MarketShare6.Year__c=2015;        
        MarketShare6.Owner__c='COMPETITOR';
        MarketShare6.Product__c=IHSProduct4.ID;
        MarketShare6.Division__c = Div.id;
        MarketShare6.Region__c=null;
        MarketShare6.District__c = null;           
        MarketShare6.Territory__c=null;
        MarketShare6.TRx__c=100;
        MarketShare6.Previous_Month_TRx__c=80;
        MarketShare6.DDD_Dollars__c=null;
        MarketShare6.Previous_DDD_Dollars__c=null;
        MarketShare6.DDD_Units__c=null;
        MarketShare6.Previous_DDD_Units__c=null;
        MarketShare6.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare6);
        
        MYBZ_Market_Share__c MarketShare7 = New MYBZ_Market_Share__c();
        MarketShare7.Name='TestMarket';
        MarketShare7.Market__c = 'Test Market 2';
        MarketShare7.Global_Id__c='18785';        
        MarketShare7.Month__c=1;
        MarketShare7.Month_Number__c = '1';
        MarketShare7.Year_Number__c = '2015';
        MarketShare7.Year__c=2015;        
        MarketShare7.Owner__c='LILLY';
        MarketShare7.Product__c=IHSProduct1.ID;
        MarketShare7.Division__c = Div.id;
        MarketShare7.Region__c=null;
        MarketShare7.District__c = null;           
        MarketShare7.Territory__c=null;
        MarketShare7.TRx__c=null;
        MarketShare7.Previous_Month_TRx__c=null;
        MarketShare7.DDD_Dollars__c=80;
        MarketShare7.Previous_DDD_Dollars__c=90;
        MarketShare7.DDD_Units__c=80;
        MarketShare7.Previous_DDD_Units__c=90;
        MarketShare7.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare7);
        
        
        MYBZ_Market_Share__c MarketShare8 = New MYBZ_Market_Share__c();
        MarketShare8.Name='TestMarket';
        MarketShare8.Market__c = 'Test Market 2';
        MarketShare8.Global_Id__c='1';        
        MarketShare8.Month__c=2;
        MarketShare8.Month_Number__c = '2';
        MarketShare8.Year_Number__c = '2015';
        MarketShare8.Year__c=2015;        
        MarketShare8.Owner__c='LILLY';
        MarketShare8.Product__c=IHSProduct1.ID;
        MarketShare8.Division__c = Div.id;
        MarketShare8.Region__c=null;
        MarketShare8.District__c = null;           
        MarketShare8.Territory__c=null;
        MarketShare8.TRx__c=null;
        MarketShare8.Previous_Month_TRx__c=null;
        MarketShare8.DDD_Dollars__c=100;
        MarketShare8.Previous_DDD_Dollars__c=80;
        MarketShare8.DDD_Units__c=100;
        MarketShare8.Previous_DDD_Units__c=80;
        MarketShare8.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare8);

		MYBZ_Market_Share__c MarketShare9 = New MYBZ_Market_Share__c();
        MarketShare9.Name='TestMarket';
        MarketShare9.Market__c = 'Test Market 2';
        MarketShare9.Global_Id__c='1';        
        MarketShare9.Month__c=3;
        MarketShare9.Month_Number__c = '3';
        MarketShare9.Year_Number__c = '2015';
        MarketShare9.Year__c=2015;        
        MarketShare9.Owner__c='LILLY';
        MarketShare9.Product__c=IHSProduct1.ID;
        MarketShare9.Division__c = Div.id;
        MarketShare9.Region__c=null;
        MarketShare9.District__c = null;           
        MarketShare9.Territory__c=null;
        MarketShare9.TRx__c=null;
        MarketShare9.Previous_Month_TRx__c=null;
        MarketShare9.DDD_Dollars__c=100;
        MarketShare9.Previous_DDD_Dollars__c=90;
        MarketShare9.DDD_Units__c=100;
        MarketShare9.Previous_DDD_Units__c=90;
        MarketShare9.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare9);
        
        
        // NON Affliation Region level dataa
		
        MYBZ_Market_Share__c MarketShare10 = New MYBZ_Market_Share__c();
        MarketShare10.Name='TestMarket';
        MarketShare10.Market__c = 'Test Market 1';
        MarketShare10.Global_Id__c='2';        
        MarketShare10.Month__c=1;
        MarketShare10.Month_Number__c = '1';
        MarketShare10.Year_Number__c = '2015';
        MarketShare10.Year__c=2015;        
        MarketShare10.Owner__c='LILLY';
        MarketShare10.Product__c=IHSProduct1.ID;
        MarketShare10.Division__c = Div.id;
        MarketShare10.Region__c=Region.id;
        MarketShare10.District__c = null;           
        MarketShare10.Territory__c=null;
        MarketShare10.TRx__c=80;
        MarketShare10.Previous_Month_TRx__c=90;
        MarketShare10.DDD_Dollars__c=null;
        MarketShare10.Previous_DDD_Dollars__c=null;
        MarketShare10.DDD_Units__c=null;
        MarketShare10.Previous_DDD_Units__c=null;
        MarketShare10.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare10);
        
        
        MYBZ_Market_Share__c MarketShare11 = New MYBZ_Market_Share__c();
        MarketShare11.Name='TestMarket';
        MarketShare11.Market__c = 'Test Market 1';
        MarketShare11.Global_Id__c='2';        
        MarketShare11.Month__c=2;
        MarketShare11.Month_Number__c = '2';
        MarketShare11.Year_Number__c = '2015';
        MarketShare11.Year__c=2015;        
        MarketShare11.Owner__c='LILLY';
        MarketShare11.Product__c=IHSProduct1.ID;
        MarketShare11.Division__c = Div.id;
        MarketShare11.Region__c=Region.id;
        MarketShare11.District__c = null;           
        MarketShare11.Territory__c=null;
        MarketShare11.TRx__c=100;
        MarketShare11.Previous_Month_TRx__c=80;
        MarketShare11.DDD_Dollars__c=null;
        MarketShare11.Previous_DDD_Dollars__c=null;
        MarketShare11.DDD_Units__c=null;
        MarketShare11.Previous_DDD_Units__c=null;
        MarketShare11.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare11);

		MYBZ_Market_Share__c MarketShare12 = New MYBZ_Market_Share__c();
        MarketShare12.Name='TestMarket';
        MarketShare12.Market__c = 'Test Market 1';
        MarketShare12.Global_Id__c='2';        
        MarketShare12.Month__c=3;
        MarketShare12.Month_Number__c = '3';
        MarketShare12.Year_Number__c = '2015';
        MarketShare12.Year__c=2015;        
        MarketShare12.Owner__c='LILLY';
        MarketShare12.Product__c=IHSProduct1.ID;
        MarketShare12.Division__c = Div.id;
        MarketShare12.Region__c=Region.id;
        MarketShare12.District__c = null;           
        MarketShare12.Territory__c=null;
        MarketShare12.TRx__c=100;
        MarketShare12.Previous_Month_TRx__c=80;
        MarketShare12.DDD_Dollars__c=null;
        MarketShare12.Previous_DDD_Dollars__c=null;
        MarketShare12.DDD_Units__c=null;
        MarketShare12.Previous_DDD_Units__c=null;
        MarketShare12.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare12);
        
        
        MYBZ_Market_Share__c MarketShare13 = New MYBZ_Market_Share__c();
        MarketShare13.Name='TestMarket';
        MarketShare13.Market__c = 'Test Market 1';
        MarketShare13.Global_Id__c='2';        
        MarketShare13.Month__c=1;
        MarketShare13.Month_Number__c = '1';
        MarketShare13.Year_Number__c = '2015';
        MarketShare13.Year__c=2015;        
        MarketShare13.Owner__c='COMPETITOR';
        MarketShare13.Product__c=IHSProduct4.ID;
        MarketShare13.Division__c = Div.id;
        MarketShare13.Region__c=Region.id;
        MarketShare13.District__c = null;           
        MarketShare13.Territory__c=null;
        MarketShare13.TRx__c=80;
        MarketShare13.Previous_Month_TRx__c=90;
        MarketShare13.DDD_Dollars__c=null;
        MarketShare13.Previous_DDD_Dollars__c=null;
        MarketShare13.DDD_Units__c=null;
        MarketShare13.Previous_DDD_Units__c=null;
        MarketShare13.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare13);
        
        
        MYBZ_Market_Share__c MarketShare14 = New MYBZ_Market_Share__c();
        MarketShare14.Name='TestMarket';
        MarketShare14.Market__c = 'Test Market 1';
        MarketShare14.Global_Id__c='2';        
        MarketShare14.Month__c=2;
        MarketShare14.Month_Number__c = '2';
        MarketShare14.Year_Number__c = '2015';
        MarketShare14.Year__c=2015;        
        MarketShare14.Owner__c='COMPETITOR';
        MarketShare14.Product__c=IHSProduct4.ID;
        MarketShare14.Division__c = Div.id;
        MarketShare14.Region__c=Region.id;
        MarketShare14.District__c = null;           
        MarketShare14.Territory__c=null;
        MarketShare14.TRx__c=100;
        MarketShare14.Previous_Month_TRx__c=80;
        MarketShare14.DDD_Dollars__c=null;
        MarketShare14.Previous_DDD_Dollars__c=null;
        MarketShare14.DDD_Units__c=null;
        MarketShare14.Previous_DDD_Units__c=null;
        MarketShare14.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare14);

		MYBZ_Market_Share__c MarketShare15 = New MYBZ_Market_Share__c();
        MarketShare15.Name='TestMarket';
        MarketShare15.Market__c = 'Test Market 1';
        MarketShare15.Global_Id__c='2';        
        MarketShare15.Month__c=3;
        MarketShare15.Month_Number__c = '3';
        MarketShare15.Year_Number__c = '2015';
        MarketShare15.Year__c=2015;        
        MarketShare15.Owner__c='COMPETITOR';
        MarketShare15.Product__c=IHSProduct4.ID;
        MarketShare15.Division__c = Div.id;
        MarketShare15.Region__c=Region.id;
        MarketShare15.District__c = null;           
        MarketShare15.Territory__c=null;
        MarketShare15.TRx__c=100;
        MarketShare15.Previous_Month_TRx__c=80;
        MarketShare15.DDD_Dollars__c=null;
        MarketShare15.Previous_DDD_Dollars__c=null;
        MarketShare15.DDD_Units__c=null;
        MarketShare15.Previous_DDD_Units__c=null;
        MarketShare15.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare15);
        
        MYBZ_Market_Share__c MarketShare16 = New MYBZ_Market_Share__c();
        MarketShare16.Name='TestMarket';
        MarketShare16.Market__c = 'Test Market 2';
        MarketShare16.Global_Id__c='2';        
        MarketShare16.Month__c=1;
        MarketShare16.Month_Number__c = '1';
        MarketShare16.Year_Number__c = '2015';
        MarketShare16.Year__c=2015;        
        MarketShare16.Owner__c='LILLY';
        MarketShare16.Product__c=IHSProduct1.ID;
        MarketShare16.Division__c = Div.id;
        MarketShare16.Region__c=Region.id;
        MarketShare16.District__c = null;           
        MarketShare16.Territory__c=null;
        MarketShare16.TRx__c=null;
        MarketShare16.Previous_Month_TRx__c=null;
        MarketShare16.DDD_Dollars__c=80;
        MarketShare16.Previous_DDD_Dollars__c=90;
        MarketShare16.DDD_Units__c=80;
        MarketShare16.Previous_DDD_Units__c=90;
        MarketShare16.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare16);
        
        
        MYBZ_Market_Share__c MarketShare17 = New MYBZ_Market_Share__c();
        MarketShare17.Name='TestMarket';
        MarketShare17.Market__c = 'Test Market 2';
        MarketShare17.Global_Id__c='2';        
        MarketShare17.Month__c=2;
        MarketShare17.Month_Number__c = '2';
        MarketShare17.Year_Number__c = '2015';
        MarketShare17.Year__c=2015;        
        MarketShare17.Owner__c='LILLY';
        MarketShare17.Product__c=IHSProduct1.ID;
        MarketShare17.Division__c = Div.id;
        MarketShare17.Region__c=Region.id;
        MarketShare17.District__c = null;           
        MarketShare17.Territory__c=null;
        MarketShare17.TRx__c=null;
        MarketShare17.Previous_Month_TRx__c=null;
        MarketShare17.DDD_Dollars__c=100;
        MarketShare17.Previous_DDD_Dollars__c=80;
        MarketShare17.DDD_Units__c=100;
        MarketShare17.Previous_DDD_Units__c=80;
        MarketShare17.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare17);

		MYBZ_Market_Share__c MarketShare18 = New MYBZ_Market_Share__c();
        MarketShare18.Name='TestMarket';
        MarketShare18.Market__c = 'Test Market 2';
        MarketShare18.Global_Id__c='2';        
        MarketShare18.Month__c=3;
        MarketShare18.Month_Number__c = '3';
        MarketShare18.Year_Number__c = '2015';
        MarketShare18.Year__c=2015;        
        MarketShare18.Owner__c='LILLY';
        MarketShare18.Product__c=IHSProduct1.ID;
        MarketShare18.Division__c = Div.id;
        MarketShare18.Region__c=Region.id;
        MarketShare18.District__c = null;           
        MarketShare18.Territory__c=null;
        MarketShare18.TRx__c=null;
        MarketShare18.Previous_Month_TRx__c=null;
        MarketShare18.DDD_Dollars__c=100;
        MarketShare18.Previous_DDD_Dollars__c=90;
        MarketShare18.DDD_Units__c=100;
        MarketShare18.Previous_DDD_Units__c=90;
        MarketShare18.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare18);
        
        
         // NON Affliation District level dataa
		
        MYBZ_Market_Share__c MarketShare19 = New MYBZ_Market_Share__c();
        MarketShare19.Name='TestMarket';
        MarketShare19.Market__c = 'Test Market 1';
        MarketShare19.Global_Id__c='3';        
        MarketShare19.Month__c=1;
        MarketShare19.Month_Number__c = '1';
        MarketShare19.Year_Number__c = '2015';
        MarketShare19.Year__c=2015;        
        MarketShare19.Owner__c='LILLY';
        MarketShare19.Product__c=IHSProduct1.ID;
        MarketShare19.Division__c = Div.id;
        MarketShare19.Region__c=Region.id;
        MarketShare19.District__c = District.id;           
        MarketShare19.Territory__c=null;
        MarketShare19.TRx__c=80;
        MarketShare19.Previous_Month_TRx__c=90;
        MarketShare19.DDD_Dollars__c=null;
        MarketShare19.Previous_DDD_Dollars__c=null;
        MarketShare19.DDD_Units__c=null;
        MarketShare19.Previous_DDD_Units__c=null;
        MarketShare19.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare19);
        
        
        MYBZ_Market_Share__c MarketShare20 = New MYBZ_Market_Share__c();
        MarketShare20.Name='TestMarket';
        MarketShare20.Market__c = 'Test Market 1';
        MarketShare20.Global_Id__c='3';        
        MarketShare20.Month__c=2;
        MarketShare20.Month_Number__c = '2';
        MarketShare20.Year_Number__c = '2015';
        MarketShare20.Year__c=2015;        
        MarketShare20.Owner__c='LILLY';
        MarketShare20.Product__c=IHSProduct1.ID;
        MarketShare20.Division__c = Div.id;
        MarketShare20.Region__c=Region.id;
        MarketShare20.District__c = District.id;           
        MarketShare20.Territory__c=null;
        MarketShare20.TRx__c=100;
        MarketShare20.Previous_Month_TRx__c=80;
        MarketShare20.DDD_Dollars__c=null;
        MarketShare20.Previous_DDD_Dollars__c=null;
        MarketShare20.DDD_Units__c=null;
        MarketShare20.Previous_DDD_Units__c=null;
        MarketShare20.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare20);

		MYBZ_Market_Share__c MarketShare21 = New MYBZ_Market_Share__c();
        MarketShare21.Name='TestMarket';
        MarketShare21.Market__c = 'Test Market 1';
        MarketShare21.Global_Id__c='3';        
        MarketShare21.Month__c=3;
        MarketShare21.Month_Number__c = '3';
        MarketShare21.Year_Number__c = '2015';
        MarketShare21.Year__c=2015;        
        MarketShare21.Owner__c='LILLY';
        MarketShare21.Product__c=IHSProduct1.ID;
        MarketShare21.Division__c = Div.id;
        MarketShare21.Region__c=Region.id;
        MarketShare21.District__c = District.id;           
        MarketShare21.Territory__c=null;
        MarketShare21.TRx__c=100;
        MarketShare21.Previous_Month_TRx__c=80;
        MarketShare21.DDD_Dollars__c=null;
        MarketShare21.Previous_DDD_Dollars__c=null;
        MarketShare21.DDD_Units__c=null;
        MarketShare21.Previous_DDD_Units__c=null;
        MarketShare21.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare21);
        
        
        MYBZ_Market_Share__c MarketShare22 = New MYBZ_Market_Share__c();
        MarketShare22.Name='TestMarket';
        MarketShare22.Market__c = 'Test Market 1';
        MarketShare22.Global_Id__c='3';        
        MarketShare22.Month__c=1;
        MarketShare22.Month_Number__c = '1';
        MarketShare22.Year_Number__c = '2015';
        MarketShare22.Year__c=2015;        
        MarketShare22.Owner__c='COMPETITOR';
        MarketShare22.Product__c=IHSProduct4.ID;
        MarketShare22.Division__c = Div.id;
        MarketShare22.Region__c=Region.id;
        MarketShare22.District__c = District.id;           
        MarketShare22.Territory__c=null;
        MarketShare22.TRx__c=80;
        MarketShare22.Previous_Month_TRx__c=90;
        MarketShare22.DDD_Dollars__c=null;
        MarketShare22.Previous_DDD_Dollars__c=null;
        MarketShare22.DDD_Units__c=null;
        MarketShare22.Previous_DDD_Units__c=null;
        MarketShare22.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare22);
        
        
        MYBZ_Market_Share__c MarketShare23 = New MYBZ_Market_Share__c();
        MarketShare23.Name='TestMarket';
        MarketShare23.Market__c = 'Test Market 1';
        MarketShare23.Global_Id__c='3';        
        MarketShare23.Month__c=2;
        MarketShare23.Month_Number__c = '2';
        MarketShare23.Year_Number__c = '2015';
        MarketShare23.Year__c=2015;        
        MarketShare23.Owner__c='COMPETITOR';
        MarketShare23.Product__c=IHSProduct4.ID;
        MarketShare23.Division__c = Div.id;
        MarketShare23.Region__c=Region.id;
        MarketShare23.District__c = District.id;           
        MarketShare23.Territory__c=null;
        MarketShare23.TRx__c=100;
        MarketShare23.Previous_Month_TRx__c=80;
        MarketShare23.DDD_Dollars__c=null;
        MarketShare23.Previous_DDD_Dollars__c=null;
        MarketShare23.DDD_Units__c=null;
        MarketShare23.Previous_DDD_Units__c=null;
        MarketShare23.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare23);

		MYBZ_Market_Share__c MarketShare24 = New MYBZ_Market_Share__c();
        MarketShare24.Name='TestMarket';
        MarketShare24.Market__c = 'Test Market 1';
        MarketShare24.Global_Id__c='3';        
        MarketShare24.Month__c=3;
        MarketShare24.Month_Number__c = '3';
        MarketShare24.Year_Number__c = '2015';
        MarketShare24.Year__c=2015;        
        MarketShare24.Owner__c='COMPETITOR';
        MarketShare24.Product__c=IHSProduct4.ID;
        MarketShare24.Division__c = Div.id;
        MarketShare24.Region__c=Region.id;
        MarketShare24.District__c = District.id;           
        MarketShare24.Territory__c=null;
        MarketShare24.TRx__c=100;
        MarketShare24.Previous_Month_TRx__c=80;
        MarketShare24.DDD_Dollars__c=null;
        MarketShare24.Previous_DDD_Dollars__c=null;
        MarketShare24.DDD_Units__c=null;
        MarketShare24.Previous_DDD_Units__c=null;
        MarketShare24.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare24);
        
        MYBZ_Market_Share__c MarketShare25 = New MYBZ_Market_Share__c();
        MarketShare25.Name='TestMarket';
        MarketShare25.Market__c = 'Test Market 2';
        MarketShare25.Global_Id__c='3';        
        MarketShare25.Month__c=1;
        MarketShare25.Month_Number__c = '1';
        MarketShare25.Year_Number__c = '2015';
        MarketShare25.Year__c=2015;        
        MarketShare25.Owner__c='LILLY';
        MarketShare25.Product__c=IHSProduct1.ID;
        MarketShare25.Division__c = Div.id;
        MarketShare25.Region__c=Region.id;
        MarketShare25.District__c = District.id;           
        MarketShare25.Territory__c=null;
        MarketShare25.TRx__c=null;
        MarketShare25.Previous_Month_TRx__c=null;
        MarketShare25.DDD_Dollars__c=80;
        MarketShare25.Previous_DDD_Dollars__c=90;
        MarketShare25.DDD_Units__c=80;
        MarketShare25.Previous_DDD_Units__c=90;
        MarketShare25.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare25);
        
        
        MYBZ_Market_Share__c MarketShare26 = New MYBZ_Market_Share__c();
        MarketShare26.Name='TestMarket';
        MarketShare26.Market__c = 'Test Market 2';
        MarketShare26.Global_Id__c='3';        
        MarketShare26.Month__c=2;
        MarketShare26.Month_Number__c = '2';
        MarketShare26.Year_Number__c = '2015';
        MarketShare26.Year__c=2015;        
        MarketShare26.Owner__c='LILLY';
        MarketShare26.Product__c=IHSProduct1.ID;
        MarketShare26.Division__c = Div.id;
        MarketShare26.Region__c=Region.id;
        MarketShare26.District__c = District.id;           
        MarketShare26.Territory__c=null;
        MarketShare26.TRx__c=null;
        MarketShare26.Previous_Month_TRx__c=null;
        MarketShare26.DDD_Dollars__c=100;
        MarketShare26.Previous_DDD_Dollars__c=80;
        MarketShare26.DDD_Units__c=100;
        MarketShare26.Previous_DDD_Units__c=80;
        MarketShare26.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare26);

		MYBZ_Market_Share__c MarketShare27 = New MYBZ_Market_Share__c();
        MarketShare27.Name='TestMarket';
        MarketShare27.Market__c = 'Test Market 2';
        MarketShare27.Global_Id__c='3';        
        MarketShare27.Month__c=3;
        MarketShare27.Month_Number__c = '3';
        MarketShare27.Year_Number__c = '2015';
        MarketShare27.Year__c=2015;        
        MarketShare27.Owner__c='LILLY';
        MarketShare27.Product__c=IHSProduct1.ID;
        MarketShare27.Division__c = Div.id;
        MarketShare27.Region__c=Region.id;
        MarketShare27.District__c = District.id;           
        MarketShare27.Territory__c=null;
        MarketShare27.TRx__c=null;
        MarketShare27.Previous_Month_TRx__c=null;
        MarketShare27.DDD_Dollars__c=100;
        MarketShare27.Previous_DDD_Dollars__c=90;
        MarketShare27.DDD_Units__c=100;
        MarketShare27.Previous_DDD_Units__c=90;
        MarketShare27.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare27);
        
        // NON Affliation Territory level dataa
		
        MYBZ_Market_Share__c MarketShare28 = New MYBZ_Market_Share__c();
        MarketShare28.Name='TestMarket';
        MarketShare28.Market__c = 'Test Market 1';
        MarketShare28.Global_Id__c='4';        
        MarketShare28.Month__c=1;
        MarketShare28.Month_Number__c = '1';
        MarketShare28.Year_Number__c = '2015';
        MarketShare28.Year__c=2015;        
        MarketShare28.Owner__c='LILLY';
        MarketShare28.Product__c=IHSProduct1.ID;
        MarketShare28.Division__c = Div.id;
        MarketShare28.Region__c=Region.id;
        MarketShare28.District__c = District.id;           
        MarketShare28.Territory__c=Territory.id;
        MarketShare28.TRx__c=80;
        MarketShare28.Previous_Month_TRx__c=90;
        MarketShare28.DDD_Dollars__c=null;
        MarketShare28.Previous_DDD_Dollars__c=null;
        MarketShare28.DDD_Units__c=null;
        MarketShare28.Previous_DDD_Units__c=null;
        MarketShare28.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare28);
        
        
       MYBZ_Market_Share__c MarketShare29 = New MYBZ_Market_Share__c();
       MarketShare29.Name='TestMarket';
       MarketShare29.Market__c = 'Test Market 1';
       MarketShare29.Global_Id__c='4';        
       MarketShare29.Month__c=2;
       MarketShare29.Month_Number__c = '2';
       MarketShare29.Year_Number__c = '2015';
       MarketShare29.Year__c=2015;        
       MarketShare29.Owner__c='LILLY';
       MarketShare29.Product__c=IHSProduct1.ID;
       MarketShare29.Division__c = Div.id;
       MarketShare29.Region__c=Region.id;
       MarketShare29.District__c = District.id;           
       MarketShare29.Territory__c=null;
       MarketShare29.TRx__c=100;
       MarketShare29.Previous_Month_TRx__c=80;
       MarketShare29.DDD_Dollars__c=null;
       MarketShare29.Previous_DDD_Dollars__c=null;
       MarketShare29.DDD_Units__c=null;
       MarketShare29.Previous_DDD_Units__c=null;
       MarketShare29.LoadIdentifier__c = 'NON_AFFLTN';
       marketShareList.add(MarketShare29);

		MYBZ_Market_Share__c MarketShare30 = New MYBZ_Market_Share__c();
        MarketShare30.Name='TestMarket';
        MarketShare30.Market__c = 'Test Market 1';
        MarketShare30.Global_Id__c='4';        
        MarketShare30.Month__c=3;
        MarketShare30.Month_Number__c = '3';
        MarketShare30.Year_Number__c = '2015';
        MarketShare30.Year__c=2015;        
        MarketShare30.Owner__c='LILLY';
        MarketShare30.Product__c=IHSProduct1.ID;
        MarketShare30.Division__c = Div.id;
        MarketShare30.Region__c=Region.id;
        MarketShare30.District__c = District.id;           
        MarketShare30.Territory__c=null;
        MarketShare30.TRx__c=100;
        MarketShare30.Previous_Month_TRx__c=80;
        MarketShare30.DDD_Dollars__c=null;
        MarketShare30.Previous_DDD_Dollars__c=null;
        MarketShare30.DDD_Units__c=null;
        MarketShare30.Previous_DDD_Units__c=null;
        MarketShare30.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare30);
        
        
        MYBZ_Market_Share__c MarketShare31 = New MYBZ_Market_Share__c();
        MarketShare31.Name='TestMarket';
        MarketShare31.Market__c = 'Test Market 1';
        MarketShare31.Global_Id__c='4';        
        MarketShare31.Month__c=1;
        MarketShare31.Month_Number__c = '1';
        MarketShare31.Year_Number__c = '2015';
        MarketShare31.Year__c=2015;        
        MarketShare31.Owner__c='COMPETITOR';
        MarketShare31.Product__c=IHSProduct4.ID;
        MarketShare31.Division__c = Div.id;
        MarketShare31.Region__c=Region.id;
        MarketShare31.District__c = District.id;           
        MarketShare31.Territory__c=null;
        MarketShare31.TRx__c=80;
        MarketShare31.Previous_Month_TRx__c=90;
        MarketShare31.DDD_Dollars__c=null;
        MarketShare31.Previous_DDD_Dollars__c=null;
        MarketShare31.DDD_Units__c=null;
        MarketShare31.Previous_DDD_Units__c=null;
        MarketShare31.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare31);
        
        
        MYBZ_Market_Share__c MarketShare32 = New MYBZ_Market_Share__c();
        MarketShare32.Name='TestMarket';
        MarketShare32.Market__c = 'Test Market 1';
        MarketShare32.Global_Id__c='4';        
        MarketShare32.Month__c=2;
        MarketShare32.Month_Number__c = '2';
        MarketShare32.Year_Number__c = '2015';
        MarketShare32.Year__c=2015;        
        MarketShare32.Owner__c='COMPETITOR';
        MarketShare32.Product__c=IHSProduct4.ID;
        MarketShare32.Division__c = Div.id;
        MarketShare32.Region__c=Region.id;
        MarketShare32.District__c = District.id;           
        MarketShare32.Territory__c=null;
        MarketShare32.TRx__c=100;
        MarketShare32.Previous_Month_TRx__c=80;
        MarketShare32.DDD_Dollars__c=null;
        MarketShare32.Previous_DDD_Dollars__c=null;
        MarketShare32.DDD_Units__c=null;
        MarketShare32.Previous_DDD_Units__c=null;
        MarketShare32.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare32);

		MYBZ_Market_Share__c MarketShare33 = New MYBZ_Market_Share__c();
        MarketShare33.Name='TestMarket';
        MarketShare33.Market__c = 'Test Market 1';
        MarketShare33.Global_Id__c='4';        
        MarketShare33.Month__c=3;
        MarketShare33.Month_Number__c = '3';
        MarketShare33.Year_Number__c = '2015';
        MarketShare33.Year__c=2015;        
        MarketShare33.Owner__c='COMPETITOR';
        MarketShare33.Product__c=IHSProduct4.ID;
        MarketShare33.Division__c = Div.id;
        MarketShare33.Region__c=Region.id;
        MarketShare33.District__c = District.id;           
        MarketShare33.Territory__c=null;
        MarketShare33.TRx__c=100;
        MarketShare33.Previous_Month_TRx__c=80;
        MarketShare33.DDD_Dollars__c=null;
        MarketShare33.Previous_DDD_Dollars__c=null;
        MarketShare33.DDD_Units__c=null;
        MarketShare33.Previous_DDD_Units__c=null;
        MarketShare33.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare33);
        
        MYBZ_Market_Share__c MarketShare34 = New MYBZ_Market_Share__c();
        MarketShare34.Name='TestMarket';
        MarketShare34.Market__c = 'Test Market 2';
        MarketShare34.Global_Id__c='4';        
        MarketShare34.Month__c=1;
        MarketShare34.Month_Number__c = '1';
        MarketShare34.Year_Number__c = '2015';
        MarketShare34.Year__c=2015;        
        MarketShare34.Owner__c='LILLY';
        MarketShare34.Product__c=IHSProduct1.ID;
        MarketShare34.Division__c = Div.id;
        MarketShare34.Region__c=Region.id;
        MarketShare34.District__c = District.id;           
        MarketShare34.Territory__c=null;
        MarketShare34.TRx__c=null;
        MarketShare34.Previous_Month_TRx__c=null;
        MarketShare34.DDD_Dollars__c=80;
        MarketShare34.Previous_DDD_Dollars__c=90;
        MarketShare34.DDD_Units__c=80;
        MarketShare34.Previous_DDD_Units__c=90;
        MarketShare34.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare34);
        
        MYBZ_Market_Share__c MarketShare35 = New MYBZ_Market_Share__c();
        MarketShare35.Name='TestMarket';
        MarketShare35.Market__c = 'Test Market 2';
        MarketShare35.Global_Id__c='4';        
        MarketShare35.Month__c=2;
        MarketShare35.Month_Number__c = '2';
        MarketShare35.Year_Number__c = '2015';
        MarketShare35.Year__c=2015;        
        MarketShare35.Owner__c='LILLY';
        MarketShare35.Product__c=IHSProduct1.ID;
        MarketShare35.Division__c = Div.id;
        MarketShare35.Region__c=Region.id;
        MarketShare35.District__c = District.id;           
        MarketShare35.Territory__c=null;
        MarketShare35.TRx__c=null;
        MarketShare35.Previous_Month_TRx__c=null;
        MarketShare35.DDD_Dollars__c=100;
        MarketShare35.Previous_DDD_Dollars__c=80;
        MarketShare35.DDD_Units__c=100;
        MarketShare35.Previous_DDD_Units__c=80;
        MarketShare35.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare35);

		MYBZ_Market_Share__c MarketShare36 = New MYBZ_Market_Share__c();
        MarketShare36.Name='TestMarket';
        MarketShare36.Market__c = 'Test Market 2';
        MarketShare36.Global_Id__c='4';        
        MarketShare36.Month__c=3;
        MarketShare36.Month_Number__c = '3';
        MarketShare36.Year_Number__c = '2015';
        MarketShare36.Year__c=2015;        
        MarketShare36.Owner__c='LILLY';
        MarketShare36.Product__c=IHSProduct1.ID;
        MarketShare36.Division__c = Div.id;
        MarketShare36.Region__c=Region.id;
        MarketShare36.District__c = District.id;           
        MarketShare36.Territory__c=null;
        MarketShare36.TRx__c=null;
        MarketShare36.Previous_Month_TRx__c=null;
        MarketShare36.DDD_Dollars__c=100;
        MarketShare36.Previous_DDD_Dollars__c=90;
        MarketShare36.DDD_Units__c=100;
        MarketShare36.Previous_DDD_Units__c=90;
        MarketShare36.LoadIdentifier__c = 'NON_AFFLTN';
        marketShareList.add(MarketShare36);
        
        
        //  Affliation division level dataa
		
        MYBZ_Market_Share__c MarketShareAff1 = New MYBZ_Market_Share__c();
        MarketShareAff1.Name='TestMarket';
        MarketShareAff1.Market__c = 'Test Market 1';
        MarketShareAff1.Global_Id__c='1';        
        MarketShareAff1.Month__c=1;
        MarketShareAff1.Month_Number__c = '1';
        MarketShareAff1.Year_Number__c = '2015';
        MarketShareAff1.Year__c=2015;        
        MarketShareAff1.Owner__c='LILLY';
        MarketShareAff1.Product__c=IHSProduct1.ID;
        MarketShareAff1.Division__c = Div.id;
        MarketShareAff1.Region__c=null;
        MarketShareAff1.District__c = null;           
        MarketShareAff1.Territory__c=null;
        MarketShareAff1.TRx__c=80;
        MarketShareAff1.Previous_Month_TRx__c=90;
        MarketShareAff1.DDD_Dollars__c=null;
        MarketShareAff1.Previous_DDD_Dollars__c=null;
        MarketShareAff1.DDD_Units__c=null;
        MarketShareAff1.Previous_DDD_Units__c=null;
        MarketShareAff1.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff1);
        
        
        MYBZ_Market_Share__c MarketShareAff2 = New MYBZ_Market_Share__c();
        MarketShareAff2.Name='TestMarket';
        MarketShareAff2.Market__c = 'Test Market 1';
        MarketShareAff2.Global_Id__c='1';        
        MarketShareAff2.Month__c=2;
        MarketShareAff2.Month_Number__c = '2';
        MarketShareAff2.Year_Number__c = '2015';
        MarketShareAff2.Year__c=2015;        
        MarketShareAff2.Owner__c='LILLY';
        MarketShareAff2.Product__c=IHSProduct1.ID;
        MarketShareAff2.Division__c = Div.id;
        MarketShareAff2.Region__c=null;
        MarketShareAff2.District__c = null;           
        MarketShareAff2.Territory__c=null;
        MarketShareAff2.TRx__c=100;
        MarketShareAff2.Previous_Month_TRx__c=80;
        MarketShareAff2.DDD_Dollars__c=null;
        MarketShareAff2.Previous_DDD_Dollars__c=null;
        MarketShareAff2.DDD_Units__c=null;
        MarketShareAff2.Previous_DDD_Units__c=null;
        MarketShareAff2.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff2);

		MYBZ_Market_Share__c MarketShareAff3 = New MYBZ_Market_Share__c();
        MarketShareAff3.Name='TestMarket';
        MarketShareAff3.Market__c = 'Test Market 1';
        MarketShareAff3.Global_Id__c='1';        
        MarketShareAff3.Month__c=3;
        MarketShareAff3.Month_Number__c = '3';
        MarketShareAff3.Year_Number__c = '2015';
        MarketShareAff3.Year__c=2015;        
        MarketShareAff3.Owner__c='LILLY';
        MarketShareAff3.Product__c=IHSProduct1.ID;
        MarketShareAff3.Division__c = Div.id;
        MarketShareAff3.Region__c=null;
        MarketShareAff3.District__c = null;           
        MarketShareAff3.Territory__c=null;
        MarketShareAff3.TRx__c=100;
        MarketShareAff3.Previous_Month_TRx__c=80;
        MarketShareAff3.DDD_Dollars__c=null;
        MarketShareAff3.Previous_DDD_Dollars__c=null;
        MarketShareAff3.DDD_Units__c=null;
        MarketShareAff3.Previous_DDD_Units__c=null;
        MarketShareAff3.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff3);
        
        
        MYBZ_Market_Share__c MarketShareAff4 = New MYBZ_Market_Share__c();
        MarketShareAff4.Name='TestMarket';
        MarketShareAff4.Market__c = 'Test Market 1';
        MarketShareAff4.Global_Id__c='1';        
        MarketShareAff4.Month__c=1;
        MarketShareAff4.Month_Number__c = '1';
        MarketShareAff4.Year_Number__c = '2015';
        MarketShareAff4.Year__c=2015;        
        MarketShareAff4.Owner__c='COMPETITOR';
        MarketShareAff4.Product__c=IHSProduct4.ID;
        MarketShareAff4.Division__c = Div.id;
        MarketShareAff4.Region__c=null;
        MarketShareAff4.District__c = null;           
        MarketShareAff4.Territory__c=null;
        MarketShareAff4.TRx__c=80;
        MarketShareAff4.Previous_Month_TRx__c=90;
        MarketShareAff4.DDD_Dollars__c=null;
        MarketShareAff4.Previous_DDD_Dollars__c=null;
        MarketShareAff4.DDD_Units__c=null;
        MarketShareAff4.Previous_DDD_Units__c=null;
        MarketShareAff4.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff4);
        
        
        MYBZ_Market_Share__c MarketShareAff5 = New MYBZ_Market_Share__c();
        MarketShareAff5.Name='TestMarket';
        MarketShareAff5.Market__c = 'Test Market 1';
        MarketShareAff5.Global_Id__c='1';        
        MarketShareAff5.Month__c=2;
        MarketShareAff5.Month_Number__c = '2';
        MarketShareAff5.Year_Number__c = '2015';
        MarketShareAff5.Year__c=2015;        
        MarketShareAff5.Owner__c='COMPETITOR';
        MarketShareAff5.Product__c=IHSProduct4.ID;
        MarketShareAff5.Division__c = Div.id;
        MarketShareAff5.Region__c=null;
        MarketShareAff5.District__c = null;           
        MarketShareAff5.Territory__c=null;
        MarketShareAff5.TRx__c=100;
        MarketShareAff5.Previous_Month_TRx__c=80;
        MarketShareAff5.DDD_Dollars__c=null;
        MarketShareAff5.Previous_DDD_Dollars__c=null;
        MarketShareAff5.DDD_Units__c=null;
        MarketShareAff5.Previous_DDD_Units__c=null;
        MarketShareAff5.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff5);

		MYBZ_Market_Share__c MarketShareAff6 = New MYBZ_Market_Share__c();
        MarketShareAff6.Name='TestMarket';
        MarketShareAff6.Market__c = 'Test Market 1';
        MarketShareAff6.Global_Id__c='1';        
        MarketShareAff6.Month__c=3;
        MarketShareAff6.Month_Number__c = '3';
        MarketShareAff6.Year_Number__c = '2015';
        MarketShareAff6.Year__c=2015;        
        MarketShareAff6.Owner__c='COMPETITOR';
        MarketShareAff6.Product__c=IHSProduct4.ID;
        MarketShareAff6.Division__c = Div.id;
        MarketShareAff6.Region__c=null;
        MarketShareAff6.District__c = null;           
        MarketShareAff6.Territory__c=null;
        MarketShareAff6.TRx__c=100;
        MarketShareAff6.Previous_Month_TRx__c=80;
        MarketShareAff6.DDD_Dollars__c=null;
        MarketShareAff6.Previous_DDD_Dollars__c=null;
        MarketShareAff6.DDD_Units__c=null;
        MarketShareAff6.Previous_DDD_Units__c=null;
        MarketShareAff6.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff6);
        
        MYBZ_Market_Share__c MarketShareAff7 = New MYBZ_Market_Share__c();
        MarketShareAff7.Name='TestMarket';
        MarketShareAff7.Market__c = 'Test Market 2';
        MarketShareAff7.Global_Id__c='18785';        
        MarketShareAff7.Month__c=1;
        MarketShareAff7.Month_Number__c = '1';
        MarketShareAff7.Year_Number__c = '2015';
        MarketShareAff7.Year__c=2015;        
        MarketShareAff7.Owner__c='LILLY';
        MarketShareAff7.Product__c=IHSProduct1.ID;
        MarketShareAff7.Division__c = Div.id;
        MarketShareAff7.Region__c=null;
        MarketShareAff7.District__c = null;           
        MarketShareAff7.Territory__c=null;
        MarketShareAff7.TRx__c=null;
        MarketShareAff7.Previous_Month_TRx__c=null;
        MarketShareAff7.DDD_Dollars__c=80;
        MarketShareAff7.Previous_DDD_Dollars__c=90;
        MarketShareAff7.DDD_Units__c=80;
        MarketShareAff7.Previous_DDD_Units__c=90;
        MarketShareAff7.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff7);
        
        
        MYBZ_Market_Share__c MarketShareAff8 = New MYBZ_Market_Share__c();
        MarketShareAff8.Name='TestMarket';
        MarketShareAff8.Market__c = 'Test Market 2';
        MarketShareAff8.Global_Id__c='1';        
        MarketShareAff8.Month__c=2;
        MarketShareAff8.Month_Number__c = '2';
        MarketShareAff8.Year_Number__c = '2015';
        MarketShareAff8.Year__c=2015;        
        MarketShareAff8.Owner__c='LILLY';
        MarketShareAff8.Product__c=IHSProduct1.ID;
        MarketShareAff8.Division__c = Div.id;
        MarketShareAff8.Region__c=null;
        MarketShareAff8.District__c = null;           
        MarketShareAff8.Territory__c=null;
        MarketShareAff8.TRx__c=null;
        MarketShareAff8.Previous_Month_TRx__c=null;
        MarketShareAff8.DDD_Dollars__c=100;
        MarketShareAff8.Previous_DDD_Dollars__c=80;
        MarketShareAff8.DDD_Units__c=100;
        MarketShareAff8.Previous_DDD_Units__c=80;
        MarketShareAff8.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff8);

		MYBZ_Market_Share__c MarketShareAff9 = New MYBZ_Market_Share__c();
        MarketShareAff9.Name='TestMarket';
        MarketShareAff9.Market__c = 'Test Market 2';
        MarketShareAff9.Global_Id__c='1';        
        MarketShareAff9.Month__c=3;
        MarketShareAff9.Month_Number__c = '3';
        MarketShareAff9.Year_Number__c = '2015';
        MarketShareAff9.Year__c=2015;        
        MarketShareAff9.Owner__c='LILLY';
        MarketShareAff9.Product__c=IHSProduct1.ID;
        MarketShareAff9.Division__c = Div.id;
        MarketShareAff9.Region__c=null;
        MarketShareAff9.District__c = null;           
        MarketShareAff9.Territory__c=null;
        MarketShareAff9.TRx__c=null;
        MarketShareAff9.Previous_Month_TRx__c=null;
        MarketShareAff9.DDD_Dollars__c=100;
        MarketShareAff9.Previous_DDD_Dollars__c=90;
        MarketShareAff9.DDD_Units__c=100;
        MarketShareAff9.Previous_DDD_Units__c=90;
        MarketShareAff9.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff9);
        
        
        // Affliation Region level dataa
		
        MYBZ_Market_Share__c MarketShareAff10 = New MYBZ_Market_Share__c();
        MarketShareAff10.Name='TestMarket';
        MarketShareAff10.Market__c = 'Test Market 1';
        MarketShareAff10.Global_Id__c='2';        
        MarketShareAff10.Month__c=1;
        MarketShareAff10.Month_Number__c = '1';
        MarketShareAff10.Year_Number__c = '2015';
        MarketShareAff10.Year__c=2015;        
        MarketShareAff10.Owner__c='LILLY';
        MarketShareAff10.Product__c=IHSProduct1.ID;
        MarketShareAff10.Division__c = Div.id;
        MarketShareAff10.Region__c=Region.id;
        MarketShareAff10.District__c = null;           
        MarketShareAff10.Territory__c=null;
        MarketShareAff10.TRx__c=80;
        MarketShareAff10.Previous_Month_TRx__c=90;
        MarketShareAff10.DDD_Dollars__c=null;
        MarketShareAff10.Previous_DDD_Dollars__c=null;
        MarketShareAff10.DDD_Units__c=null;
        MarketShareAff10.Previous_DDD_Units__c=null;
        MarketShareAff10.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff10);
        
        
        MYBZ_Market_Share__c MarketShareAff11 = New MYBZ_Market_Share__c();
        MarketShareAff11.Name='TestMarket';
        MarketShareAff11.Market__c = 'Test Market 1';
        MarketShareAff11.Global_Id__c='2';        
        MarketShareAff11.Month__c=2;
        MarketShareAff11.Month_Number__c = '2';
        MarketShareAff11.Year_Number__c = '2015';
        MarketShareAff11.Year__c=2015;        
        MarketShareAff11.Owner__c='LILLY';
        MarketShareAff11.Product__c=IHSProduct1.ID;
        MarketShareAff11.Division__c = Div.id;
        MarketShareAff11.Region__c=Region.id;
        MarketShareAff11.District__c = null;           
        MarketShareAff11.Territory__c=null;
        MarketShareAff11.TRx__c=100;
        MarketShareAff11.Previous_Month_TRx__c=80;
        MarketShareAff11.DDD_Dollars__c=null;
        MarketShareAff11.Previous_DDD_Dollars__c=null;
        MarketShareAff11.DDD_Units__c=null;
        MarketShareAff11.Previous_DDD_Units__c=null;
        MarketShareAff11.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff11);

		MYBZ_Market_Share__c MarketShareAff12 = New MYBZ_Market_Share__c();
        MarketShareAff12.Name='TestMarket';
        MarketShareAff12.Market__c = 'Test Market 1';
        MarketShareAff12.Global_Id__c='2';        
        MarketShareAff12.Month__c=3;
        MarketShareAff12.Month_Number__c = '3';
        MarketShareAff12.Year_Number__c = '2015';
        MarketShareAff12.Year__c=2015;        
        MarketShareAff12.Owner__c='LILLY';
        MarketShareAff12.Product__c=IHSProduct1.ID;
        MarketShareAff12.Division__c = Div.id;
        MarketShareAff12.Region__c=Region.id;
        MarketShareAff12.District__c = null;           
        MarketShareAff12.Territory__c=null;
        MarketShareAff12.TRx__c=100;
        MarketShareAff12.Previous_Month_TRx__c=80;
        MarketShareAff12.DDD_Dollars__c=null;
        MarketShareAff12.Previous_DDD_Dollars__c=null;
        MarketShareAff12.DDD_Units__c=null;
        MarketShareAff12.Previous_DDD_Units__c=null;
        MarketShareAff12.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff12);
        
        
        MYBZ_Market_Share__c MarketShareAff13 = New MYBZ_Market_Share__c();
        MarketShareAff13.Name='TestMarket';
        MarketShareAff13.Market__c = 'Test Market 1';
        MarketShareAff13.Global_Id__c='2';        
        MarketShareAff13.Month__c=1;
        MarketShareAff13.Month_Number__c = '1';
        MarketShareAff13.Year_Number__c = '2015';
        MarketShareAff13.Year__c=2015;        
        MarketShareAff13.Owner__c='COMPETITOR';
        MarketShareAff13.Product__c=IHSProduct4.ID;
        MarketShareAff13.Division__c = Div.id;
        MarketShareAff13.Region__c=Region.id;
        MarketShareAff13.District__c = null;           
        MarketShareAff13.Territory__c=null;
        MarketShareAff13.TRx__c=80;
        MarketShareAff13.Previous_Month_TRx__c=90;
        MarketShareAff13.DDD_Dollars__c=null;
        MarketShareAff13.Previous_DDD_Dollars__c=null;
        MarketShareAff13.DDD_Units__c=null;
        MarketShareAff13.Previous_DDD_Units__c=null;
        MarketShareAff13.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff13);
        
        
        MYBZ_Market_Share__c MarketShareAff14 = New MYBZ_Market_Share__c();
        MarketShareAff14.Name='TestMarket';
        MarketShareAff14.Market__c = 'Test Market 1';
        MarketShareAff14.Global_Id__c='2';        
        MarketShareAff14.Month__c=2;
        MarketShareAff14.Month_Number__c = '2';
        MarketShareAff14.Year_Number__c = '2015';
        MarketShareAff14.Year__c=2015;        
        MarketShareAff14.Owner__c='COMPETITOR';
        MarketShareAff14.Product__c=IHSProduct4.ID;
        MarketShareAff14.Division__c = Div.id;
        MarketShareAff14.Region__c=Region.id;
        MarketShareAff14.District__c = null;           
        MarketShareAff14.Territory__c=null;
        MarketShareAff14.TRx__c=100;
        MarketShareAff14.Previous_Month_TRx__c=80;
        MarketShareAff14.DDD_Dollars__c=null;
        MarketShareAff14.Previous_DDD_Dollars__c=null;
        MarketShareAff14.DDD_Units__c=null;
        MarketShareAff14.Previous_DDD_Units__c=null;
        MarketShareAff14.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff14);

		MYBZ_Market_Share__c MarketShareAff15 = New MYBZ_Market_Share__c();
        MarketShareAff15.Name='TestMarket';
        MarketShareAff15.Market__c = 'Test Market 1';
        MarketShareAff15.Global_Id__c='2';        
        MarketShareAff15.Month__c=3;
        MarketShareAff15.Month_Number__c = '3';
        MarketShareAff15.Year_Number__c = '2015';
        MarketShareAff15.Year__c=2015;        
        MarketShareAff15.Owner__c='COMPETITOR';
        MarketShareAff15.Product__c=IHSProduct4.ID;
        MarketShareAff15.Division__c = Div.id;
        MarketShareAff15.Region__c=Region.id;
        MarketShareAff15.District__c = null;           
        MarketShareAff15.Territory__c=null;
        MarketShareAff15.TRx__c=100;
        MarketShareAff15.Previous_Month_TRx__c=80;
        MarketShareAff15.DDD_Dollars__c=null;
        MarketShareAff15.Previous_DDD_Dollars__c=null;
        MarketShareAff15.DDD_Units__c=null;
        MarketShareAff15.Previous_DDD_Units__c=null;
        MarketShareAff15.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff15);
        
        MYBZ_Market_Share__c MarketShareAff16 = New MYBZ_Market_Share__c();
        MarketShareAff16.Name='TestMarket';
        MarketShareAff16.Market__c = 'Test Market 2';
        MarketShareAff16.Global_Id__c='2';        
        MarketShareAff16.Month__c=1;
        MarketShareAff16.Month_Number__c = '1';
        MarketShareAff16.Year_Number__c = '2015';
        MarketShareAff16.Year__c=2015;        
        MarketShareAff16.Owner__c='LILLY';
        MarketShareAff16.Product__c=IHSProduct1.ID;
        MarketShareAff16.Division__c = Div.id;
        MarketShareAff16.Region__c=Region.id;
        MarketShareAff16.District__c = null;           
        MarketShareAff16.Territory__c=null;
        MarketShareAff16.TRx__c=null;
        MarketShareAff16.Previous_Month_TRx__c=null;
        MarketShareAff16.DDD_Dollars__c=80;
        MarketShareAff16.Previous_DDD_Dollars__c=90;
        MarketShareAff16.DDD_Units__c=80;
        MarketShareAff16.Previous_DDD_Units__c=90;
        MarketShareAff16.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff16);
        
        
        MYBZ_Market_Share__c MarketShareAff17 = New MYBZ_Market_Share__c();
        MarketShareAff17.Name='TestMarket';
        MarketShareAff17.Market__c = 'Test Market 2';
        MarketShareAff17.Global_Id__c='2';        
        MarketShareAff17.Month__c=2;
        MarketShareAff17.Month_Number__c = '2';
        MarketShareAff17.Year_Number__c = '2015';
        MarketShareAff17.Year__c=2015;        
        MarketShareAff17.Owner__c='LILLY';
        MarketShareAff17.Product__c=IHSProduct1.ID;
        MarketShareAff17.Division__c = Div.id;
        MarketShareAff17.Region__c=Region.id;
        MarketShareAff17.District__c = null;           
        MarketShareAff17.Territory__c=null;
        MarketShareAff17.TRx__c=null;
        MarketShareAff17.Previous_Month_TRx__c=null;
        MarketShareAff17.DDD_Dollars__c=100;
        MarketShareAff17.Previous_DDD_Dollars__c=80;
        MarketShareAff17.DDD_Units__c=100;
        MarketShareAff17.Previous_DDD_Units__c=80;
        MarketShareAff17.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff17);

		MYBZ_Market_Share__c MarketShareAff18 = New MYBZ_Market_Share__c();
        MarketShareAff18.Name='TestMarket';
        MarketShareAff18.Market__c = 'Test Market 2';
        MarketShareAff18.Global_Id__c='2';        
        MarketShareAff18.Month__c=3;
        MarketShareAff18.Month_Number__c = '3';
        MarketShareAff18.Year_Number__c = '2015';
        MarketShareAff18.Year__c=2015;        
        MarketShareAff18.Owner__c='LILLY';
        MarketShareAff18.Product__c=IHSProduct1.ID;
        MarketShareAff18.Division__c = Div.id;
        MarketShareAff18.Region__c=Region.id;
        MarketShareAff18.District__c = null;           
        MarketShareAff18.Territory__c=null;
        MarketShareAff18.TRx__c=null;
        MarketShareAff18.Previous_Month_TRx__c=null;
        MarketShareAff18.DDD_Dollars__c=100;
        MarketShareAff18.Previous_DDD_Dollars__c=90;
        MarketShareAff18.DDD_Units__c=100;
        MarketShareAff18.Previous_DDD_Units__c=90;
        MarketShareAff18.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff18);
        
        
         // Affliation District level dataa
		
        MYBZ_Market_Share__c MarketShareAff19 = New MYBZ_Market_Share__c();
        MarketShareAff19.Name='TestMarket';
        MarketShareAff19.Market__c = 'Test Market 1';
        MarketShareAff19.Global_Id__c='3';        
        MarketShareAff19.Month__c=1;
        MarketShareAff19.Month_Number__c = '1';
        MarketShareAff19.Year_Number__c = '2015';
        MarketShareAff19.Year__c=2015;        
        MarketShareAff19.Owner__c='LILLY';
        MarketShareAff19.Product__c=IHSProduct1.ID;
        MarketShareAff19.Division__c = Div.id;
        MarketShareAff19.Region__c=Region.id;
        MarketShareAff19.District__c = District.id;           
        MarketShareAff19.Territory__c=null;
        MarketShareAff19.TRx__c=80;
        MarketShareAff19.Previous_Month_TRx__c=90;
        MarketShareAff19.DDD_Dollars__c=null;
        MarketShareAff19.Previous_DDD_Dollars__c=null;
        MarketShareAff19.DDD_Units__c=null;
        MarketShareAff19.Previous_DDD_Units__c=null;
        MarketShareAff19.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff19);
        
        
        MYBZ_Market_Share__c MarketShareAff20 = New MYBZ_Market_Share__c();
        MarketShareAff20.Name='TestMarket';
        MarketShareAff20.Market__c = 'Test Market 1';
        MarketShareAff20.Global_Id__c='3';        
        MarketShareAff20.Month__c=2;
        MarketShareAff20.Month_Number__c = '2';
        MarketShareAff20.Year_Number__c = '2015';
        MarketShareAff20.Year__c=2015;        
        MarketShareAff20.Owner__c='LILLY';
        MarketShareAff20.Product__c=IHSProduct1.ID;
        MarketShareAff20.Division__c = Div.id;
        MarketShareAff20.Region__c=Region.id;
        MarketShareAff20.District__c = District.id;           
        MarketShareAff20.Territory__c=null;
        MarketShareAff20.TRx__c=100;
        MarketShareAff20.Previous_Month_TRx__c=80;
        MarketShareAff20.DDD_Dollars__c=null;
        MarketShareAff20.Previous_DDD_Dollars__c=null;
        MarketShareAff20.DDD_Units__c=null;
        MarketShareAff20.Previous_DDD_Units__c=null;
        MarketShareAff20.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff20);

		MYBZ_Market_Share__c MarketShareAff21 = New MYBZ_Market_Share__c();
        MarketShareAff21.Name='TestMarket';
        MarketShareAff21.Market__c = 'Test Market 1';
        MarketShareAff21.Global_Id__c='3';        
        MarketShareAff21.Month__c=3;
        MarketShareAff21.Month_Number__c = '3';
        MarketShareAff21.Year_Number__c = '2015';
        MarketShareAff21.Year__c=2015;        
        MarketShareAff21.Owner__c='LILLY';
        MarketShareAff21.Product__c=IHSProduct1.ID;
        MarketShareAff21.Division__c = Div.id;
        MarketShareAff21.Region__c=Region.id;
        MarketShareAff21.District__c = District.id;           
        MarketShareAff21.Territory__c=null;
        MarketShareAff21.TRx__c=100;
        MarketShareAff21.Previous_Month_TRx__c=80;
        MarketShareAff21.DDD_Dollars__c=null;
        MarketShareAff21.Previous_DDD_Dollars__c=null;
        MarketShareAff21.DDD_Units__c=null;
        MarketShareAff21.Previous_DDD_Units__c=null;
        MarketShareAff21.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff21);
        
        
        MYBZ_Market_Share__c MarketShareAff22 = New MYBZ_Market_Share__c();
        MarketShareAff22.Name='TestMarket';
        MarketShareAff22.Market__c = 'Test Market 1';
        MarketShareAff22.Global_Id__c='3';        
        MarketShareAff22.Month__c=1;
        MarketShareAff22.Month_Number__c = '1';
        MarketShareAff22.Year_Number__c = '2015';
        MarketShareAff22.Year__c=2015;        
        MarketShareAff22.Owner__c='COMPETITOR';
        MarketShareAff22.Product__c=IHSProduct4.ID;
        MarketShareAff22.Division__c = Div.id;
        MarketShareAff22.Region__c=Region.id;
        MarketShareAff22.District__c = District.id;           
        MarketShareAff22.Territory__c=null;
        MarketShareAff22.TRx__c=80;
        MarketShareAff22.Previous_Month_TRx__c=90;
        MarketShareAff22.DDD_Dollars__c=null;
        MarketShareAff22.Previous_DDD_Dollars__c=null;
        MarketShareAff22.DDD_Units__c=null;
        MarketShareAff22.Previous_DDD_Units__c=null;
        MarketShareAff22.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff22);
        
        
        MYBZ_Market_Share__c MarketShareAff23 = New MYBZ_Market_Share__c();
        MarketShareAff23.Name='TestMarket';
        MarketShareAff23.Market__c = 'Test Market 1';
        MarketShareAff23.Global_Id__c='3';        
        MarketShareAff23.Month__c=2;
        MarketShareAff23.Month_Number__c = '2';
        MarketShareAff23.Year_Number__c = '2015';
        MarketShareAff23.Year__c=2015;        
        MarketShareAff23.Owner__c='COMPETITOR';
        MarketShareAff23.Product__c=IHSProduct4.ID;
        MarketShareAff23.Division__c = Div.id;
        MarketShareAff23.Region__c=Region.id;
        MarketShareAff23.District__c = District.id;           
        MarketShareAff23.Territory__c=null;
        MarketShareAff23.TRx__c=100;
        MarketShareAff23.Previous_Month_TRx__c=80;
        MarketShareAff23.DDD_Dollars__c=null;
        MarketShareAff23.Previous_DDD_Dollars__c=null;
        MarketShareAff23.DDD_Units__c=null;
        MarketShareAff23.Previous_DDD_Units__c=null;
        MarketShareAff23.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff23);

		MYBZ_Market_Share__c MarketShareAff24 = New MYBZ_Market_Share__c();
        MarketShareAff24.Name='TestMarket';
        MarketShareAff24.Market__c = 'Test Market 1';
        MarketShareAff24.Global_Id__c='3';        
        MarketShareAff24.Month__c=3;
        MarketShareAff24.Month_Number__c = '3';
        MarketShareAff24.Year_Number__c = '2015';
        MarketShareAff24.Year__c=2015;        
        MarketShareAff24.Owner__c='COMPETITOR';
        MarketShareAff24.Product__c=IHSProduct4.ID;
        MarketShareAff24.Division__c = Div.id;
        MarketShareAff24.Region__c=Region.id;
        MarketShareAff24.District__c = District.id;           
        MarketShareAff24.Territory__c=null;
        MarketShareAff24.TRx__c=100;
        MarketShareAff24.Previous_Month_TRx__c=80;
        MarketShareAff24.DDD_Dollars__c=null;
        MarketShareAff24.Previous_DDD_Dollars__c=null;
        MarketShareAff24.DDD_Units__c=null;
        MarketShareAff24.Previous_DDD_Units__c=null;
        MarketShareAff24.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff24);
        
        MYBZ_Market_Share__c MarketShareAff25 = New MYBZ_Market_Share__c();
        MarketShareAff25.Name='TestMarket';
        MarketShareAff25.Market__c = 'Test Market 2';
        MarketShareAff25.Global_Id__c='3';        
        MarketShareAff25.Month__c=1;
        MarketShareAff25.Month_Number__c = '1';
        MarketShareAff25.Year_Number__c = '2015';
        MarketShareAff25.Year__c=2015;        
        MarketShareAff25.Owner__c='LILLY';
        MarketShareAff25.Product__c=IHSProduct1.ID;
        MarketShareAff25.Division__c = Div.id;
        MarketShareAff25.Region__c=Region.id;
        MarketShareAff25.District__c = District.id;           
        MarketShareAff25.Territory__c=null;
        MarketShareAff25.TRx__c=null;
        MarketShareAff25.Previous_Month_TRx__c=null;
        MarketShareAff25.DDD_Dollars__c=80;
        MarketShareAff25.Previous_DDD_Dollars__c=90;
        MarketShareAff25.DDD_Units__c=80;
        MarketShareAff25.Previous_DDD_Units__c=90;
        MarketShareAff25.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff25);
        
        
        MYBZ_Market_Share__c MarketShareAff26 = New MYBZ_Market_Share__c();
        MarketShareAff26.Name='TestMarket';
        MarketShareAff26.Market__c = 'Test Market 2';
        MarketShareAff26.Global_Id__c='3';        
        MarketShareAff26.Month__c=2;
        MarketShareAff26.Month_Number__c = '2';
        MarketShareAff26.Year_Number__c = '2015';
        MarketShareAff26.Year__c=2015;        
        MarketShareAff26.Owner__c='LILLY';
        MarketShareAff26.Product__c=IHSProduct1.ID;
        MarketShareAff26.Division__c = Div.id;
        MarketShareAff26.Region__c=Region.id;
        MarketShareAff26.District__c = District.id;           
        MarketShareAff26.Territory__c=null;
        MarketShareAff26.TRx__c=null;
        MarketShareAff26.Previous_Month_TRx__c=null;
        MarketShareAff26.DDD_Dollars__c=100;
        MarketShareAff26.Previous_DDD_Dollars__c=80;
        MarketShareAff26.DDD_Units__c=100;
        MarketShareAff26.Previous_DDD_Units__c=80;
        MarketShareAff26.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff26);

		MYBZ_Market_Share__c MarketShareAff27 = New MYBZ_Market_Share__c();
        MarketShareAff27.Name='TestMarket';
        MarketShareAff27.Market__c = 'Test Market 2';
        MarketShareAff27.Global_Id__c='3';        
        MarketShareAff27.Month__c=3;
        MarketShareAff27.Month_Number__c = '3';
        MarketShareAff27.Year_Number__c = '2015';
        MarketShareAff27.Year__c=2015;        
        MarketShareAff27.Owner__c='LILLY';
        MarketShareAff27.Product__c=IHSProduct1.ID;
        MarketShareAff27.Division__c = Div.id;
        MarketShareAff27.Region__c=Region.id;
        MarketShareAff27.District__c = District.id;           
        MarketShareAff27.Territory__c=null;
        MarketShareAff27.TRx__c=null;
        MarketShareAff27.Previous_Month_TRx__c=null;
        MarketShareAff27.DDD_Dollars__c=100;
        MarketShareAff27.Previous_DDD_Dollars__c=90;
        MarketShareAff27.DDD_Units__c=100;
        MarketShareAff27.Previous_DDD_Units__c=90;
        MarketShareAff27.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff27);
        
        // Affliation Territory level dataa
		
        MYBZ_Market_Share__c MarketShareAff28 = New MYBZ_Market_Share__c();
        MarketShareAff28.Name='TestMarket';
        MarketShareAff28.Market__c = 'Test Market 1';
        MarketShareAff28.Global_Id__c='4';        
        MarketShareAff28.Month__c=1;
        MarketShareAff28.Month_Number__c = '1';
        MarketShareAff28.Year_Number__c = '2015';
        MarketShareAff28.Year__c=2015;        
        MarketShareAff28.Owner__c='LILLY';
        MarketShareAff28.Product__c=IHSProduct1.ID;
        MarketShareAff28.Division__c = Div.id;
        MarketShareAff28.Region__c=Region.id;
        MarketShareAff28.District__c = District.id;           
        MarketShareAff28.Territory__c=Territory.id;
        MarketShareAff28.TRx__c=80;
        MarketShareAff28.Previous_Month_TRx__c=90;
        MarketShareAff28.DDD_Dollars__c=null;
        MarketShareAff28.Previous_DDD_Dollars__c=null;
        MarketShareAff28.DDD_Units__c=null;
        MarketShareAff28.Previous_DDD_Units__c=null;
        MarketShareAff28.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff28);
        
        
       MYBZ_Market_Share__c MarketShareAff29 = New MYBZ_Market_Share__c();
       MarketShareAff29.Name='TestMarket';
       MarketShareAff29.Market__c = 'Test Market 1';
       MarketShareAff29.Global_Id__c='4';        
       MarketShareAff29.Month__c=2;
       MarketShareAff29.Month_Number__c = '2';
       MarketShareAff29.Year_Number__c = '2015';
       MarketShareAff29.Year__c=2015;        
       MarketShareAff29.Owner__c='LILLY';
       MarketShareAff29.Product__c=IHSProduct1.ID;
       MarketShareAff29.Division__c = Div.id;
       MarketShareAff29.Region__c=Region.id;
       MarketShareAff29.District__c = District.id;           
       MarketShareAff29.Territory__c=null;
       MarketShareAff29.TRx__c=100;
       MarketShareAff29.Previous_Month_TRx__c=80;
       MarketShareAff29.DDD_Dollars__c=null;
       MarketShareAff29.Previous_DDD_Dollars__c=null;
       MarketShareAff29.DDD_Units__c=null;
       MarketShareAff29.Previous_DDD_Units__c=null;
       MarketShareAff29.LoadIdentifier__c = 'AFFLTN';
       MarketShareList.add(MarketShareAff29);

		MYBZ_Market_Share__c MarketShareAff30 = New MYBZ_Market_Share__c();
        MarketShareAff30.Name='TestMarket';
        MarketShareAff30.Market__c = 'Test Market 1';
        MarketShareAff30.Global_Id__c='4';        
        MarketShareAff30.Month__c=3;
        MarketShareAff30.Month_Number__c = '3';
        MarketShareAff30.Year_Number__c = '2015';
        MarketShareAff30.Year__c=2015;        
        MarketShareAff30.Owner__c='LILLY';
        MarketShareAff30.Product__c=IHSProduct1.ID;
        MarketShareAff30.Division__c = Div.id;
        MarketShareAff30.Region__c=Region.id;
        MarketShareAff30.District__c = District.id;           
        MarketShareAff30.Territory__c=null;
        MarketShareAff30.TRx__c=100;
        MarketShareAff30.Previous_Month_TRx__c=80;
        MarketShareAff30.DDD_Dollars__c=null;
        MarketShareAff30.Previous_DDD_Dollars__c=null;
        MarketShareAff30.DDD_Units__c=null;
        MarketShareAff30.Previous_DDD_Units__c=null;
        MarketShareAff30.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff30);
        
        
        MYBZ_Market_Share__c MarketShareAff31 = New MYBZ_Market_Share__c();
        MarketShareAff31.Name='TestMarket';
        MarketShareAff31.Market__c = 'Test Market 1';
        MarketShareAff31.Global_Id__c='4';        
        MarketShareAff31.Month__c=1;
        MarketShareAff31.Month_Number__c = '1';
        MarketShareAff31.Year_Number__c = '2015';
        MarketShareAff31.Year__c=2015;        
        MarketShareAff31.Owner__c='COMPETITOR';
        MarketShareAff31.Product__c=IHSProduct4.ID;
        MarketShareAff31.Division__c = Div.id;
        MarketShareAff31.Region__c=Region.id;
        MarketShareAff31.District__c = District.id;           
        MarketShareAff31.Territory__c=null;
        MarketShareAff31.TRx__c=80;
        MarketShareAff31.Previous_Month_TRx__c=90;
        MarketShareAff31.DDD_Dollars__c=null;
        MarketShareAff31.Previous_DDD_Dollars__c=null;
        MarketShareAff31.DDD_Units__c=null;
        MarketShareAff31.Previous_DDD_Units__c=null;
        MarketShareAff31.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff31);
        
        
        MYBZ_Market_Share__c MarketShareAff32 = New MYBZ_Market_Share__c();
        MarketShareAff32.Name='TestMarket';
        MarketShareAff32.Market__c = 'Test Market 1';
        MarketShareAff32.Global_Id__c='4';        
        MarketShareAff32.Month__c=2;
        MarketShareAff32.Month_Number__c = '2';
        MarketShareAff32.Year_Number__c = '2015';
        MarketShareAff32.Year__c=2015;        
        MarketShareAff32.Owner__c='COMPETITOR';
        MarketShareAff32.Product__c=IHSProduct4.ID;
        MarketShareAff32.Division__c = Div.id;
        MarketShareAff32.Region__c=Region.id;
        MarketShareAff32.District__c = District.id;           
        MarketShareAff32.Territory__c=null;
        MarketShareAff32.TRx__c=100;
        MarketShareAff32.Previous_Month_TRx__c=80;
        MarketShareAff32.DDD_Dollars__c=null;
        MarketShareAff32.Previous_DDD_Dollars__c=null;
        MarketShareAff32.DDD_Units__c=null;
        MarketShareAff32.Previous_DDD_Units__c=null;
        MarketShareAff32.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff32);

		MYBZ_Market_Share__c MarketShareAff33 = New MYBZ_Market_Share__c();
        MarketShareAff33.Name='TestMarket';
        MarketShareAff33.Market__c = 'Test Market 1';
        MarketShareAff33.Global_Id__c='4';        
        MarketShareAff33.Month__c=3;
        MarketShareAff33.Month_Number__c = '3';
        MarketShareAff33.Year_Number__c = '2015';
        MarketShareAff33.Year__c=2015;        
        MarketShareAff33.Owner__c='COMPETITOR';
        MarketShareAff33.Product__c=IHSProduct4.ID;
        MarketShareAff33.Division__c = Div.id;
        MarketShareAff33.Region__c=Region.id;
        MarketShareAff33.District__c = District.id;           
        MarketShareAff33.Territory__c=null;
        MarketShareAff33.TRx__c=100;
        MarketShareAff33.Previous_Month_TRx__c=80;
        MarketShareAff33.DDD_Dollars__c=null;
        MarketShareAff33.Previous_DDD_Dollars__c=null;
        MarketShareAff33.DDD_Units__c=null;
        MarketShareAff33.Previous_DDD_Units__c=null;
        MarketShareAff33.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff33);
        
        MYBZ_Market_Share__c MarketShareAff34 = New MYBZ_Market_Share__c();
        MarketShareAff34.Name='TestMarket';
        MarketShareAff34.Market__c = 'Test Market 2';
        MarketShareAff34.Global_Id__c='4';        
        MarketShareAff34.Month__c=1;
        MarketShareAff34.Month_Number__c = '1';
        MarketShareAff34.Year_Number__c = '2015';
        MarketShareAff34.Year__c=2015;        
        MarketShareAff34.Owner__c='LILLY';
        MarketShareAff34.Product__c=IHSProduct1.ID;
        MarketShareAff34.Division__c = Div.id;
        MarketShareAff34.Region__c=Region.id;
        MarketShareAff34.District__c = District.id;           
        MarketShareAff34.Territory__c=null;
        MarketShareAff34.TRx__c=null;
        MarketShareAff34.Previous_Month_TRx__c=null;
        MarketShareAff34.DDD_Dollars__c=80;
        MarketShareAff34.Previous_DDD_Dollars__c=90;
        MarketShareAff34.DDD_Units__c=80;
        MarketShareAff34.Previous_DDD_Units__c=90;
        MarketShareAff34.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff34);
        
        MYBZ_Market_Share__c MarketShareAff35 = New MYBZ_Market_Share__c();
        MarketShareAff35.Name='TestMarket';
        MarketShareAff35.Market__c = 'Test Market 2';
        MarketShareAff35.Global_Id__c='4';        
        MarketShareAff35.Month__c=2;
        MarketShareAff35.Month_Number__c = '2';
        MarketShareAff35.Year_Number__c = '2015';
        MarketShareAff35.Year__c=2015;        
        MarketShareAff35.Owner__c='LILLY';
        MarketShareAff35.Product__c=IHSProduct1.ID;
        MarketShareAff35.Division__c = Div.id;
        MarketShareAff35.Region__c=Region.id;
        MarketShareAff35.District__c = District.id;           
        MarketShareAff35.Territory__c=null;
        MarketShareAff35.TRx__c=null;
        MarketShareAff35.Previous_Month_TRx__c=null;
        MarketShareAff35.DDD_Dollars__c=100;
        MarketShareAff35.Previous_DDD_Dollars__c=80;
        MarketShareAff35.DDD_Units__c=100;
        MarketShareAff35.Previous_DDD_Units__c=80;
        MarketShareAff35.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff35);

		MYBZ_Market_Share__c MarketShareAff36 = New MYBZ_Market_Share__c();
        MarketShareAff36.Name='TestMarket';
        MarketShareAff36.Market__c = 'Test Market 2';
        MarketShareAff36.Global_Id__c='4';        
        MarketShareAff36.Month__c=3;
        MarketShareAff36.Month_Number__c = '3';
        MarketShareAff36.Year_Number__c = '2015';
        MarketShareAff36.Year__c=2015;        
        MarketShareAff36.Owner__c='LILLY';
        MarketShareAff36.Product__c=IHSProduct1.ID;
        MarketShareAff36.Division__c = Div.id;
        MarketShareAff36.Region__c=Region.id;
        MarketShareAff36.District__c = District.id;           
        MarketShareAff36.Territory__c=null;
        MarketShareAff36.TRx__c=null;
        MarketShareAff36.Previous_Month_TRx__c=null;
        MarketShareAff36.DDD_Dollars__c=100;
        MarketShareAff36.Previous_DDD_Dollars__c=90;
        MarketShareAff36.DDD_Units__c=100;
        MarketShareAff36.Previous_DDD_Units__c=90;
        MarketShareAff36.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAff36);
        
        // Affliation System data
        
         MYBZ_Market_Share__c MarketShareAffSys1 = New MYBZ_Market_Share__c();
        MarketShareAffSys1.Name='TestMarket';
        MarketShareAffSys1.Market__c = 'Test Market 1';
        MarketShareAffSys1.Global_Id__c='1';        
        MarketShareAffSys1.Month__c=1;
        MarketShareAffSys1.Month_Number__c = '1';
        MarketShareAffSys1.Year_Number__c = '2015';
        MarketShareAffSys1.Year__c=2015;        
        MarketShareAffSys1.Owner__c='LILLY';
        MarketShareAffSys1.Product__c=IHSProduct1.ID;
        MarketShareAffSys1.Division__c = null;
        MarketShareAffSys1.Region__c=null;
        MarketShareAffSys1.District__c = null;           
        MarketShareAffSys1.Territory__c=null;
        MarketShareAffSys1.TRx__c=80;
        MarketShareAffSys1.Previous_Month_TRx__c=90;
        MarketShareAffSys1.DDD_Dollars__c=null;
        MarketShareAffSys1.Previous_DDD_Dollars__c=null;
        MarketShareAffSys1.DDD_Units__c=null;
        MarketShareAffSys1.Previous_DDD_Units__c=null;
		MarketShareAffSys1.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys1.System__c = objSystem.id;
        MarketShareAffSys1.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys1);
        
        
        MYBZ_Market_Share__c MarketShareAffSys2 = New MYBZ_Market_Share__c();
        MarketShareAffSys2.Name='TestMarket';
        MarketShareAffSys2.Market__c = 'Test Market 1';
        MarketShareAffSys2.Global_Id__c='1';        
        MarketShareAffSys2.Month__c=2;
        MarketShareAffSys2.Month_Number__c = '2';
        MarketShareAffSys2.Year_Number__c = '2015';
        MarketShareAffSys2.Year__c=2015;        
        MarketShareAffSys2.Owner__c='LILLY';
        MarketShareAffSys2.Product__c=IHSProduct1.ID;
        MarketShareAffSys2.Division__c = null;
        MarketShareAffSys2.Region__c=null;
        MarketShareAffSys2.District__c = null;           
        MarketShareAffSys2.Territory__c=null;
        MarketShareAffSys2.TRx__c=100;
        MarketShareAffSys2.Previous_Month_TRx__c=80;
        MarketShareAffSys2.DDD_Dollars__c=null;
        MarketShareAffSys2.Previous_DDD_Dollars__c=null;
        MarketShareAffSys2.DDD_Units__c=null;
        MarketShareAffSys2.Previous_DDD_Units__c=null;
		MarketShareAffSys2.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys2.System__c = objSystem.id;
        MarketShareAffSys2.LoadIdentifier__c = 'AFFLTN';        
        MarketShareList.add(MarketShareAffSys2);

		MYBZ_Market_Share__c MarketShareAffSys3 = New MYBZ_Market_Share__c();
        MarketShareAffSys3.Name='TestMarket';
        MarketShareAffSys3.Market__c = 'Test Market 1';
        MarketShareAffSys3.Global_Id__c='1';        
        MarketShareAffSys3.Month__c=3;
        MarketShareAffSys3.Month_Number__c = '3';
        MarketShareAffSys3.Year_Number__c = '2015';
        MarketShareAffSys3.Year__c=2015;        
        MarketShareAffSys3.Owner__c='LILLY';
        MarketShareAffSys3.Product__c=IHSProduct1.ID;
        MarketShareAffSys3.Division__c = null;
        MarketShareAffSys3.Region__c=null;
        MarketShareAffSys3.District__c = null;           
        MarketShareAffSys3.Territory__c=null;
        MarketShareAffSys3.TRx__c=100;
        MarketShareAffSys3.Previous_Month_TRx__c=80;
        MarketShareAffSys3.DDD_Dollars__c=null;
        MarketShareAffSys3.Previous_DDD_Dollars__c=null;
        MarketShareAffSys3.DDD_Units__c=null;
        MarketShareAffSys3.Previous_DDD_Units__c=null;
		MarketShareAffSys3.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys3.System__c = objSystem.id;        
        MarketShareAffSys3.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys3);
		
		MYBZ_Market_Share__c MarketShareAffSys4 = New MYBZ_Market_Share__c();
        MarketShareAffSys4.Name='TestMarket';
        MarketShareAffSys4.Market__c = 'Test Market 1';
        MarketShareAffSys4.Global_Id__c='1';        
        MarketShareAffSys4.Month__c=1;
        MarketShareAffSys4.Month_Number__c = '1';
        MarketShareAffSys4.Year_Number__c = '2015';
        MarketShareAffSys4.Year__c=2015;        
        MarketShareAffSys4.Owner__c='COMPETITOR';
        MarketShareAffSys4.Product__c=IHSProduct4.ID;
        MarketShareAffSys4.Division__c = null;
        MarketShareAffSys4.Region__c=null;
        MarketShareAffSys4.District__c = null;           
        MarketShareAffSys4.Territory__c=null;
        MarketShareAffSys4.TRx__c=80;
        MarketShareAffSys4.Previous_Month_TRx__c=90;
        MarketShareAffSys4.DDD_Dollars__c=null;
        MarketShareAffSys4.Previous_DDD_Dollars__c=null;
        MarketShareAffSys4.DDD_Units__c=null;
        MarketShareAffSys4.Previous_DDD_Units__c=null;
		MarketShareAffSys4.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys4.System__c = objSystem.id;        
        MarketShareAffSys4.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys4);
        
        
        MYBZ_Market_Share__c MarketShareAffSys5 = New MYBZ_Market_Share__c();
        MarketShareAffSys5.Name='TestMarket';
        MarketShareAffSys5.Market__c = 'Test Market 1';
        MarketShareAffSys5.Global_Id__c='1';        
        MarketShareAffSys5.Month__c=2;
        MarketShareAffSys5.Month_Number__c = '2';
        MarketShareAffSys5.Year_Number__c = '2015';
        MarketShareAffSys5.Year__c=2015;        
        MarketShareAffSys5.Owner__c='COMPETITOR';
        MarketShareAffSys5.Product__c=IHSProduct4.ID;
        MarketShareAffSys5.Division__c = null;
        MarketShareAffSys5.Region__c=null;
        MarketShareAffSys5.District__c = null;           
        MarketShareAffSys5.Territory__c=null;
        MarketShareAffSys5.TRx__c=100;
        MarketShareAffSys5.Previous_Month_TRx__c=80;
        MarketShareAffSys5.DDD_Dollars__c=null;
        MarketShareAffSys5.Previous_DDD_Dollars__c=null;
        MarketShareAffSys5.DDD_Units__c=null;
        MarketShareAffSys5.Previous_DDD_Units__c=null;
		MarketShareAffSys5.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys5.System__c = objSystem.id;        
        MarketShareAffSys5.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys5);

		MYBZ_Market_Share__c MarketShareAffSys6 = New MYBZ_Market_Share__c();
        MarketShareAffSys6.Name='TestMarket';
        MarketShareAffSys6.Market__c = 'Test Market 1';
        MarketShareAffSys6.Global_Id__c='1';        
        MarketShareAffSys6.Month__c=3;
        MarketShareAffSys6.Month_Number__c = '3';
        MarketShareAffSys6.Year_Number__c = '2015';
        MarketShareAffSys6.Year__c=2015;        
        MarketShareAffSys6.Owner__c='COMPETITOR';
        MarketShareAffSys6.Product__c=IHSProduct4.ID;
        MarketShareAffSys6.Division__c = null;
        MarketShareAffSys6.Region__c=null;
        MarketShareAffSys6.District__c = null;           
        MarketShareAffSys6.Territory__c=null;
        MarketShareAffSys6.TRx__c=100;
        MarketShareAffSys6.Previous_Month_TRx__c=80;
        MarketShareAffSys6.DDD_Dollars__c=null;
        MarketShareAffSys6.Previous_DDD_Dollars__c=null;
        MarketShareAffSys6.DDD_Units__c=null;
        MarketShareAffSys6.Previous_DDD_Units__c=null;
		MarketShareAffSys6.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys6.System__c = objSystem.id;  
        MarketShareAffSys6.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys6);
        
        MYBZ_Market_Share__c MarketShareAffSys7 = New MYBZ_Market_Share__c();
        MarketShareAffSys7.Name='TestMarket';
        MarketShareAffSys7.Market__c = 'Test Market 2';
        MarketShareAffSys7.Global_Id__c='18785';        
        MarketShareAffSys7.Month__c=1;
        MarketShareAffSys7.Month_Number__c = '1';
        MarketShareAffSys7.Year_Number__c = '2015';
        MarketShareAffSys7.Year__c=2015;        
        MarketShareAffSys7.Owner__c='LILLY';
        MarketShareAffSys7.Product__c=IHSProduct1.ID;
        MarketShareAffSys7.Division__c = null;
        MarketShareAffSys7.Region__c=null;
        MarketShareAffSys7.District__c = null;           
        MarketShareAffSys7.Territory__c=null;
        MarketShareAffSys7.TRx__c=null;
        MarketShareAffSys7.Previous_Month_TRx__c=null;
        MarketShareAffSys7.DDD_Dollars__c=80;
        MarketShareAffSys7.Previous_DDD_Dollars__c=90;
        MarketShareAffSys7.DDD_Units__c=80;
        MarketShareAffSys7.Previous_DDD_Units__c=90;
		MarketShareAffSys7.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys7.System__c = objSystem.id;  
        MarketShareAffSys7.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys7);
        
        
        MYBZ_Market_Share__c MarketShareAffSys8 = New MYBZ_Market_Share__c();
        MarketShareAffSys8.Name='TestMarket';
        MarketShareAffSys8.Market__c = 'Test Market 2';
        MarketShareAffSys8.Global_Id__c='1';        
        MarketShareAffSys8.Month__c=2;
        MarketShareAffSys8.Month_Number__c = '2';
        MarketShareAffSys8.Year_Number__c = '2015';
        MarketShareAffSys8.Year__c=2015;        
        MarketShareAffSys8.Owner__c='LILLY';
        MarketShareAffSys8.Product__c=IHSProduct1.ID;
        MarketShareAffSys8.Division__c = null;
        MarketShareAffSys8.Region__c=null;
        MarketShareAffSys8.District__c = null;           
        MarketShareAffSys8.Territory__c=null;
        MarketShareAffSys8.TRx__c=null;
        MarketShareAffSys8.Previous_Month_TRx__c=null;
        MarketShareAffSys8.DDD_Dollars__c=100;
        MarketShareAffSys8.Previous_DDD_Dollars__c=80;
        MarketShareAffSys8.DDD_Units__c=100;
        MarketShareAffSys8.Previous_DDD_Units__c=80;
		MarketShareAffSys8.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys8.System__c = objSystem.id;
        MarketShareAffSys8.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys8);

		MYBZ_Market_Share__c MarketShareAffSys9 = New MYBZ_Market_Share__c();
        MarketShareAffSys9.Name='TestMarket';
        MarketShareAffSys9.Market__c = 'Test Market 2';
        MarketShareAffSys9.Global_Id__c='1';        
        MarketShareAffSys9.Month__c=3;
        MarketShareAffSys9.Month_Number__c = '3';
        MarketShareAffSys9.Year_Number__c = '2015';
        MarketShareAffSys9.Year__c=2015;        
        MarketShareAffSys9.Owner__c='LILLY';
        MarketShareAffSys9.Product__c=IHSProduct1.ID;
        MarketShareAffSys9.Division__c = null;
        MarketShareAffSys9.Region__c=null;
        MarketShareAffSys9.District__c = null;           
        MarketShareAffSys9.Territory__c=null;
        MarketShareAffSys9.TRx__c=null;
        MarketShareAffSys9.Previous_Month_TRx__c=null;
        MarketShareAffSys9.DDD_Dollars__c=100;
        MarketShareAffSys9.Previous_DDD_Dollars__c=90;
        MarketShareAffSys9.DDD_Units__c=100;
        MarketShareAffSys9.Previous_DDD_Units__c=90;
		MarketShareAffSys9.LE_ID_IHS__c = 'XYZ';
		MarketShareAffSys9.System__c = objSystem.id;
        MarketShareAffSys9.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffSys9);
        
        
        // Affliation PGP 
        
         MYBZ_Market_Share__c MarketShareAffPGP1 = New MYBZ_Market_Share__c();
        MarketShareAffPGP1.Name='TestMarket';
        MarketShareAffPGP1.Market__c = 'Test Market 1';
        MarketShareAffPGP1.Global_Id__c='1';        
        MarketShareAffPGP1.Month__c=1;
        MarketShareAffPGP1.Month_Number__c = '1';
        MarketShareAffPGP1.Year_Number__c = '2015';
        MarketShareAffPGP1.Year__c=2015;        
        MarketShareAffPGP1.Owner__c='LILLY';
        MarketShareAffPGP1.Product__c=IHSProduct1.ID;
        MarketShareAffPGP1.Division__c = null;
        MarketShareAffPGP1.Region__c=null;
        MarketShareAffPGP1.District__c = null;           
        MarketShareAffPGP1.Territory__c=null;
        MarketShareAffPGP1.TRx__c=80;
        MarketShareAffPGP1.Previous_Month_TRx__c=90;
        MarketShareAffPGP1.DDD_Dollars__c=null;
        MarketShareAffPGP1.Previous_DDD_Dollars__c=null;
        MarketShareAffPGP1.DDD_Units__c=null;
        MarketShareAffPGP1.Previous_DDD_Units__c=null;
		MarketShareAffPGP1.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP1.System__c = objSystem.id;
		MarketShareAffPGP1.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP1.PGP__c	= PGP.id;		
        MarketShareAffPGP1.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP1);
        
        
        MYBZ_Market_Share__c MarketShareAffPGP2 = New MYBZ_Market_Share__c();
        MarketShareAffPGP2.Name='TestMarket';
        MarketShareAffPGP2.Market__c = 'Test Market 1';
        MarketShareAffPGP2.Global_Id__c='1';        
        MarketShareAffPGP2.Month__c=2;
        MarketShareAffPGP2.Month_Number__c = '2';
        MarketShareAffPGP2.Year_Number__c = '2015';
        MarketShareAffPGP2.Year__c=2015;        
        MarketShareAffPGP2.Owner__c='LILLY';
        MarketShareAffPGP2.Product__c=IHSProduct1.ID;
        MarketShareAffPGP2.Division__c = null;
        MarketShareAffPGP2.Region__c=null;
        MarketShareAffPGP2.District__c = null;           
        MarketShareAffPGP2.Territory__c=null;
        MarketShareAffPGP2.TRx__c=100;
        MarketShareAffPGP2.Previous_Month_TRx__c=80;
        MarketShareAffPGP2.DDD_Dollars__c=null;
        MarketShareAffPGP2.Previous_DDD_Dollars__c=null;
        MarketShareAffPGP2.DDD_Units__c=null;
        MarketShareAffPGP2.Previous_DDD_Units__c=null;
		MarketShareAffPGP2.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP2.System__c = objSystem.id;
		MarketShareAffPGP2.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP2.PGP__c	= PGP.id;	
        MarketShareAffPGP2.LoadIdentifier__c = 'AFFLTN';        
        MarketShareList.add(MarketShareAffPGP2);

		MYBZ_Market_Share__c MarketShareAffPGP3 = New MYBZ_Market_Share__c();
        MarketShareAffPGP3.Name='TestMarket';
        MarketShareAffPGP3.Market__c = 'Test Market 1';
        MarketShareAffPGP3.Global_Id__c='1';        
        MarketShareAffPGP3.Month__c=3;
        MarketShareAffPGP3.Month_Number__c = '3';
        MarketShareAffPGP3.Year_Number__c = '2015';
        MarketShareAffPGP3.Year__c=2015;        
        MarketShareAffPGP3.Owner__c='LILLY';
        MarketShareAffPGP3.Product__c=IHSProduct1.ID;
        MarketShareAffPGP3.Division__c = null;
        MarketShareAffPGP3.Region__c=null;
        MarketShareAffPGP3.District__c = null;           
        MarketShareAffPGP3.Territory__c=null;
        MarketShareAffPGP3.TRx__c=100;
        MarketShareAffPGP3.Previous_Month_TRx__c=80;
        MarketShareAffPGP3.DDD_Dollars__c=null;
        MarketShareAffPGP3.Previous_DDD_Dollars__c=null;
        MarketShareAffPGP3.DDD_Units__c=null;
        MarketShareAffPGP3.Previous_DDD_Units__c=null;
		MarketShareAffPGP3.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP3.System__c = objSystem.id;   
		MarketShareAffPGP3.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP3.PGP__c	= PGP.id;	
        MarketShareAffPGP3.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP3);
		
		MYBZ_Market_Share__c MarketShareAffPGP4 = New MYBZ_Market_Share__c();
        MarketShareAffPGP4.Name='TestMarket';
        MarketShareAffPGP4.Market__c = 'Test Market 1';
        MarketShareAffPGP4.Global_Id__c='1';        
        MarketShareAffPGP4.Month__c=1;
        MarketShareAffPGP4.Month_Number__c = '1';
        MarketShareAffPGP4.Year_Number__c = '2015';
        MarketShareAffPGP4.Year__c=2015;        
        MarketShareAffPGP4.Owner__c='COMPETITOR';
        MarketShareAffPGP4.Product__c=IHSProduct4.ID;
        MarketShareAffPGP4.Division__c = null;
        MarketShareAffPGP4.Region__c=null;
        MarketShareAffPGP4.District__c = null;           
        MarketShareAffPGP4.Territory__c=null;
        MarketShareAffPGP4.TRx__c=80;
        MarketShareAffPGP4.Previous_Month_TRx__c=90;
        MarketShareAffPGP4.DDD_Dollars__c=null;
        MarketShareAffPGP4.Previous_DDD_Dollars__c=null;
        MarketShareAffPGP4.DDD_Units__c=null;
        MarketShareAffPGP4.Previous_DDD_Units__c=null;
		MarketShareAffPGP4.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP4.System__c = objSystem.id;   
	    MarketShareAffPGP4.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP4.PGP__c	= PGP.id;	
        MarketShareAffPGP4.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP4);
        
        
        MYBZ_Market_Share__c MarketShareAffPGP5 = New MYBZ_Market_Share__c();
        MarketShareAffPGP5.Name='TestMarket';
        MarketShareAffPGP5.Market__c = 'Test Market 1';
        MarketShareAffPGP5.Global_Id__c='1';        
        MarketShareAffPGP5.Month__c=2;
        MarketShareAffPGP5.Month_Number__c = '2';
        MarketShareAffPGP5.Year_Number__c = '2015';
        MarketShareAffPGP5.Year__c=2015;        
        MarketShareAffPGP5.Owner__c='COMPETITOR';
        MarketShareAffPGP5.Product__c=IHSProduct4.ID;
        MarketShareAffPGP5.Division__c = null;
        MarketShareAffPGP5.Region__c=null;
        MarketShareAffPGP5.District__c = null;           
        MarketShareAffPGP5.Territory__c=null;
        MarketShareAffPGP5.TRx__c=100;
        MarketShareAffPGP5.Previous_Month_TRx__c=80;
        MarketShareAffPGP5.DDD_Dollars__c=null;
        MarketShareAffPGP5.Previous_DDD_Dollars__c=null;
        MarketShareAffPGP5.DDD_Units__c=null;
        MarketShareAffPGP5.Previous_DDD_Units__c=null;
		MarketShareAffPGP5.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP5.System__c = objSystem.id;
		MarketShareAffPGP5.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP5.PGP__c	= PGP.id;	
        MarketShareAffPGP5.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP5);

		MYBZ_Market_Share__c MarketShareAffPGP6 = New MYBZ_Market_Share__c();
        MarketShareAffPGP6.Name='TestMarket';
        MarketShareAffPGP6.Market__c = 'Test Market 1';
        MarketShareAffPGP6.Global_Id__c='1';        
        MarketShareAffPGP6.Month__c=3;
        MarketShareAffPGP6.Month_Number__c = '3';
        MarketShareAffPGP6.Year_Number__c = '2015';
        MarketShareAffPGP6.Year__c=2015;        
        MarketShareAffPGP6.Owner__c='COMPETITOR';
        MarketShareAffPGP6.Product__c=IHSProduct4.ID;
        MarketShareAffPGP6.Division__c = null;
        MarketShareAffPGP6.Region__c=null;
        MarketShareAffPGP6.District__c = null;           
        MarketShareAffPGP6.Territory__c=null;
        MarketShareAffPGP6.TRx__c=100;
        MarketShareAffPGP6.Previous_Month_TRx__c=80;
        MarketShareAffPGP6.DDD_Dollars__c=null;
        MarketShareAffPGP6.Previous_DDD_Dollars__c=null;
        MarketShareAffPGP6.DDD_Units__c=null;
        MarketShareAffPGP6.Previous_DDD_Units__c=null;
		MarketShareAffPGP6.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP6.System__c = objSystem.id;  
		MarketShareAffPGP6.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP6.PGP__c	= PGP.id;	
        MarketShareAffPGP6.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP6);
        
        MYBZ_Market_Share__c MarketShareAffPGP7 = New MYBZ_Market_Share__c();
        MarketShareAffPGP7.Name='TestMarket';
        MarketShareAffPGP7.Market__c = 'Test Market 2';
        MarketShareAffPGP7.Global_Id__c='18785';        
        MarketShareAffPGP7.Month__c=1;
        MarketShareAffPGP7.Month_Number__c = '1';
        MarketShareAffPGP7.Year_Number__c = '2015';
        MarketShareAffPGP7.Year__c=2015;        
        MarketShareAffPGP7.Owner__c='LILLY';
        MarketShareAffPGP7.Product__c=IHSProduct1.ID;
        MarketShareAffPGP7.Division__c = null;
        MarketShareAffPGP7.Region__c=null;
        MarketShareAffPGP7.District__c = null;           
        MarketShareAffPGP7.Territory__c=null;
        MarketShareAffPGP7.TRx__c=null;
        MarketShareAffPGP7.Previous_Month_TRx__c=null;
        MarketShareAffPGP7.DDD_Dollars__c=80;
        MarketShareAffPGP7.Previous_DDD_Dollars__c=90;
        MarketShareAffPGP7.DDD_Units__c=80;
        MarketShareAffPGP7.Previous_DDD_Units__c=90;
		MarketShareAffPGP7.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP7.System__c = objSystem.id;  
		MarketShareAffPGP7.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP7.PGP__c	= PGP.id;	
        MarketShareAffPGP7.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP7);
        
        
        MYBZ_Market_Share__c MarketShareAffPGP8 = New MYBZ_Market_Share__c();
        MarketShareAffPGP8.Name='TestMarket';
        MarketShareAffPGP8.Market__c = 'Test Market 2';
        MarketShareAffPGP8.Global_Id__c='1';        
        MarketShareAffPGP8.Month__c=2;
        MarketShareAffPGP8.Month_Number__c = '2';
        MarketShareAffPGP8.Year_Number__c = '2015';
        MarketShareAffPGP8.Year__c=2015;        
        MarketShareAffPGP8.Owner__c='LILLY';
        MarketShareAffPGP8.Product__c=IHSProduct1.ID;
        MarketShareAffPGP8.Division__c = null;
        MarketShareAffPGP8.Region__c=null;
        MarketShareAffPGP8.District__c = null;           
        MarketShareAffPGP8.Territory__c=null;
        MarketShareAffPGP8.TRx__c=null;
        MarketShareAffPGP8.Previous_Month_TRx__c=null;
        MarketShareAffPGP8.DDD_Dollars__c=100;
        MarketShareAffPGP8.Previous_DDD_Dollars__c=80;
        MarketShareAffPGP8.DDD_Units__c=100;
        MarketShareAffPGP8.Previous_DDD_Units__c=80;
		MarketShareAffPGP8.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP8.System__c = objSystem.id;
		MarketShareAffPGP8.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP8.PGP__c	= PGP.id;	
        MarketShareAffPGP8.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP8);

		MYBZ_Market_Share__c MarketShareAffPGP9 = New MYBZ_Market_Share__c();
        MarketShareAffPGP9.Name='TestMarket';
        MarketShareAffPGP9.Market__c = 'Test Market 2';
        MarketShareAffPGP9.Global_Id__c='1';        
        MarketShareAffPGP9.Month__c=3;
        MarketShareAffPGP9.Month_Number__c = '3';
        MarketShareAffPGP9.Year_Number__c = '2015';
        MarketShareAffPGP9.Year__c=2015;        
        MarketShareAffPGP9.Owner__c='LILLY';
        MarketShareAffPGP9.Product__c=IHSProduct1.ID;
        MarketShareAffPGP9.Division__c = null;
        MarketShareAffPGP9.Region__c=null;
        MarketShareAffPGP9.District__c = null;           
        MarketShareAffPGP9.Territory__c=null;
        MarketShareAffPGP9.TRx__c=null;
        MarketShareAffPGP9.Previous_Month_TRx__c=null;
        MarketShareAffPGP9.DDD_Dollars__c=100;
        MarketShareAffPGP9.Previous_DDD_Dollars__c=90;
        MarketShareAffPGP9.DDD_Units__c=100;
        MarketShareAffPGP9.Previous_DDD_Units__c=90;
		MarketShareAffPGP9.LE_ID_IHS__c = 'XYZ';
		MarketShareAffPGP9.System__c = objSystem.id;
		MarketShareAffPGP9.LE_ID_PGP__c = 'ABC';		
		MarketShareAffPGP9.PGP__c	= PGP.id;	
        MarketShareAffPGP9.LoadIdentifier__c = 'AFFLTN';
        MarketShareList.add(MarketShareAffPGP9);       
        
        
        insert MarketShareList;
		
		
        
    }
    
    /*
    * @Method Name                    :  testAsSalesRepAlignment
    * @Description                    :  method to test as Sales Representative(Role) generation of JSONS for MarketShare Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSalesRepAlignment() {
        String jsonrespasString;
        User runAsUser = createUserToRun(System.Label.MYBZ_SalesRepresentative, '4');  
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
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPicker('XYZ', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPicker('', 'ABC');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));                
                
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
        User runAsUser = createUserToRun(System.Label.MYBZ_DistrictSalesManager, '3');  
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        }
        System.runas(runAsUser){ 
            Test.startTest();
            
            
             	Obj=MYBZ_MarketShare.marketShareControllerNonAff();
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));          
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));                     
                
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
        User runAsUser = createUserToRun(System.Label.MYBZ_AccountManager, '3');  
         // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        }
        System.runas(runAsUser){ 
            
            Test.startTest();
            	Obj=MYBZ_MarketShare.marketShareControllerNonAff();
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));          
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));                     
                
                Obj = MYBZ_MarketShare.accountSummary();
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                System.debug('@@@'+jsonrespasString);
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));     
                
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
        User runAsUser = createUserToRun(System.Label.MYBZ_MajorMarketManager, '2');  
        
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        }
        System.runas(runAsUser){ 
            
            Test.startTest();
            	Obj=MYBZ_MarketShare.marketShareControllerNonAff();
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(Region.Name,'', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '',Region.Name,'', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC',Region.Name,'', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));          
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));          
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));                     
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
        User runAsUser = createUserToRun(System.Label.MYBZ_SuperUser, '');
         
        // Insertion of Test Data
        User runAsUserDataLoad = createUser(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
            insertTestMarketShareData();
        } 
        
        System.runas(runAsUser){ 
            
            Test.startTest();
            	            	Obj=MYBZ_MarketShare.marketShareControllerNonAff();
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker(Region.Name,'', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));
                
                Obj=MYBZ_MarketShare.marketshareControllerNonAffUsingPicker('', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '',Region.Name,'', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC',Region.Name,'', '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));          
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','', District.Name, '');
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));          
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('XYZ', '','', '', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));       
                
                Obj=MYBZ_MarketShare.marketshareControllerAffUsingPickerSuperUser('', 'ABC','','', Territory.Name);
                system.assert(Obj!=null);
                jsonrespasString = Obj+'';
                system.assert(jsonrespasString.contains('Test Market 1'));
                system.assert(jsonrespasString.contains('Test Market 2'));
                system.assert(jsonrespasString.contains('LILLY Product 1'));
                system.assert(jsonrespasString.contains('COMPETITOR Product 4'));  
                
          	Test.stopTest();
        }
            
     }
}