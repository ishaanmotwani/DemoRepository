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
                                  timezonesidkey='America/Los_Angeles', username='appBasicIhs@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role, Prsnl_Nbr_GLBL__c=Globalid,MYBZ_Reporting_ID__c='3');
        
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
       
    static MYBZ_Region__c Region = New MYBZ_Region__c();
    static MYBZ_Region__c Region1 = New MYBZ_Region__c();
    static MYBZ_District__c District = New MYBZ_District__c();
    static MYBZ_District__c District1 = New MYBZ_District__c();
    static MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory2 = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory3 = New MYBZ_Territory__c();
    static MYBZ_Territory__c TerritoryPAC = new MYBZ_Territory__c(); 
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
        
        MYBZ_IHS_Division__c DivPAC = New MYBZ_IHS_Division__c();
        DivPAC.Name='IHS PAC NW DIVISION';
        Insert DivPAC;  
        system.assert(DivPAC.id!=null);        
        
        Region.Name='TestRegion';
        Region.Parent__c=Div.ID;
        Insert Region;
        system.assert(Region.id!=null);        
        
        Region1.Name=' Test PAC NW';
        Region1.Parent__c=DivPAC.ID;
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
        
        TerritoryPAC.Name='TestTerritoryPAC';
        TerritoryPAC.State__c = District1.id;
        Insert TerritoryPAC;
        system.assert(TerritoryPAC.id!=null);
                
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
        CallPlanning4.LoadIdentifier__c='NON_AFFLTN';    
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
        
        MYBZ_Call_Planning__c CallPlanning7 = New MYBZ_Call_Planning__c();
        CallPlanning7.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.First_Name__c='FN2';
        CallPlanning7.Global_ID__c='2016016';
        CallPlanning7.Last_Name__c='LN2';
        CallPlanning7.LoadIdentifier__c='NON_AFFLTN';
        CallPlanning7.Physician_ID__c='BBB';
        CallPlanning7.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.Territory__c=Territory2.id;
        CallPlanning7.Tier__c=1;
        Insert CallPlanning7;
        system.assert(CallPlanning7.id!=null);
        
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
        Call.LoadIdentifier__c='NON_AFFLTN';  
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
        Call1.LoadIdentifier__c='NON_AFFLTN';  
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
        Call2.LoadIdentifier__c='NON_AFFLTN';  
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
        Call3.LoadIdentifier__c='NON_AFFLTN';  
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
        Call4.LoadIdentifier__c='NON_AFFLTN';  
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
        Call5.LoadIdentifier__c='NON_AFFLTN';  
        Insert Call5;
        system.assert(Call5.id!=null);
        
        MYBZ_Call__c Call10 = New MYBZ_Call__c();
        Call10.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call10.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call10.Product__c=IHSProduct2.ID; 
        Call10.Global_ID__c='2016016';
        Call10.Product_Position__c=2;
        Call10.Territory__c=Territory2.ID;
        Call10.Name='Test';
        Call10.Physician_ID__c = 'BBB';
        Call10.Call_ID__c='A103';
        Call10.Range__c='6M';
        Call10.LoadIdentifier__c='NON_AFFLTN';
        Insert Call10;
        system.assert(Call10.id!=null);  
        
        MYBZ_Call__c Call11 = New MYBZ_Call__c();
        Call11.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call11.Call_Type__c='Test';
        Call11.First_Name__c='FirstName';
        Call11.Last_Name__c='LastName';
        Call11.Product__c=IHSProduct.ID; 
        Call11.Global_ID__c='2016016';
        Call11.Product_Position__c=1;
        Call11.Territory__c=Territory2.ID;
        Call11.Name='Test';
        Call11.Physician_ID__c = 'BBB';
        Call11.Call_ID__c='A100';
        Call11.Range__c='6M';
        Call11.LoadIdentifier__c='NON_AFFLTN';
        Insert Call11;
        system.assert(Call11.id!=null);
        
        MYBZ_Call__c Call6 = New MYBZ_Call__c();
        Call6.Call_Date__c=null;
        Call6.Call_Type__c='Test';
        Call6.First_Name__c='FirstName';
        Call6.Last_Name__c='LastName';
        Call6.Product__c=IHSProduct.ID; 
        Call6.Global_ID__c='2016016';
        Call6.Product_Position__c=1;
        Call6.Territory__c=Territory2.ID;
        Call6.Name='Test';
        Call6.Physician_ID__c = 'BBB';
        Call6.Call_ID__c='A104';
        Call6.Range__c='6M';
        Call6.LoadIdentifier__c='NON_AFFLTN';
        Insert Call6;
        system.assert(Call6.id!=null);
        
        MYBZ_Call__c Call7 = New MYBZ_Call__c();
        Call7.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call7.Call_Type__c='Test';
        Call7.First_Name__c='FirstName';
        Call7.Last_Name__c='LastName';
        Call7.Product__c=IHSProduct.ID; 
        Call7.Global_ID__c='2016016';
        Call7.Product_Position__c=1;
        Call7.Territory__c=Territory2.ID;
        Call7.Name='Test';
        Call7.Physician_ID__c = 'BBB';
        Call7.Call_ID__c='A105';
        Call7.Range__c='6M';
        Call7.LoadIdentifier__c='NON_AFFLTN';
        Insert Call7;
        system.assert(Call7.id!=null);
        
        MYBZ_Call__c Call8 = New MYBZ_Call__c();
        Call8.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call8.Call_Type__c='Test';
        Call8.First_Name__c='FirstName';
        Call8.Last_Name__c='LastName';
        Call8.Product__c=IHSProduct.ID; 
        Call8.Global_ID__c='2016016';
        Call8.Product_Position__c=1;
        Call8.Territory__c=Territory2.ID;
        Call8.Name='Test';
        Call8.Physician_ID__c = 'BBB';
        Call8.Call_ID__c='A106';
        Call8.Range__c='6M';
        Call8.LoadIdentifier__c='NON_AFFLTN';
        Insert Call8;
        system.assert(Call8.id!=null);
        
        MYBZ_Call__c Call9 = New MYBZ_Call__c();
        Call9.Call_Date__c=null;
        Call9.Call_Type__c='Test';
        Call9.First_Name__c='FirstName';
        Call9.Last_Name__c='LastName';
        Call9.Product__c=IHSProduct.ID; 
        Call9.Global_ID__c='2016016';
        Call9.Product_Position__c=1;
        Call9.Territory__c=Territory2.ID;
        Call9.Name='Test';
        Call9.Physician_ID__c = 'BBB';
        Call9.Call_ID__c='A107';
        Call9.Range__c='6M';
        Call9.LoadIdentifier__c='NON_AFFLTN';
        Insert Call9;
        system.assert(Call9.id!=null);
        
        
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
        
         MYBZ_CallPlanningProductJunction__c  CallPlanningJunction8 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction8.Call_Planning__c = CallPlanning7.id;
        CallPlanningJunction8.Product__c = IHSProduct.id;
        CallPlanningJunction8.TRx_Units_1M__c = 1;
        CallPlanningJunction8.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction8.TRx_Units_3M__c = 1;
        CallPlanningJunction8.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction8.TRx_Units_6M__c = 1;
        CallPlanningJunction8.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction8.Physician_ID__c ='BBB';
        insert CallPlanningJunction8; 
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction9 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction9.Call_Planning__c = CallPlanning7.id;
        CallPlanningJunction9.Product__c = IHSProduct2.id;
        CallPlanningJunction9.TRx_Units_1M__c = 1;
        CallPlanningJunction9.Previous_TRx_Units_1M__c = 0;
        CallPlanningJunction9.TRx_Units_3M__c = 1;
        CallPlanningJunction9.Previous_TRx_Units_3M__c = 0;
        CallPlanningJunction9.TRx_Units_6M__c = 1;
        CallPlanningJunction9.Previous_TRx_Units_6M__c = 0;
        CallPlanningJunction9.Physician_ID__c ='BBB';
        insert CallPlanningJunction9;
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction10 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction10.Call_Planning__c = CallPlanning7.id;
        CallPlanningJunction10.TRx_Units_1M__c = 1;
        CallPlanningJunction10.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction10.TRx_Units_3M__c = 1;
        CallPlanningJunction10.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction10.TRx_Units_6M__c = 1;
        CallPlanningJunction10.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction10.Physician_ID__c ='BBB';
        insert CallPlanningJunction10;
        
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
                
                //Region Roll up record at Region Level
                MYBZ_Region_Rollup__c eachRegionRollupReg1 = new MYBZ_Region_Rollup__c();
                eachRegionRollupReg1.Alignment_Level__c = alignments.get(0);
                eachRegionRollupReg1.IHS_Division__c = Div.id;
                eachRegionRollupReg1.Region__c = Region.id;
                eachRegionRollupReg1.District__c = null;
                eachRegionRollupReg1.Product__c = IHSProduct3.ID;
                eachRegionRollupReg1.Territory__c = null;
                //eachRegionRollupReg1.Global_ID__c = '114017';             
                
                regionRollUp.add(eachRegionRollupReg1);
                
                //Region Roll up record at district Level
                MYBZ_Region_Rollup__c eachRegionRollupDist1 = new MYBZ_Region_Rollup__c();
                eachRegionRollupDist1.Alignment_Level__c = alignments.get(1);
                eachRegionRollupDist1.IHS_Division__c = Div.id;
                eachRegionRollupDist1.Region__c = Region.id;
                eachRegionRollupDist1.District__c = District.id;
                eachRegionRollupDist1.Product__c = IHSProduct3.ID;
                eachRegionRollupDist1.Territory__c = null;
                //eachRegionRollupDist1.Global_ID__c = '114017';                
                
                regionRollUp.add(eachRegionRollupDist1);
                
                //Region Roll up record at territory Level
                MYBZ_Region_Rollup__c eachRegionRollupTerr1 = new MYBZ_Region_Rollup__c();
                eachRegionRollupTerr1.Alignment_Level__c = alignments.get(2);
                eachRegionRollupTerr1.IHS_Division__c = Div.id;
                eachRegionRollupTerr1.Region__c = Region.id;
                eachRegionRollupTerr1.District__c = District.id;
                eachRegionRollupTerr1.Product__c = IHSProduct3.ID;
                eachRegionRollupTerr1.Territory__c = Territory2.id;
                //eachRegionRollupTerr1.Global_ID__c = '114017';                
                
                //Region Roll up record at PAC Region level             
                MYBZ_Region_Rollup__c eachRegionRollupRegPAC1 = new MYBZ_Region_Rollup__c();
                eachRegionRollupRegPAC1.Alignment_Level__c = alignments.get(0);
                eachRegionRollupRegPAC1.IHS_Division__c = DivPAC.id;
                eachRegionRollupRegPAC1.Region__c = Region1.id;
                eachRegionRollupRegPAC1.District__c = null;
                eachRegionRollupRegPAC1.Product__c = IHSProduct3.ID;
                eachRegionRollupRegPAC1.Territory__c = null;
                eachRegionRollupRegPAC1.Global_ID__c = '114017';                
                
                regionRollUp.add(eachRegionRollupRegPAC1);
                
                //Region Roll up record at PAC district Level
                MYBZ_Region_Rollup__c eachRegionRollupDistPAC1 = new MYBZ_Region_Rollup__c();
                eachRegionRollupDistPAC1.Alignment_Level__c = alignments.get(1);
                eachRegionRollupDistPAC1.IHS_Division__c = DivPAC.id;
                eachRegionRollupDistPAC1.Region__c = Region1.id;
                eachRegionRollupDistPAC1.District__c = District1.id;
                eachRegionRollupDistPAC1.Product__c = IHSProduct3.ID;
                eachRegionRollupDistPAC1.Territory__c = null;
                eachRegionRollupDistPAC1.Global_ID__c = '114017';               
                
                regionRollUp.add(eachRegionRollupDistPAC1);
                
                //Region Roll up record at PAC territory Level
                MYBZ_Region_Rollup__c eachRegionRollupTerrPAC1 = new MYBZ_Region_Rollup__c();
                eachRegionRollupTerrPAC1.Alignment_Level__c = alignments.get(2);
                eachRegionRollupTerrPAC1.IHS_Division__c = DivPAC.id;
                eachRegionRollupTerrPAC1.Region__c = Region1.id;
                eachRegionRollupTerrPAC1.District__c = District1.id;
                eachRegionRollupTerrPAC1.Product__c = IHSProduct3.ID;
                eachRegionRollupTerrPAC1.Territory__c = TerritoryPAC.id;
                eachRegionRollupTerrPAC1.Global_ID__c = '114017';               
                
                regionRollUp.add(eachRegionRollupTerrPAC1);
                
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
 
