/*
*@ Class Name                                                    : Test_MYBZ_Region_Rollup_Controller
*@ Description                                                   : Test Class for MYBZ_RR_Controller_Dev_Update
*@ CreatedBy                                                     : 
*@ CreatedOn                                                     : 
*@ Modification Log                                              : 18 Feb 2014 made changes to test class to include actual ddd units in target goal report calculations
*/

@isTest(SeeAllData=false)
public class Test_MYBZ_RegionRollup_Controller{
    
    /*
* @Method Name                    :  createUser
* @Description                    :  method to create User of certain Role                                  
* @Return Type                    :  User
* @Param                          :      
*/
    public static User createUser(String Role){
        Profile pfl = [select id from profile where name='GSO Basic User_Platform'];
        //Declaring the User
        User runAsUser = new User(alias = 'BasicIHS', email='appBasicIhs@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c='114017',MYBZ_Reporting_ID__c='114017');
        
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
    public static User createUserDataLoad(String Role){
        Profile pfl = [select id from profile where name='System Administrator'];
        //Declaring the User
        User runAsUser = new User(alias = 'BasicIHS', email='appBasicIhs@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c='114017',MYBZ_Reporting_ID__c='114017');
        
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
    static MYBZ_Region__c Region = New MYBZ_Region__c();
    static MYBZ_Region__c Region1 = New MYBZ_Region__c();
    static MYBZ_District__c District = New MYBZ_District__c();
    static MYBZ_District__c District1 = New MYBZ_District__c();
    static MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory2 = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory3 = New MYBZ_Territory__c();
    static Object Obj;
    
    /*
* @Method Name                    :  insertTestData
* @Description                    :  method to create Test Data of product, Division, Territory, district, calls, Call Planning
Market share, Product Trends etc.                                                                     
* @Return Type                    :  void
* @Param                          :      
*/
    static void insertTestData() {
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
        Div.Name=System.Label.MYBZ_IHSDivision;
        Insert Div;  
        system.assert(Div.id!=null);
        
        Region.Name='TestRegion';
        Region.Parent__c=Div.ID;
        Insert Region;
        system.assert(Region.id!=null);
        
        Region1.Name=' Test PAC NW';
        Region1.Parent__c=Div.ID;
        Insert Region1;
        system.assert(Region1.id!=null);
        
        
        District.Name='TestDistrict';
        District.Region__c=Region.ID;
        Insert District;
        system.assert(District.id!=null);
        
        District1.Name='TestDistrict';
        District1.Region__c=Region1.ID;
        Insert District1;
        system.assert(District1.id!=null);
        
        Territory.Name='TestTerritory';
        Territory.State__c = District.id;
        Insert Territory;
        system.assert(Territory.id!=null);
        
        Territory2.Name='TestTerritory2';
        Territory2.State__c = District.id;
        Insert Territory2;
        system.assert(Territory2.id!=null);
        
        Territory3.Name='TestTerritory3';
        Territory3.State__c = District1.id;
        Insert Territory3;
        system.assert(Territory3.id!=null);
        
        MYBZ_Market_Share__c MarketShare = New MYBZ_Market_Share__c();
        MarketShare.Name='TestMarket';
        MarketShare.Global_Id__c='114017';
        MarketShare.Market__c='test';
        MarketShare.Month__c=1;
        MarketShare.Owner__c='LILLY';
        MarketShare.Previous_Month_TRx__c=1;
        MarketShare.Product__c=IHSProduct.ID;
        MarketShare.Region__c=Region.ID;
        MarketShare.Territory__c=Territory.ID;
        MarketShare.TRx__c=1;
        MarketShare.DDD_Dollars__c=1;
        MarketShare.Previous_DDD_Dollars__c=1;
        MarketShare.DDD_Units__c=1;
        MarketShare.Previous_DDD_Units__c=1;
        MarketShare.Year__c=2015;
        Insert MarketShare;
        system.assert(MarketShare.id!=null);
        
        MYBZ_Market_Share__c MarketShare1 = New MYBZ_Market_Share__c();
        MarketShare1.Name='TestMarket';
        MarketShare1.Global_Id__c='114017';
        MarketShare1.Market__c='test';
        MarketShare1.Month__c=1;
        MarketShare1.Owner__c='LILLY';
        MarketShare1.Previous_Month_TRx__c=1;
        MarketShare1.Product__c=IHSProduct2.ID;
        MarketShare1.Region__c=Region.ID;
        MarketShare1.Territory__c=Territory.ID;
        MarketShare1.TRx__c=1;
        MarketShare1.DDD_Dollars__c=1;
        MarketShare1.Previous_DDD_Dollars__c=1;
        MarketShare1.DDD_Units__c=1;
        MarketShare1.Previous_DDD_Units__c=1;
        MarketShare1.Year__c=2015;
        Insert MarketShare1;
        system.assert(MarketShare1.id!=null);
        
        MYBZ_Market_Share__c MarketShare2 = New MYBZ_Market_Share__c();
        MarketShare2.Name='TestMarket';
        MarketShare2.Global_Id__c='yyyyy';
        MarketShare2.Market__c='test';
        MarketShare2.Month__c=1;
        MarketShare2.Owner__c='COMPETITOR';
        MarketShare2.Previous_Month_TRx__c=1;
        MarketShare2.Product__c=IHSProduct2.ID;
        MarketShare2.Region__c=Region.ID;
        MarketShare2.Territory__c=Territory2.ID;
        MarketShare2.Year__c=2015;
        Insert MarketShare2;
        system.assert(MarketShare2.id!=null); 
        
        MYBZ_Market_Share__c MarketShare3 = New MYBZ_Market_Share__c();
        MarketShare3.Name='TestMarket';
        MarketShare3.Global_Id__c='114017';
        MarketShare3.Market__c='test';
        MarketShare3.Month__c=2;
        MarketShare3.Owner__c='LILLY';
        MarketShare3.Product__c=IHSProduct.ID;
        MarketShare3.Region__c=Region.ID;
        MarketShare3.Territory__c=Territory.ID;
        MarketShare3.Year__c=2015;
        Insert MarketShare3;
        system.assert(MarketShare3.id!=null);       
        
        MYBZ_Market_Share__c MarketShare4 = New MYBZ_Market_Share__c();
        MarketShare4.Name='TestMarket';
        MarketShare4.Global_Id__c='114017';
        MarketShare4.Market__c='test';
        MarketShare4.Month__c=2;
        MarketShare4.Owner__c='LILLY';
        MarketShare4.Product__c=IHSProduct2.ID;
        MarketShare4.Region__c=Region.ID;
        MarketShare4.Territory__c=Territory.ID;
        MarketShare4.Year__c=2015;
        Insert MarketShare4;
        system.assert(MarketShare4.id!=null); 
        
        MYBZ_Market_Share__c MarketShare5 = New MYBZ_Market_Share__c();
        MarketShare5.Name='TestMarket';
        MarketShare5.Global_Id__c='114017';
        MarketShare5.Market__c='test';
        MarketShare5.Month__c=3;
        MarketShare5.Owner__c='LILLY';
        MarketShare5.Previous_Month_TRx__c=0;
        MarketShare5.Product__c=IHSProduct.ID;
        MarketShare5.Region__c=Region.ID;
        MarketShare5.Territory__c=Territory.ID;
        MarketShare5.TRx__c=10;
        MarketShare5.DDD_Dollars__c=10;
        MarketShare5.Previous_DDD_Dollars__c=0;
        MarketShare5.DDD_Units__c=10;
        MarketShare5.Previous_DDD_Units__c=0;
        MarketShare5.Year__c=2014;
        Insert MarketShare5;
        system.assert(MarketShare5.id!=null);
        
        MYBZ_Market_Share__c MarketShare6 = New MYBZ_Market_Share__c();
        MarketShare6.Name='TestMarket';
        MarketShare6.Global_Id__c='114017';
        MarketShare6.Market__c='test';
        MarketShare6.Month__c=1;
        MarketShare6.Owner__c='LILLY';
        MarketShare6.Product__c=IHSProduct.ID;
        MarketShare6.Region__c=Region.ID;
        MarketShare6.Territory__c=Territory.ID;
        MarketShare6.Year__c=2014;
        Insert MarketShare6;
        system.assert(MarketShare6.id!=null);
        
        MYBZ_Market_Share__c MarketShare7 = New MYBZ_Market_Share__c();
        MarketShare7.Name='TestMarket';
        MarketShare7.Global_Id__c='114017';
        MarketShare7.Market__c='test';
        MarketShare7.Month__c=3;
        MarketShare7.Owner__c='LILLY';
        MarketShare7.Previous_Month_TRx__c=0;
        MarketShare7.Product__c=IHSProduct2.ID;
        MarketShare7.Region__c=Region.ID;
        MarketShare7.Territory__c=Territory3.id;
        MarketShare7.TRx__c=0;
        MarketShare7.DDD_Dollars__c=0;
        MarketShare7.Previous_DDD_Dollars__c=0;
        MarketShare7.DDD_Units__c=0;
        MarketShare7.Previous_DDD_Units__c=0;
        MarketShare7.Year__c=2015;
        Insert MarketShare7;
        system.assert(MarketShare7.id!=null);
        
        MYBZ_Market_Share__c MarketShare8 = New MYBZ_Market_Share__c();
        MarketShare8.Name='TestMarket';
        MarketShare8.Global_Id__c='yyyyy';
        MarketShare8.Market__c='test';
        MarketShare8.Owner__c='LILLY';
        MarketShare8.Previous_Month_TRx__c=0;
        MarketShare8.Product__c=IHSProduct2.ID;
        MarketShare8.Region__c=Region1.ID;
        MarketShare8.Territory__c=Territory2.ID;
        MarketShare8.TRx__c=0;
        MarketShare8.DDD_Dollars__c=0;
        MarketShare8.Previous_DDD_Dollars__c=0;
        MarketShare8.DDD_Units__c=0;
        MarketShare8.Previous_DDD_Units__c=0;
        Insert MarketShare8;
        system.assert(MarketShare8.id!=null);
        
        List<MYBZ_System__c> SystemList = new List<MYBZ_System__c>();
        MYBZ_System__c System1 = new MYBZ_System__c();
        System1.Global_IDs__c = '114017';
        System1.Aligned_Districts__c = 'MA IHS DISTRICT';
        System1.Aligned_Territories__c = 'BAYSTATE MA IH Specialist 125376';
        SystemList.add(System1);
        
        MYBZ_System__c System2 = new MYBZ_System__c();
        System2.Global_IDs__c = '114017';
        System2.Aligned_Districts__c = 'MA IHS DISTRICT';
        System2.Aligned_Territories__c = 'CAREGROUP MA IH Partner 125395';
        SystemList.add(System2);
        
        insert SystemList;
        
        List<MYBZ_PGP__c> PGPList = new List<MYBZ_PGP__c>();
        MYBZ_PGP__c PGP1 = new MYBZ_PGP__c();
        PGP1.System__c = SystemList[0].id;
        PGP1.Global_IDs__c = '114017';
        PGP1.Aligned_Districts__c = 'MA IHS DISTRICT';
        PGP1.Aligned_Territories__c = 'CAREGROUP MA IH Partner 125395';
        PGPList.add(PGP1);
        
        MYBZ_PGP__c PGP2 = new MYBZ_PGP__c();
        PGP2.System__c = SystemList[0].id;
        PGP2.Global_IDs__c = '114017';
        PGP2.Aligned_Districts__c = 'MA IHS DISTRICT';
        PGP2.Aligned_Territories__c = 'BAYSTATE MA IH Specialist 125376';
        PGPList.add(PGP2);
        
        insert PGPList;
        
        
        MYBZ_Target_Goal__c TargetGoal = New MYBZ_Target_Goal__c();
        TargetGoal.Name='TestTargetGoal';
        TargetGoal.District__c=District.ID;
        TargetGoal.Global_Id__c='114017';
        TargetGoal.Month__c=1;
        TargetGoal.Product__c=IHSProduct.ID;
        TargetGoal.Territory__c = null;
        TargetGoal.TRx_Goal__c=2;
        TargetGoal.TRx_Goal_Attainment__c=2;
        TargetGoal.Year__c=2015;
        TargetGoal.baseline__c=123;
        TargetGoal.Product_Weight_DDD__c=12;
        TargetGoal.Product_Weight_TRx__c=11;
        Insert TargetGoal;
        system.assert(TargetGoal.id!=null);
        
        MYBZ_Target_Goal__c TargetGoal1 = New MYBZ_Target_Goal__c();
        TargetGoal1.Name='TestTargetGoal';
        TargetGoal1.District__c=District.ID;
        TargetGoal1.Global_Id__c='114017';
        TargetGoal1.Month__c=1;
        TargetGoal1.Product__c=IHSProduct.ID;
        TargetGoal1.Territory__c = null;
        TargetGoal1.TRx_Goal__c=2;
        TargetGoal1.TRx_Goal_Attainment__c=2;
        TargetGoal1.Year__c=2015;
        Insert TargetGoal1;
        system.assert(TargetGoal1.id!=null);
        
        MYBZ_Target_Goal__c TargetGoal2 = New MYBZ_Target_Goal__c();
        TargetGoal2.Name='TestTargetGoal';
        TargetGoal2.Global_Id__c='  ';
        TargetGoal2.Product__c=IHSProduct.ID;
        TargetGoal2.Month__c=1;
        TargetGoal2.TRx_Goal__c=2;
        TargetGoal2.TRx_Goal_Attainment__c=2;
        TargetGoal2.Year__c=2015;
        Insert TargetGoal2;
        system.assert(TargetGoal2.id!=null);
        
        MYBZ_Product_Trend_Detail__c PTD = New MYBZ_Product_Trend_Detail__c();
        PTD.Area__c=Region.ID;
        PTD.District__c=District.ID;
        PTD.End_Date__c=Date.ValueOf('2015-01-21')+30;
        PTD.HCP_First_Name__c='Test';
        PTD.Global_ID__c='114017';
        PTD.IHS_Product__c=IHSProduct.ID;
        PTD.HCP_Last_Name__c='Test';
        PTD.Range__c='6M';
        PTD.Start_Date__c=Date.ValueOf('2015-01-21');
        PTD.Territory__c=Territory.ID;
        PTD.TRx_Units__c=1;
        Insert PTD;
        system.assert(PTD.id!=null);
        
        MYBZ_Product_Trend_Detail__c PTD2 = New MYBZ_Product_Trend_Detail__c();
        PTD2.Area__c=Region.ID;
        PTD2.District__c=District.ID;
        PTD2.End_Date__c=Date.ValueOf('2015-02-21')+30;
        PTD2.Global_ID__c='114017';
        PTD.IHS_Product__c=IHSProduct.ID;
        PTD2.Range__c='6M';
        PTD2.Start_Date__c=Date.ValueOf('2015-02-21');
        PTD2.Territory__c=Territory.ID;
        PTD2.TRx_Units__c=5;
        Insert PTD2;
        system.assert(PTD2.id!=null);
        
        MYBZ_Product_Trend_Detail__c PTD3 = New MYBZ_Product_Trend_Detail__c();
        PTD3.Area__c=Region.ID;
        PTD3.District__c=District.ID;
        PTD3.HCP_First_Name__c='Test';
        PTD3.Global_ID__c='114017';
        PTD3.IHS_Product__c=IHSProduct.ID;
        PTD3.HCP_Last_Name__c='Test';
        PTD3.Range__c='6M';
        PTD3.Territory__c=Territory.ID;
        Insert PTD3;
        system.assert(PTD3.id!=null);
        
        MYBZ_Product_Trend_Detail__c PTD4 = New MYBZ_Product_Trend_Detail__c();
        PTD4.Area__c=Region.ID;
        PTD4.District__c=District.ID;
        PTD4.Global_ID__c='yyyyy';
        PTD4.Territory__c=Territory.ID;
        Insert PTD4;
        system.assert(PTD4.id!=null);
        
        
        MYBZ_Call_Planning__c CallPlanning = New MYBZ_Call_Planning__c();
        CallPlanning.Name='Test';   
        CallPlanning.LoadIdentifier__c='NON_AFFLTN';     
        CallPlanning.First_Name__c='FirstName'; 
        CallPlanning.Global_ID__c='114017';        
        CallPlanning.Last_Name__c='LastName';         
        CallPlanning.Territory__c=Territory.ID; 
        CallPlanning.Tier__c=1;        
        CallPlanning.Physician_ID__c = 'ppp';
        Insert CallPlanning;
        system.assert(CallPlanning.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning1 = New MYBZ_Call_Planning__c();
        CallPlanning1.Name='Test';  
        CallPlanning1.LoadIdentifier__c='NON_AFFLTN';       
        CallPlanning1.First_Name__c='FirstName'; 
        CallPlanning1.Global_ID__c='114017';         
        CallPlanning1.Last_Name__c='LastName';         
        CallPlanning1.Territory__c=Territory.ID; 
        CallPlanning1.Tier__c=1;         
        CallPlanning1.Physician_ID__c = 'ppp';
        Insert CallPlanning1;
        system.assert(CallPlanning1.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning2 = New MYBZ_Call_Planning__c();
        CallPlanning2.Name='Test';       
        CallPlanning2.First_Name__c='FirstName';
        CallPlanning2.LoadIdentifier__c='NON_AFFLTN';  
        CallPlanning2.Global_ID__c='114017';         
        CallPlanning2.Last_Name__c='LastName';         
        CallPlanning2.Territory__c=Territory.ID; 
        CallPlanning2.Tier__c=1;         
        CallPlanning2.Physician_ID__c = 'ppp';
        Insert CallPlanning2;
        system.assert(CallPlanning2.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning3 = New MYBZ_Call_Planning__c();
        CallPlanning3.Name='Test';        
        CallPlanning3.First_Name__c='FirstName'; 
        CallPlanning3.LoadIdentifier__c='NON_AFFLTN'; 
        CallPlanning3.Global_ID__c='114017';         
        CallPlanning3.Last_Name__c='LastName';         
        CallPlanning3.Territory__c=Territory.ID; 
        CallPlanning3.Tier__c=1;        
        CallPlanning3.Physician_ID__c = 'ppp';
        Insert CallPlanning3;
        system.assert(CallPlanning3.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning4 = New MYBZ_Call_Planning__c();
        CallPlanning4.Name='Test';        
        CallPlanning4.First_Name__c='FirstName';
        CallPlanning4.LoadIdentifier__c='AFFLTN';  
        CallPlanning4.Global_ID__c='114017';        
        CallPlanning4.Last_Name__c='LastName';
        CallPlanning4.Territory__c=Territory.ID; 
        CallPlanning4.Tier__c=1;         
        CallPlanning4.Physician_ID__c = 'ppp';
        Insert CallPlanning4;   
        system.assert(CallPlanning4.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning5 = New MYBZ_Call_Planning__c();
        CallPlanning5.Name='Test';       
        CallPlanning5.First_Name__c='FirstName'; 
        CallPlanning5.LoadIdentifier__c='NON_AFFLTN';
        CallPlanning5.Global_ID__c='114017';        
        CallPlanning5.Last_Name__c='LastName';         
        CallPlanning5.Territory__c=Territory.ID; 
        CallPlanning5.Tier__c=1;         
        CallPlanning5.Physician_ID__c = 'ppp';
        Insert CallPlanning5;  
        system.assert(CallPlanning5.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning6 = New MYBZ_Call_Planning__c();
        CallPlanning6.Name='Test';        
        CallPlanning6.Global_ID__c='yyyyy';               
        CallPlanning6.Territory__c=Territory2.ID;  
        CallPlanning6.LoadIdentifier__c='NON_AFFLTN';      
        CallPlanning6.Physician_ID__c = 'ppp';
        CallPlanning6.Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
        CallPlanning6.Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
        CallPlanning6.Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
        Insert CallPlanning6;
        system.assert(CallPlanning6.id!=null);
        
        MYBZ_Call__c Call = New MYBZ_Call__c();
        Call.Call_Date__c=null;
        Call.Call_Type__c='Test';
        Call.First_Name__c='FirstName';
        Call.Last_Name__c='LastName';
        Call.Product__c=IHSProduct.ID; 
        Call.Global_ID__c='114017';
        Call.Product_Position__c=1;
        Call.Territory__c=Territory.ID;
        Call.Name='Test';
        Call.Physician_ID__c = 'ppp';
        Call.Call_ID__c='A101';
        Call.Range__c='6M';
        Insert Call;
        system.assert(Call.id!=null);
        
        MYBZ_Call__c Call1 = New MYBZ_Call__c();
        Call1.Call_Date__c=null;
        Call1.Call_Type__c='Test';
        Call1.First_Name__c='FirstName';
        Call1.Last_Name__c='LastName';
        Call1.Product__c=IHSProduct2.ID; 
        Call1.Global_ID__c='114017';
        Call1.Product_Position__c=2;
        Call1.Territory__c=Territory.ID;
        Call1.Name='Test';
        Call1.Physician_ID__c = 'ppp';
        Call1.Call_ID__c='A101';
        Call1.Range__c='6M';
        Insert Call1;
        system.assert(Call1.id!=null);
        
        MYBZ_Call__c Call2 = New MYBZ_Call__c();
        Call2.Call_Date__c=null;
        Call2.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call2.First_Name__c='FirstName';
        Call2.Last_Name__c='LastName';
        Call2.Product__c=IHSProduct.ID; 
        Call2.Global_ID__c='114017';
        Call2.Product_Position__c=1;
        Call2.Territory__c=Territory.ID;
        Call2.Name='Test';
        Call2.Physician_ID__c = 'ppp';
        Call2.Call_ID__c='A102';
        Call2.Range__c='6M';
        Insert Call2;
        system.assert(Call2.id!=null);
        
        MYBZ_Call__c Call3 = New MYBZ_Call__c();
        Call3.Call_Date__c=null;
        Call3.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call3.First_Name__c='FirstName';
        Call3.Last_Name__c='LastName';
        Call3.Product__c=IHSProduct2.ID; 
        Call3.Global_ID__c='114017';
        Call3.Product_Position__c=2;
        Call3.Territory__c=Territory.ID;
        Call3.Name='Test';
        Call3.Physician_ID__c = 'ppp';
        Call3.Call_ID__c='A102';
        Call3.Range__c='6M';
        Insert Call3;
        system.assert(Call3.id!=null);
        
        MYBZ_Call__c Call4 = New MYBZ_Call__c();
        Call4.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call4.Product__c=IHSProduct2.ID; 
        Call4.Global_ID__c='yyyyy';
        Call4.Product_Position__c=2;
        Call4.Territory__c=Territory2.ID;
        Call4.Name='Test';
        Call4.Physician_ID__c = 'ppp';
        Call4.Call_ID__c='A103';
        Call4.Range__c='6M';
        Insert Call4;
        system.assert(Call4.id!=null);  
        
        MYBZ_Call__c Call5 = New MYBZ_Call__c();
        Call5.Call_Date__c=null;
        Call5.Call_Type__c='Test';
        Call5.First_Name__c='FirstName';
        Call5.Last_Name__c='LastName';
        Call5.Product__c=IHSProduct.ID; 
        Call5.Global_ID__c='114017';
        Call5.Product_Position__c=1;
        Call5.Territory__c=Territory.ID;
        Call5.Name='Test';
        Call5.Physician_ID__c = 'aaa';
        Call5.Call_ID__c='A100';
        Call5.Range__c='6M';
        Insert Call5;
        system.assert(Call5.id!=null);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction1 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction1.Call_Planning__c = CallPlanning1.id;
        callPlanJunction1.Product__c = IHSProduct.id;
        callPlanJunction1.Physician_ID__c ='ppp';
        callPlanJunction1.TRx_Units_1M__c = 1;
        callPlanJunction1.Previous_TRx_Units_1M__c = 1;
        callPlanJunction1.TRx_Units_3M__c = 1;
        callPlanJunction1.Previous_TRx_Units_3M__c = 1;
        callPlanJunction1.TRx_Units_6M__c = 1;
        callPlanJunction1.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction1;
        system.assert(callPlanJunction1.id!=null);
        
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction6 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction6.Call_Planning__c = CallPlanning5.id;
        callPlanJunction6.Physician_ID__c ='qqq';
        callPlanJunction6.TRx_Units_1M__c = 1;
        callPlanJunction6.Previous_TRx_Units_1M__c = 1;
        callPlanJunction6.TRx_Units_3M__c = 1;
        callPlanJunction6.Previous_TRx_Units_3M__c = 1;
        callPlanJunction6.TRx_Units_6M__c = 1;
        callPlanJunction6.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction6;
        system.assert(callPlanJunction6.id!=null);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction7 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction7.Call_Planning__c = CallPlanning3.id;
        callPlanJunction7.Physician_ID__c ='qqq';
        insert callPlanJunction7;
        system.assert(callPlanJunction7.id!=null);
        
        List<MYBZ_Region_Rollup__c> regionRollUp = new List<MYBZ_Region_Rollup__c>();
        List<string> alignments = new List<String>{'Region', 'District', 'Territory'};
            for(integer i=0; i< 3; i++){
                MYBZ_Region_Rollup__c eachRegionRollup = new MYBZ_Region_Rollup__c();
                MYBZ_Region_Rollup__c eachRegionRollup1 = new MYBZ_Region_Rollup__c();
                MYBZ_Region_Rollup__c eachRegionRollup2 = new MYBZ_Region_Rollup__c();
                MYBZ_Region_Rollup__c eachRegionRollup3 = new MYBZ_Region_Rollup__c();
                
                eachRegionRollup.Alignment_Level__c = alignments.get(i);
                eachRegionRollup.IHS_Division__c = Div.id;
                eachRegionRollup.Region__c = Region.id;
                eachRegionRollup.District__c = District.id;
                eachRegionRollup.Product__c = IHSProduct.ID;
                eachRegionRollup.Territory__c = Territory.id;
                eachRegionRollup.TRx_1M__c = 1;
                eachRegionRollup.TRx_3M__c = 1;
                eachRegionRollup.TRx_6M__c = 1;
                eachRegionRollup.NRx_1M__c = 1;
                eachRegionRollup.NRx_3M__c = 1;
                eachRegionRollup.NRx_6M__c = 1;
                eachRegionRollup.OPEX_1M__c = 1;
                eachRegionRollup.OPEX_3M__c = 1;
                eachRegionRollup.OPEX_6M__c = 1;
                eachRegionRollup.Gross_Margin_1M__c = 1;
                eachRegionRollup.Gross_Margin_3M__c = 1;
                eachRegionRollup.Gross_Margin_6M__c = 1;
                eachRegionRollup.Net_Profit_1M__c = 1;
                eachRegionRollup.Net_Profit_3M__c = 1;
                eachRegionRollup.Net_Profit_6M__c = 1;
                eachRegionRollup.DDD_Dollars_1M__c = 1;
                eachRegionRollup.DDD_Dollars_3M__c = 1;
                eachRegionRollup.DDD_Dollars_6M__c = 1;
                eachRegionRollup.DDD_Dollars_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.DDD_Dollars_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.DDD_Dollars_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.Gross_Margin_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.Gross_Margin_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.Gross_Margin_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.Net_Profit_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.Net_Profit_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.Net_Profit_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.NRx_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.NRx_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.NRx_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.OPEX_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.OPEX_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.OPEX_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.TRx_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.TRx_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup.TRx_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                
                eachRegionRollup.Global_ID__c = '114017';
                
                regionRollUp.add(eachRegionRollup);
                eachRegionRollup1.Alignment_Level__c = alignments.get(i);
                eachRegionRollup1.IHS_Division__c = Div.id;
                eachRegionRollup1.Region__c = Region.id;
                eachRegionRollup1.District__c = District.id;
                eachRegionRollup1.Product__c = IHSProduct2.ID;
                eachRegionRollup1.Territory__c = Territory.id;
                eachRegionRollup1.TRx_1M__c = 1;
                eachRegionRollup1.TRx_3M__c = 1;
                eachRegionRollup1.TRx_6M__c = 1;
                eachRegionRollup1.NRx_1M__c = 1;
                eachRegionRollup1.NRx_3M__c = 1;
                eachRegionRollup1.NRx_6M__c = 1;
                eachRegionRollup1.OPEX_1M__c = 1;
                eachRegionRollup1.OPEX_3M__c = 1;
                eachRegionRollup1.OPEX_6M__c = 1;
                eachRegionRollup1.Gross_Margin_1M__c = 1;
                eachRegionRollup1.Gross_Margin_3M__c = 1;
                eachRegionRollup1.Gross_Margin_6M__c = 1;
                eachRegionRollup1.Net_Profit_1M__c = 1;
                eachRegionRollup1.Net_Profit_3M__c = 1;
                eachRegionRollup1.Net_Profit_6M__c = 1;
                eachRegionRollup1.DDD_Dollars_1M__c = null;
                eachRegionRollup1.DDD_Dollars_3M__c = null;
                eachRegionRollup1.DDD_Dollars_6M__c = null;
                eachRegionRollup1.Global_ID__c = '114017';
                regionRollUp.add(eachRegionRollup1);
                
                eachRegionRollup2.Alignment_Level__c = alignments.get(i);
                eachRegionRollup2.IHS_Division__c = Div.id;
                eachRegionRollup2.Region__c = Region.id;
                eachRegionRollup2.District__c = District.id;
                eachRegionRollup2.Product__c = IHSProduct3.ID;
                eachRegionRollup2.Territory__c = Territory2.id;
                eachRegionRollup2.DDD_Dollars_1M__c = 1;
                eachRegionRollup2.DDD_Dollars_3M__c = 1;
                eachRegionRollup2.DDD_Dollars_6M__c = 1;
                eachRegionRollup2.Global_ID__c = 'yyyyy';
                regionRollUp.add(eachRegionRollup2);
                
                
                eachRegionRollup3.Alignment_Level__c = alignments.get(i);
                eachRegionRollup3.IHS_Division__c = Div.id;
                eachRegionRollup3.Region__c = Region.id;
                eachRegionRollup3.District__c = District.id;
                eachRegionRollup3.Product__c = null;
                eachRegionRollup3.Territory__c = Territory.id;
                eachRegionRollup3.TRx_1M__c = 1;
                eachRegionRollup3.TRx_3M__c = 1;
                eachRegionRollup3.TRx_6M__c = 1;
                eachRegionRollup3.NRx_1M__c = 1;
                eachRegionRollup3.NRx_3M__c = 1;
                eachRegionRollup3.NRx_6M__c = 1;
                eachRegionRollup3.OPEX_1M__c = 1;
                eachRegionRollup3.OPEX_3M__c = 1;
                eachRegionRollup3.OPEX_6M__c = 1;
                eachRegionRollup3.Gross_Margin_1M__c = 1;
                eachRegionRollup3.Gross_Margin_3M__c = 1;
                eachRegionRollup3.Gross_Margin_6M__c = 1;
                eachRegionRollup3.Net_Profit_1M__c = 1;
                eachRegionRollup3.Net_Profit_3M__c = 1;
                eachRegionRollup3.Net_Profit_6M__c = 1;
                eachRegionRollup3.DDD_Dollars_1M__c = 1;
                eachRegionRollup3.DDD_Dollars_3M__c = 1;
                eachRegionRollup3.DDD_Dollars_6M__c = 1;
                eachRegionRollup3.DDD_Dollars_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.DDD_Dollars_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.DDD_Dollars_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.Gross_Margin_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.Gross_Margin_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.Gross_Margin_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.Net_Profit_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.Net_Profit_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.Net_Profit_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.NRx_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.NRx_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.NRx_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.OPEX_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.OPEX_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.OPEX_Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.TRx_Start_Date_1M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                eachRegionRollup3.TRx_Start_Date_3M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
                regionRollUp.add(eachRegionRollup3);
                
            }
        insert regionRollUp;
        
        MYBZ_Region_Rollup_Controller.GlobalId='114017';
        MYBZ_Region_Rollup_Controller.UserId=Userinfo.getuserID();
        MYBZ_Region_Rollup_Controller TestController = New MYBZ_Region_Rollup_Controller();
        TestController.countUsageMetrics();
    }
    
    
    
    
    /*
* @Method Name                    :  testRegionRollup1
* @Description                    :  method to call Region Roll up report without using Territory picker                                                                   
* @Return Type                    :  Returns JSON Object for Region Roll up
* @Param                          :      
*/
    static Object testRegionRollup1(){
        Boolean flagAff = false;
        Obj=MYBZ_Region_Rollup_Controller.RegionRollup(flagAff); 
        return obj;        
    }
    
    
    
    /*
* @Method Name                    :  testAlignment
* @Description                    :  method to generate Alignment information using Territory picker                                                                
* @Return Type                    :  Returns JSON Object for Alignment
* @Param                          :      
*/
    static Object testAlignment(){
        
         // Insertion of Test Data
        //User runAsUserDataLoad = createUserDataLoad(System.Label.MYBZ_SuperUser);
        //System.runas(runAsUserDataLoad){ 
            
        //}
        insertTestData();
        Boolean flagAff = false;
        Obj=MYBZ_Region_Rollup_Controller.Alignment(flagAff);
        return Obj;
    }
    
    /*
* @Method Name                    :  testTargetGoal
* @Description                    :  method to generate Target Goal Report using Territory picker                                                                 
* @Return Type                    :  Returns JSON Object for Target Goal
* @Param                          :      
*/
    static Object testTargetGoal(){
        Obj=MYBZ_Region_Rollup_Controller.TargetGoalUsingPicker(Region.Name,District.Name,Territory.Name);
        return Obj;
    }
    
    /*
* @Method Name                    :  testTargetGoal1
* @Description                    :  method to generate Target Goal Report without using Territory Picker                                                                  
* @Return Type                    :  Returns JSON Object for Target Goal
* @Param                          :      
*/
    static Object testTargetGoal1(){
        Boolean flagAff = false;
        Obj=MYBZ_Region_Rollup_Controller.TargetGoal(flagAff); 
        return Obj;        
    }
 
/**** DEPRECATED ******/ 
    /*
* @Method Name                    :  testProductTrends
* @Description                    :  method to generate Product Trends Report using Territory Picker                                                                  
* @Return Type                    :  Returns JSON Object for Product Trends
* @Param                          :      
*/
  /*  static Object testProductTrends(){       
        Obj=MYBZ_Region_Rollup_Controller.ProductTrendsUsingPicker(Region.Name,District.Name,Territory.Name);
        return Obj;
    }
    */
    /*
* @Method Name                    :  testProductTrends1
* @Description                    :  method to generate Product Trends Report without using Territory Picker                                                                  
* @Return Type                    :  Returns JSON Object for Product Trends
* @Param                          :      
*/
  /*  static Object testProductTrends1(){
        Obj=MYBZ_Region_Rollup_Controller.ProductTrends();
        return Obj;        
    }
   */
/**** DEPRECATED PRODUCT TRENDS ENDS******/  
/**** DEPRECATED ****/  
/*
* @Method Name                    :  testMarketShare
* @Description                    :  method to generate Market Share Report using Territory Picker                                                                  
* @Return Type                    :  Returns JSON Object for Market Share
* @Param                          :      
*/
 /*   static Object testMarketShare(){
        Obj = MYBZ_Region_Rollup_Controller.MarketShareUsingPicker(Region.Name,District.Name,Territory.Name);  
        return Obj;
    }
    
*/
/*
* @Method Name                    :  testMarketShare1
* @Description                    :  method to generate Market Share Report without using Territory Picker                                                                  
* @Return Type                    :  Returns JSON Object for Market Share
* @Param                          :      
*/
/*    static Object testMarketShare1(){
        Obj = MYBZ_Region_Rollup_Controller.MarketShare();
        return Obj;
    }
*/  
/**** DEPRECATED MARKETSHARE ENDS******/   
   
    /*
* @Method Name                    :  testTrendsPrescriber1
* @Description                    :  method to generate Trends Prescriber Report                                                               
* @Return Type                    :  Returns JSON Object for Trends Prescriber
* @Param                          :      
*/
    static Object testTrendsPrescriber1(){
        Obj = MYBZ_Region_Rollup_Controller.TrendsPrescriber();                     
        return Obj;
    }
    
    /*
* @Method Name                    :  testTrendsPrescriber
* @Description                    :  method to generate Trends Prescriber Report using Territory Picker                                                             
* @Return Type                    :  Returns JSON Object for Trends Prescriber
* @Param                          :      
*/
    static Object testTrendsPrescriber(){
        Obj = MYBZ_Region_Rollup_Controller.TrendsPrescriberUsingPicker(Region.Name,District.Name,Territory.Name);                     
        return Obj;
    }
    
    /*
* @Method Name                    :  testcallPlanning
* @Description                    :  method to generate call planning Report using Territory Picker                                                                  
* @Return Type                    :  Returns JSON Object for call planning
* @Param                          :      
*/        
    static Object testcallPlanning(){
        Obj=MYBZ_Region_Rollup_Controller.callPlanningUsingPicker(Region.Name,District.Name,Territory.Name);
        return Obj;
    }
    
    /*
* @Method Name                    :  testcallPlanning1
* @Description                    :  method to generate call planning Report without using Territory Picker                                                                  
* @Return Type                    :  Returns JSON Object for call planning
* @Param                          :      
*/
    static Object testcallPlanning1(){
        Obj= MYBZ_Region_Rollup_Controller.callPlanning();            
        return Obj;
    }
    
    
    /*
* @Method Name                    :  testAsSalesRepAlignment
* @Description                    :  method to test as Sales Representative(Role) generation of JSONS for each report as in
Region Roll up, Product trends, Market Share, Call Planning etc.                                     
* @Return Type                    :  void
* @Param                          :      
*/ 
    
    static testMethod void testAsSalesRepAlignment() {
        String jsonrespasString;
        User runAsUser = createUser('Sales Representative');
        // Insertion of Test Data
        User runAsUserDataLoad = createUserDataLoad(System.Label.MYBZ_SuperUser);
        System.runas(runAsUserDataLoad){ 
             insertTestData();
        }
                       
        System.runas(runAsUser){ 
            
            
            MYBZ_Region_Rollup_Controller controller = new MYBZ_Region_Rollup_Controller();
            MYBZ_Region_Rollup_Controller.datetimeStamp = String.valueOf(system.today());
            MYBZ_Region_Rollup_Controller.Page = '1';
               
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();
            jsonrespasString = Obj+'';
            //Assert to check the generated JSON has the division name from Test Data created 
            system.assert(jsonrespasString.contains('IHS Division'));
            system.assert(jsonrespasString.contains('2015-01-21T00:00:00.000Z'));
             
            Obj=testTargetGoal1();           
            jsonrespasString = Obj+'';
            
            // Assert to check whether the JSON contains relevant product,goal set, year and goal met from test data   
            system.assert(jsonrespasString.contains('2015'));
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('2'));
            
            Obj=testTrendsPrescriber1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            system.assert(jsonrespasString.contains('Test'));
            
            
            /*Obj=testProductTrends1();  
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';          
            // Assert to check whether the JSON contains relevant product,year and month inserted from  test data   
            system.assert(jsonrespasString.contains('EFFIENT'));            
            system.assert(jsonrespasString.contains('2014'));
            system.assert(jsonrespasString.contains('3'));*/
            
            
            Obj=testcallPlanning1();             
            jsonrespasString = Obj+'';
            //System.assertEquals('this will fail' ,'' + Obj); 
            // Assert to check whether the JSON contains relevant product and Tier inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
            
            /*Obj=testMarketShare1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product and Market inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('test')); */
            
            
        }
    }
    
      /*
* @Method Name                    :  testAsMajorManAlignment
* @Description                    :  method to test as Major Market Manager(Role) generation of JSONS for each report as in
Region Roll up, Product trends, Market Share, Call Planning etc.                                     
* @Return Type                    :  void
* @Param                          :      
*/
    static testMethod void testAsMajorManAlignment() {
        User runAsUser = createUser('Major Market Manager'); 
             
         String jsonrespasString;
        System.runas(runAsUser){ 
            // Asserting the JSONs generated from querying records for each report after selection done using Territory picker          
            Obj=testAlignment(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant district and global id from  test data               
            system.assert(jsonrespasString.contains('114017')); 
            system.assert(jsonrespasString.contains('TestRegion')); 
            
            
            Obj=testTargetGoal();            
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,goal set and goal met from test data  
            system.assert(jsonrespasString.contains('EFFIENT'));        
            system.assert(jsonrespasString.contains('2')); 
            
            
            /*Obj=testProductTrends();
            system.assertEquals(null,Obj);*/
            
            Obj=testcallPlanning();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product and prescriber name inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('FirstName'));
            
            
            /*Obj=testMarketShare(); 
            system.assertEquals(null,Obj);*/
            
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('IHS Division'));
            
            
            Obj=testTargetGoal1();
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,goal set and goal met from test data  
            system.assert(jsonrespasString.contains('EFFIENT'));        
            system.assert(jsonrespasString.contains('2'));
            
            
            Obj=testTrendsPrescriber1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('topFivePrescribers'));
            system.assert(jsonrespasString.contains('Test'));
            
            
            /*Obj=testProductTrends1(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,year and month inserted from  test data   
            system.assert(jsonrespasString.contains('EFFIENT'));            
            system.assert(jsonrespasString.contains('2014'));
            system.assert(jsonrespasString.contains('3'));*/
            
            
            Obj=testcallPlanning1();
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('FirstName'));
            
                       
           /* Obj=testMarketShare1();
            system.assert(Obj!=null);
             jsonrespasString = Obj+'';
            system.assert(jsonrespasString.contains('EFFIENT'));
           */   
            
            
        }
    } 
    
        /*
* @Method Name                    :  testAsDisManAlignment
* @Description                    :  method to test as District Sales Manager(Role) generation of JSONS for each report as in
Region Roll up, Product trends, Market Share, Call Planning etc.                                     
* @Return Type                    :  void
* @Param                          :      
*/
    static testMethod void testAsDisManAlignment() {
     String jsonrespasString;
        User runAsUser = createUser('District Sales Manager');
                            
        System.runas(runAsUser){ 
            // Asserting the JSONs generated from querying records for each report after selection done using Territory picker          
            Obj=testAlignment();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant district and global id from  test data  
            system.assert(jsonrespasString.contains('TestDistrict'));   
            system.assert(jsonrespasString.contains('114017'));
            
            Obj=testTrendsPrescriber();
            system.assert(Obj!=null);
             jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('topFivePrescribers'));
            system.assert(jsonrespasString.contains('Test'));
            
            
            Obj=testTargetGoal();           
            system.assert(Obj==null);
            // jsonrespasString = Obj+'';
            
            
           /* Obj=testProductTrends();       
            system.assert(Obj!=null);
             jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,year and month inserted from  test data   
            system.assert(jsonrespasString.contains('EFFIENT'));            
            system.assert(jsonrespasString.contains('2014'));
            system.assert(jsonrespasString.contains('3'));*/
            
            Obj=testcallPlanning(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
            
            /*Obj=testMarketShare(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product and Market inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('test')); */
            
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant district and global id from  test data 
            system.assert(jsonrespasString.contains('IHS Division'));   
            system.assert(jsonrespasString.contains('EFFIENT'));
            
            Obj=testTargetGoal1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,goal set and goal met from test data  
            system.assert(jsonrespasString.contains('EFFIENT'));        
            system.assert(jsonrespasString.contains('2'));
            
            
            Obj=testTrendsPrescriber1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data  
            //system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('topFivePrescribers'));
            system.assert(jsonrespasString.contains('Test'));
            
            /*Obj=testProductTrends1();            
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,year and month inserted from  test data   
            system.assert(jsonrespasString.contains('EFFIENT'));            
            system.assert(jsonrespasString.contains('2014'));
            system.assert(jsonrespasString.contains('3'));*/
            
            Obj=testcallPlanning1(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
            /*Obj=testMarketShare1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product and Market inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('test')); */
        }
    }
    //////////////////
    
    

    /*
* @Method Name                    :  testAsAccountManager
* @Description                    :  method to test as Account Manager(Role) generation of JSONS for each report as in
Region Roll up, Product trends, Market Share, Call Planning etc.                                     
* @Return Type                    :  void
* @Param                          :      
*/
    static testMethod void testAsAccountManager() {
     String jsonrespasString;
        User runAsUser = createUser('Account Manager');             
        System.runas(runAsUser){ 
            // Asserting the JSONs generated from querying records for each report after selection done using Territory picker          
            Obj=testAlignment();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant region and global id from  test data 
            system.assert(jsonrespasString.contains('TestRegion')); 
            
            
            Obj=testTrendsPrescriber();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('topFivePrescribers'));
            system.assert(jsonrespasString.contains('Test'));
            
            Obj=testTargetGoal();            
            system.assert(Obj==null);
            //jsonrespasString = Obj+'';
            
            
            /*Obj=testProductTrends();            
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,year and month inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('2014'));
            system.assert(jsonrespasString.contains('3'));*/
            
            Obj=testcallPlanning(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
            /*Obj=testMarketShare(); 
            system.assert(Obj!=null);
             jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product and Market inserted from  test data 
            system.assert(jsonrespasString.contains('EFFIENT')); 
            system.assert(jsonrespasString.contains('test'));  */
            
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,division from test data 
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('IHS Division'));
            
            
            Obj=testTrendsPrescriber1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            //System.assertEquals('this will fail' ,'' + Obj);  
            // Assert to check whether the JSON contains relevant product,prescriber inserted from  test data 
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('topFivePrescribers'));
            system.assert(jsonrespasString.contains('Test'));
            
            /*Obj=testProductTrends1();            
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,year and month inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('2014'));
            system.assert(jsonrespasString.contains('3'));*.
            
            Obj=testcallPlanning1(); 
            //system.assert(Obj!=null);
             jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
            /*Obj=testMarketShare1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product and Market inserted from  test data 
            system.assert(jsonrespasString.contains('EFFIENT'));  
            system.assert(jsonrespasString.contains('test'));   */ 
        }
    }
    
   
    //////////////////
    
    static testMethod void testAsSuperUser() {
        User runAsUser = createUser('Super User');     
                
        System.runas(runAsUser){ 
             String jsonrespasString;
            // Asserting the JSONs generated from querying records for each report after selection done using Territory picker 
            Obj=testTargetGoal();            
            system.assertEquals(null,Obj);
            
            //Asserting the JSONs generated from querying records for each report without using Territory picker
            Obj=testTargetGoal1();
            system.assertEquals(null,Obj);
            Obj=testTrendsPrescriber1();
            system.assertEquals(null,Obj);
            /*Obj=testProductTrends1();            
            system.assertEquals(null,Obj); */
            /*Obj=testMarketShare1();            
            // Assert to check whether the JSON contains relevant product and Market inserted from  test data 
            system.assert(jsonrespasString.contains('EFFIENT'));  
            */
        }
    }
    
    static testMethod void testAsAdmin() {
        User runAsUser = createUser('Super User');
        User runAsUserDataLoad = createUserDataLoad('Super User');
        
        System.runas(runAsUserDataLoad){ 
            insertTestData();
        }     
        List<MYBZ_CallPlanningProductJunction__c> CallPlanningsList = new List<MYBZ_CallPlanningProductJunction__c>();
        CallPlanningsList = [Select Call_Planning__c,Call_Planning__r.Physician_ID__c,Call_Planning__r.Global_ID__c,Call_Planning__r.First_Name__c,Call_Planning__r.Last_Name__c,
                                    Call_Planning__r.Tier__c,Product__c,Product__r.name,TRx_Units_1M__c, TRx_Units_3M__c, TRx_Units_6M__c, Previous_TRx_Units_1M__c, Previous_TRx_Units_3M__c, 
                                    Previous_TRx_Units_6M__c, Call_Planning__r.Start_Date_1M__c, Call_Planning__r.Start_Date_3M__c, Call_Planning__r.Start_Date_6M__c,Call_Planning__r.LoadIdentifier__c,
                                    Call_Planning__r.Data_Load_Date__c from MYBZ_CallPlanningProductJunction__c];
                                    
        System.runas(runAsUser){ 
             String jsonrespasString;
             Boolean flagAff = false;
             Obj=MYBZ_Region_Rollup_Controller.alignment(flagAff); 
             system.assert(Obj!=null);
             /*Obj=MYBZ_Region_Rollup_Controller.productTrendsUsingPicker(Region.Name, District.Name, Territory.Name);
             system.assert(Obj!=null); 
             Obj=MYBZ_Region_Rollup_Controller.productTrendsUsingPicker(Region.Name, null, Territory.Name); 
             system.assert(Obj!=null);
             Obj=MYBZ_Region_Rollup_Controller.productTrendsUsingPicker(null, null, Territory.Name); 
             system.assert(Obj!=null);*/           
             Obj=MYBZ_Region_Rollup_Controller.regionRollup(flagAff);
             system.assert(Obj!=null);
             Obj=MYBZ_Region_Rollup_Controller.callPlanningUsingPicker(Region.Name, District.Name, Territory.Name);
             system.assert(Obj!=null); 
             Obj=MYBZ_Region_Rollup_Controller.callPlanningUsingPicker(Region.Name, null, Territory.Name); 
             system.assert(Obj!=null);
             Obj=MYBZ_Region_Rollup_Controller.callPlanningUsingPicker(null, null, Territory.Name);
             system.assert(Obj!=null); 
             MYBZ_Region_Rollup_Controller.callPlanning();
             system.assert(Obj!=null);           
             MYBZ_Region_Rollup_Controller.targetGoal(flagAff);
             system.assert(Obj!=null);
        }
    }
    
    
  
}