/* @Method Name                    :  testcallPlanning
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
            
            
            Obj=testcallPlanning1();             
            jsonrespasString = Obj+'';
            //System.assertEquals('this will fail' ,'' + Obj); 
            // Assert to check whether the JSON contains relevant product and Tier inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
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
            
            Obj=testcallPlanning();
            
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
            
            Obj=testcallPlanning1();
            jsonrespasString = Obj+'';
                       
            
            
            
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
            
            
            Obj=testTargetGoal();           
            system.assert(Obj==null);
            // jsonrespasString = Obj+'';
            
            Obj=testcallPlanning(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
            
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
            
            
            Obj=testcallPlanning1(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
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
            
            
            Obj=testTargetGoal();            
            system.assert(Obj==null);
            //jsonrespasString = Obj+'';
            
            
            Obj=testcallPlanning(); 
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
            
            // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
            Obj=testRegionRollup1();
            system.assert(Obj!=null);
            jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant product,division from test data 
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('IHS Division'));
            
           
            
            Obj=testcallPlanning1(); 
            //system.assert(Obj!=null);
             jsonrespasString = Obj+'';
            // Assert to check whether the JSON contains relevant products inserted from  test data  
            system.assert(jsonrespasString.contains('EFFIENT'));
            system.assert(jsonrespasString.contains('1'));
            
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
    
    static testMethod void testAsPACUser() {
        User runAsUser = createUser('Account Manager');  
        
        System.runas(runAsUser){ 
         String jsonrespasString;
         Boolean flagAff = false;
        // Asserting the JSONs generated from querying records for each report after selection done using Territory picker          
        Obj=testAlignment();
        system.assert(Obj!=null);
        jsonrespasString = Obj+'';
        // Assert to check whether the JSON contains relevant region and global id from  test data 
        system.assert(jsonrespasString.contains('TestRegion'));
        
        // Asserting the JSONs generated from querying records for each report after selection done without using Territory picker
        Obj=testRegionRollup1();
        system.assert(Obj!=null);
        jsonrespasString = Obj+'';
        // Assert to check whether the JSON contains relevant product,division from test data 
        system.assert(jsonrespasString.contains('EFFIENT'));
        system.assert(jsonrespasString.contains('IHS Division'));   
      }     
    }
    
     static testMethod void testAsSalesRepAlignment2() {
        String jsonrespasString;
         User runAsUser = createUserToRun(System.Label.MYBZ_SalesRepresentative, '2016016');  
        
        System.runas(runAsUser){ 
        
            // Insertion of Test Data
            insertTestData();
        
        }
        System.runas(runAsUser){ 
            Test.startTest();
               Obj=testcallPlanning1();
               jsonrespasString = Obj+'';
               //Assertion to Check whether the generated JSON contains the Test data related to Call Planning
               system.assert(jsonrespasString.contains('05/20/2015'));             
               system.assert(jsonrespasString.contains('EFFIENT'));
               Test.stopTest();
        }
     }
  
}