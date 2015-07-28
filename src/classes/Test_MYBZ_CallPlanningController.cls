@isTest
private class Test_MYBZ_CallPlanningController {
    
    static MYBZ_Region__c Region = New MYBZ_Region__c();
    static MYBZ_District__c District = New MYBZ_District__c();
    static MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory2 = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory3 = New MYBZ_Territory__c();
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

    
     /*
    * @Method Name                    :  insertTestDataCallPlanning
    * @Description                    :  method to create Test Data of  Call Planning
    * @Return Type                    :  void
    * @Param                          :      
    */
    static void insertTestDataCallPlanning() {
        MYBZ_Product__c IHSProduct = New MYBZ_Product__c();
        IHSProduct.Name='EFFIENT'; 
        Insert IHSProduct;
        system.assert(IHSProduct.id!=null);
        
        MYBZ_Product__c IHSProduct2 = New MYBZ_Product__c();
        IHSProduct2.Name='FORTEO'; 
        Insert IHSProduct2;
        system.assert(IHSProduct2.id!=null);
        
        MYBZ_Product__c IHSProduct3 = New MYBZ_Product__c();
        IHSProduct3.Name='CIALIS'; 
        Insert IHSProduct3;
        system.assert(IHSProduct3.id!=null);
        
        MYBZ_IHS_Division__c Div = New MYBZ_IHS_Division__c();
        Div.Name=System.Label.MYBZ_IHSDivision;
        Insert Div;  
        system.assert(Div.id!=null);
        
        Region.Name='EAST IHS AREA';
        Region.Parent__c=Div.ID;
        Insert Region;
        system.assert(Region.id!=null);
        
        District.Name='MA IHS SPECIALIST';
        District.Region__c=Region.ID;
        Insert District;
        system.assert(District.id!=null);
        
        
        Territory.Name='ALLINA MN IH Specialist';
        Territory.State__c = District.id;
        Insert Territory;
        system.assert(Territory.id!=null);
        
        List<MYBZ_System__c> SystemList = new List<MYBZ_System__c>();
        MYBZ_System__c System1 = new MYBZ_System__c();
        System1.Name='ATRIUS HEALTH';
        System1.Global_IDs__c = '2016016';
        System1.Aligned_Districts__c = 'MA IHS DISTRICT';
        System1.Aligned_Territories__c = 'ALLINA MN IH Specialist';
        System1.System_ID__c='TestSystem1';
        SystemList.add(System1);
        
        MYBZ_System__c System2 = new MYBZ_System__c();
        System2.Name='BAYSTATE HEALTH';
        System2.Global_IDs__c = '2016016';
        System2.Aligned_Districts__c = 'MA IHS DISTRICT';
        System2.Aligned_Territories__c = 'ALLINA MN IH Specialist';
        System2.System_ID__c='TestSystem2';
        SystemList.add(System2);
        
        MYBZ_System__c System3 = new MYBZ_System__c();
        System3.Name='BAYSTATE HEALTH';
        System3.Global_IDs__c = '2096075';
        System3.Aligned_Districts__c = 'MA IHS DISTRICT';
        System3.Aligned_Territories__c = 'ALLINA MN IH Specialist';
        System3.System_ID__c='TestSystem3';
        SystemList.add(System3);
        
        insert SystemList;
        
        List<MYBZ_PGP__c> PGPList = new List<MYBZ_PGP__c>();
        MYBZ_PGP__c PGP1 = new MYBZ_PGP__c();
        PGP1.System__c = SystemList[0].id;
        PGP1.Aligned_Districts__c = 'MA IHS DISTRICT';
        PGP1.Aligned_Territories__c = 'ALLINA MN IH Specialist';
        PGP1.PGP_ID__c = 'TestPGP1';
        PGPList.add(PGP1);
        
        MYBZ_PGP__c PGP2 = new MYBZ_PGP__c();
        PGP2.System__c = SystemList[1].id;
        PGP2.Aligned_Districts__c = 'MA IHS DISTRICT';
        PGP2.Aligned_Territories__c = 'ALLINA MN IH Specialist';
        PGP2.PGP_ID__c = 'TestPGP2';
        PGPList.add(PGP2);
        
        MYBZ_PGP__c PGP3 = new MYBZ_PGP__c();
        PGP3.System__c = SystemList[2].id;
        PGP3.Aligned_Districts__c = 'MA IHS DISTRICT';
        PGP3.Aligned_Territories__c = 'ALLINA MN IH Specialist';
        PGP3.PGP_ID__c = 'TestPGP3';
        PGPList.add(PGP3);
        
        insert PGPList;
        
        
        MYBZ_Call_Planning__c CallPlanning = New MYBZ_Call_Planning__c();
        CallPlanning.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning.Global_ID__c='2016016';
        CallPlanning.IHS_PGP_HCP_Level__c='System';
        CallPlanning.LE_ID_IHS__c='TestSystem1';
        CallPlanning.LoadIdentifier__c='AFFLTN';
        CallPlanning.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning.System__c=SystemList[0].id;
        CallPlanning.Territory__c=Territory.ID; 
        Insert CallPlanning;
        system.assert(CallPlanning.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning1 = New MYBZ_Call_Planning__c();
        CallPlanning1.Global_ID__c='2016016';
        CallPlanning1.IHS_PGP_HCP_Level__c='System';
        CallPlanning1.LE_ID_IHS__c='TestSystem2';
        CallPlanning1.LoadIdentifier__c='AFFLTN';
        CallPlanning1.System__c=SystemList[1].id;
        CallPlanning1.Territory__c=Territory.ID; 
        Insert CallPlanning1;
        system.assert(CallPlanning1.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning2 = New MYBZ_Call_Planning__c();
        CallPlanning2.Global_ID__c='2016016';
        CallPlanning2.IHS_PGP_HCP_Level__c='PGP';
        CallPlanning2.LE_ID_IHS__c='TestSystem1';
        CallPlanning2.LE_ID_PGP__c='TestPGP1';
        CallPlanning2.LoadIdentifier__c='AFFLTN';
        CallPlanning2.PGP__c=PGPList[0].id;
        CallPlanning2.Subtype__c='Clinic';
        CallPlanning2.System__c=SystemList[0].id;
        CallPlanning2.Territory__c=Territory.id;
        Insert CallPlanning2;
        system.assert(CallPlanning2.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning11 = New MYBZ_Call_Planning__c();
        CallPlanning11.Global_ID__c='2096075';
        CallPlanning11.IHS_PGP_HCP_Level__c='System';
        CallPlanning11.LE_ID_IHS__c='TestSystem3';
        CallPlanning11.LoadIdentifier__c='AFFLTN';
        CallPlanning11.System__c=SystemList[2].id;
        CallPlanning11.Territory__c=Territory.ID; 
        Insert CallPlanning11;
        system.assert(CallPlanning11.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning12 = New MYBZ_Call_Planning__c();
        CallPlanning12.Global_ID__c='2096075';
        CallPlanning12.IHS_PGP_HCP_Level__c='PGP';
        CallPlanning12.LE_ID_IHS__c='TestSystem3';
        CallPlanning12.LE_ID_PGP__c='TestPGP3';
        CallPlanning12.LoadIdentifier__c='AFFLTN';
        CallPlanning12.PGP__c=PGPList[2].id;
        CallPlanning12.Subtype__c='Clinic';
        CallPlanning12.System__c=SystemList[2].id;
        CallPlanning12.Territory__c=Territory.id;
        Insert CallPlanning12;
        system.assert(CallPlanning12.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning8 = New MYBZ_Call_Planning__c();
        CallPlanning8.Global_ID__c='2016016';
        CallPlanning8.IHS_PGP_HCP_Level__c='PGP';
        CallPlanning8.LE_ID_IHS__c='TestSystem1';
        CallPlanning8.LE_ID_PGP__c='TestPGP2';
        CallPlanning8.LoadIdentifier__c='AFFLTN';
        CallPlanning8.PGP__c=PGPList[1].id;
        CallPlanning8.System__c=SystemList[0].id;
        CallPlanning8.Territory__c=Territory.id;
        Insert CallPlanning8;
        system.assert(CallPlanning8.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning3 = New MYBZ_Call_Planning__c();
        CallPlanning3.Global_ID__c='2016016';
        CallPlanning3.IHS_PGP_HCP_Level__c='PGP';
        CallPlanning3.LE_ID_IHS__c='TestSystem2';
        CallPlanning3.LE_ID_PGP__c='TestPGP2';
        CallPlanning3.LoadIdentifier__c='AFFLTN';
        CallPlanning3.PGP__c=PGPList[1].id;
        CallPlanning3.Subtype__c='Clinic';
        CallPlanning3.System__c=SystemList[1].id;
        CallPlanning3.Territory__c=Territory.id;
        Insert CallPlanning3;
        system.assert(CallPlanning3.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning4 = New MYBZ_Call_Planning__c();
        CallPlanning4.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning4.First_Name__c='FN1';
        CallPlanning4.Global_ID__c='2016016';
        CallPlanning4.IHS_PGP_HCP_Level__c='HCP';
        CallPlanning4.Last_Name__c='LN1';
        CallPlanning4.LE_ID_IHS__c='TestSystem1';
        CallPlanning4.LE_ID_PGP__c='TestPGP1';
        CallPlanning4.LoadIdentifier__c='AFFLTN';
        CallPlanning4.PGP__c=PGPList[0].id;
        CallPlanning4.Physician_ID__c='AAA';
        CallPlanning4.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning4.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning4.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning4.System__c=SystemList[0].id;
        CallPlanning4.Territory__c=Territory.id;
        CallPlanning4.Tier__c=1;
        Insert CallPlanning4;
        system.assert(CallPlanning4.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning5 = New MYBZ_Call_Planning__c();
        CallPlanning5.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning5.First_Name__c='FN2';
        CallPlanning5.Global_ID__c='2016016';
        CallPlanning5.IHS_PGP_HCP_Level__c='HCP';
        CallPlanning5.Last_Name__c='LN2';
        CallPlanning5.LE_ID_IHS__c='TestSystem1';
        CallPlanning5.LE_ID_PGP__c='TestPGP1';
        CallPlanning5.LoadIdentifier__c='AFFLTN';
        CallPlanning5.PGP__c=PGPList[0].id;
        CallPlanning5.Physician_ID__c='BBB';
        CallPlanning5.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning5.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning5.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning5.System__c=SystemList[0].id;
        CallPlanning5.Territory__c=Territory.id;
        CallPlanning5.Tier__c=1;
        Insert CallPlanning5;
        system.assert(CallPlanning5.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning6 = New MYBZ_Call_Planning__c();
        CallPlanning6.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning6.First_Name__c='FN3';
        CallPlanning6.Global_ID__c='2016016';
        CallPlanning6.IHS_PGP_HCP_Level__c='HCP';
        CallPlanning6.Last_Name__c='LN3';
        CallPlanning6.LE_ID_IHS__c='TestSystem2';
        CallPlanning6.LE_ID_PGP__c='TestPGP2';
        CallPlanning6.LoadIdentifier__c='AFFLTN';
        CallPlanning6.PGP__c=PGPList[1].id;
        CallPlanning6.Physician_ID__c='CCC';
        CallPlanning6.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning6.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning6.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning6.System__c=SystemList[1].id;
        CallPlanning6.Territory__c=Territory.id;
        CallPlanning6.Tier__c=1;
        Insert CallPlanning6;
        system.assert(CallPlanning6.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning7 = New MYBZ_Call_Planning__c();
        CallPlanning7.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.First_Name__c='FN4';
        CallPlanning7.Global_ID__c='2016016';
        CallPlanning7.IHS_PGP_HCP_Level__c='HCP';
        CallPlanning7.Last_Name__c='LN4';
        CallPlanning7.LE_ID_IHS__c='TestSystem2';
        CallPlanning7.LE_ID_PGP__c='TestPGP2';
        CallPlanning7.LoadIdentifier__c='AFFLTN';
        CallPlanning7.PGP__c=PGPList[1].id;
        CallPlanning7.Physician_ID__c='DDD';
        CallPlanning7.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning7.System__c=SystemList[1].id;
        CallPlanning7.Territory__c=Territory.id;
        CallPlanning7.Tier__c=1;
        Insert CallPlanning7;
        system.assert(CallPlanning7.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning9 = New MYBZ_Call_Planning__c();
        CallPlanning9.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning9.First_Name__c='FN5';
        CallPlanning9.Global_ID__c='2016016';
        CallPlanning9.IHS_PGP_HCP_Level__c='HCP';
        CallPlanning9.Last_Name__c='LN5';
        CallPlanning9.LE_ID_IHS__c='TestSystem1';
        CallPlanning9.LE_ID_PGP__c='TestPGP2';
        CallPlanning9.LoadIdentifier__c='AFFLTN';
        CallPlanning9.PGP__c=PGPList[1].id;
        CallPlanning9.Physician_ID__c='DDD';
        CallPlanning9.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning9.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning9.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning9.System__c=SystemList[0].id;
        CallPlanning9.Territory__c=Territory.id;
        CallPlanning9.Tier__c=1;
        Insert CallPlanning9;
        system.assert(CallPlanning9.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning10 = New MYBZ_Call_Planning__c();
        CallPlanning10.Data_Load_Date__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning10.First_Name__c='FN6';
        CallPlanning10.Global_ID__c='2016016';
        CallPlanning10.IHS_PGP_HCP_Level__c='HCP';
        CallPlanning10.Last_Name__c='LN6';
        CallPlanning10.LE_ID_IHS__c='TestSystem1';
        CallPlanning10.LE_ID_PGP__c='TestPGP2';
        CallPlanning10.LoadIdentifier__c='AFFLTN';
        CallPlanning10.PGP__c=PGPList[1].id;
        CallPlanning10.Physician_ID__c='DDD';
        CallPlanning10.Start_Date_1M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning10.Start_Date_3M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning10.Start_Date_6M__c=DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning10.System__c=SystemList[0].id;
        CallPlanning10.Territory__c=Territory.id;
        CallPlanning10.Tier__c=1;
        Insert CallPlanning10;
        system.assert(CallPlanning10.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning13 = New MYBZ_Call_Planning__c();
        CallPlanning13.First_Name__c='FN7';
        CallPlanning13.Global_ID__c='2096075';
        CallPlanning13.IHS_PGP_HCP_Level__c='HCP';
        CallPlanning13.Last_Name__c='LN7';
        CallPlanning13.LE_ID_IHS__c='TestSystem3';
        CallPlanning13.LE_ID_PGP__c='TestPGP3';
        CallPlanning13.LoadIdentifier__c='AFFLTN';
        CallPlanning13.PGP__c=PGPList[2].id;
        CallPlanning13.Physician_ID__c='EEE';
        CallPlanning13.System__c=SystemList[2].id;
        CallPlanning13.Territory__c=Territory.id;
        Insert CallPlanning13;
        system.assert(CallPlanning13.id!=null);
        
        List<MYBZ_CallPlanningProductJunction__c> lstCallPlanningProductJunction = new List<MYBZ_CallPlanningProductJunction__c>();         
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction1 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction1.Call_Planning__c = CallPlanning.id;
        CallPlanningJunction1.Product__c = IHSProduct.id;
        CallPlanningJunction1.TRx_Units_1M__c = 1;
        CallPlanningJunction1.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction1.TRx_Units_3M__c = 1;
        CallPlanningJunction1.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction1.TRx_Units_6M__c = 1;
        CallPlanningJunction1.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction1);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction2 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction2.Call_Planning__c = CallPlanning.id;
        CallPlanningJunction2.Product__c = IHSProduct2.id;
        CallPlanningJunction2.TRx_Units_1M__c = 1;
        CallPlanningJunction2.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction2.TRx_Units_3M__c = 1;
        CallPlanningJunction2.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction2.TRx_Units_6M__c = 1;
        CallPlanningJunction2.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction2);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction3 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction3.Call_Planning__c = CallPlanning1.id;
        CallPlanningJunction3.Product__c = IHSProduct2.id;
        CallPlanningJunction3.TRx_Units_1M__c = 1;
        CallPlanningJunction3.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction3.TRx_Units_3M__c = 1;
        CallPlanningJunction3.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction3.TRx_Units_6M__c = 1;
        CallPlanningJunction3.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction3);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction4 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction4.Call_Planning__c = CallPlanning1.id;
        CallPlanningJunction4.Product__c = IHSProduct.id;
        CallPlanningJunction4.TRx_Units_1M__c = 1;
        CallPlanningJunction4.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction4.TRx_Units_3M__c = 1;
        CallPlanningJunction4.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction4.TRx_Units_6M__c = 1;
        CallPlanningJunction4.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction4);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction20 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction20.Call_Planning__c = CallPlanning1.id;
        CallPlanningJunction20.TRx_Units_1M__c = 1;
        CallPlanningJunction20.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction20.TRx_Units_3M__c = 1;
        CallPlanningJunction20.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction20.TRx_Units_6M__c = 1;
        CallPlanningJunction20.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction20);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction5 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction5.Call_Planning__c = CallPlanning2.id;
        CallPlanningJunction5.Product__c = IHSProduct.id;
        CallPlanningJunction5.TRx_Units_1M__c = 1;
        CallPlanningJunction5.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction5.TRx_Units_3M__c = 1;
        CallPlanningJunction5.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction5.TRx_Units_6M__c = 1;
        CallPlanningJunction5.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction5);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction6 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction6.Call_Planning__c = CallPlanning2.id;
        CallPlanningJunction6.Product__c = IHSProduct2.id;
        CallPlanningJunction6.TRx_Units_1M__c = 1;
        CallPlanningJunction6.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction6.TRx_Units_3M__c = 1;
        CallPlanningJunction6.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction6.TRx_Units_6M__c = 1;
        CallPlanningJunction6.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction6);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction7 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction7.Call_Planning__c = CallPlanning3.id;
        CallPlanningJunction7.Product__c = IHSProduct.id;
        CallPlanningJunction7.TRx_Units_1M__c = 1;
        CallPlanningJunction7.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction7.TRx_Units_3M__c = 1;
        CallPlanningJunction7.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction7.TRx_Units_6M__c = 1;
        CallPlanningJunction7.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction7);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction8 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction8.Call_Planning__c = CallPlanning3.id;
        CallPlanningJunction8.Product__c = IHSProduct2.id;
        CallPlanningJunction8.TRx_Units_1M__c = 1;
        CallPlanningJunction8.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction8.TRx_Units_3M__c = 1;
        CallPlanningJunction8.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction8.TRx_Units_6M__c = 1;
        CallPlanningJunction8.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(CallPlanningJunction8);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction10 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction10.Call_Planning__c = CallPlanning4.id;
        CallPlanningJunction10.Product__c = IHSProduct.id;
        CallPlanningJunction10.TRx_Units_1M__c = 1;
        CallPlanningJunction10.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction10.TRx_Units_3M__c = 1;
        CallPlanningJunction10.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction10.TRx_Units_6M__c = 1;
        CallPlanningJunction10.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction10.Physician_ID__c ='AAA';
        lstCallPlanningProductJunction.add(CallPlanningJunction10);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction11 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction11.Call_Planning__c = CallPlanning4.id;
        CallPlanningJunction11.Product__c = IHSProduct2.id;
        CallPlanningJunction11.TRx_Units_1M__c = 1;
        CallPlanningJunction11.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction11.TRx_Units_3M__c = 1;
        CallPlanningJunction11.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction11.TRx_Units_6M__c = 1;
        CallPlanningJunction11.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction11.Physician_ID__c ='AAA';
        lstCallPlanningProductJunction.add(CallPlanningJunction11);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction12 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction12.Call_Planning__c = CallPlanning4.id;
        CallPlanningJunction12.TRx_Units_1M__c = 1;
        CallPlanningJunction12.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction12.TRx_Units_3M__c = 1;
        CallPlanningJunction12.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction12.TRx_Units_6M__c = 1;
        CallPlanningJunction12.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction12.Physician_ID__c ='AAA';
        lstCallPlanningProductJunction.add(CallPlanningJunction12);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction13 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction13.Call_Planning__c = CallPlanning5.id;
        CallPlanningJunction13.Product__c = IHSProduct.id;
        CallPlanningJunction13.TRx_Units_1M__c = 1;
        CallPlanningJunction13.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction13.TRx_Units_3M__c = 1;
        CallPlanningJunction13.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction13.TRx_Units_6M__c = 1;
        CallPlanningJunction13.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction13.Physician_ID__c ='BBB';
        lstCallPlanningProductJunction.add(CallPlanningJunction13);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction14 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction14.Call_Planning__c = CallPlanning5.id;
        CallPlanningJunction14.Product__c = IHSProduct2.id;
        CallPlanningJunction14.TRx_Units_1M__c = 1;
        CallPlanningJunction14.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction14.TRx_Units_3M__c = 1;
        CallPlanningJunction14.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction14.TRx_Units_6M__c = 1;
        CallPlanningJunction14.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction14.Physician_ID__c ='BBB';
        lstCallPlanningProductJunction.add(CallPlanningJunction14);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction15 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction15.Call_Planning__c = CallPlanning5.id;
        CallPlanningJunction15.TRx_Units_1M__c = 1;
        CallPlanningJunction15.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction15.TRx_Units_3M__c = 1;
        CallPlanningJunction15.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction15.TRx_Units_6M__c = 1;
        CallPlanningJunction15.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction15.Physician_ID__c ='BBB';
        lstCallPlanningProductJunction.add(CallPlanningJunction15);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction16 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction16.Call_Planning__c = CallPlanning6.id;
        CallPlanningJunction16.Product__c = IHSProduct.id;
        CallPlanningJunction16.TRx_Units_1M__c = 1;
        CallPlanningJunction16.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction16.TRx_Units_3M__c = 1;
        CallPlanningJunction16.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction16.TRx_Units_6M__c = 1;
        CallPlanningJunction16.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction16.Physician_ID__c ='CCC';
        lstCallPlanningProductJunction.add(CallPlanningJunction16);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction17 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction17.Call_Planning__c = CallPlanning6.id;
        CallPlanningJunction17.Product__c = IHSProduct2.id;
        CallPlanningJunction17.TRx_Units_1M__c = 1;
        CallPlanningJunction17.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction17.TRx_Units_3M__c = 1;
        CallPlanningJunction17.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction17.TRx_Units_6M__c = 1;
        CallPlanningJunction17.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction17.Physician_ID__c ='CCC';
        lstCallPlanningProductJunction.add(CallPlanningJunction17);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction18 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction18.Call_Planning__c = CallPlanning7.id;
        CallPlanningJunction18.Product__c = IHSProduct.id;
        CallPlanningJunction18.TRx_Units_1M__c = 1;
        CallPlanningJunction18.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction18.TRx_Units_3M__c = 1;
        CallPlanningJunction18.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction18.TRx_Units_6M__c = 1;
        CallPlanningJunction18.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction18.Physician_ID__c ='DDD';
        lstCallPlanningProductJunction.add(CallPlanningJunction18);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction19 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction19.Call_Planning__c = CallPlanning7.id;
        CallPlanningJunction19.Product__c = IHSProduct2.id;
        CallPlanningJunction19.TRx_Units_1M__c = 1;
        CallPlanningJunction19.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction19.TRx_Units_3M__c = 1;
        CallPlanningJunction19.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction19.TRx_Units_6M__c = 1;
        CallPlanningJunction19.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction19.Physician_ID__c ='DDD';
        lstCallPlanningProductJunction.add(CallPlanningJunction19);
        
         MYBZ_CallPlanningProductJunction__c  CallPlanningJunction24 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction24.Call_Planning__c = CallPlanning8.id;
        CallPlanningJunction24.Product__c = IHSProduct2.id;
        CallPlanningJunction24.TRx_Units_1M__c = 1;
        CallPlanningJunction24.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction24.TRx_Units_3M__c = 1;
        CallPlanningJunction24.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction24.TRx_Units_6M__c = 1;
        CallPlanningJunction24.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction24.Physician_ID__c ='DDD';
        lstCallPlanningProductJunction.add(CallPlanningJunction24);
        
         MYBZ_CallPlanningProductJunction__c  CallPlanningJunction23 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction23.Call_Planning__c = CallPlanning8.id;
        CallPlanningJunction23.TRx_Units_1M__c = 1;
        CallPlanningJunction23.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction23.TRx_Units_3M__c = 1;
        CallPlanningJunction23.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction23.TRx_Units_6M__c = 1;
        CallPlanningJunction23.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction23.Physician_ID__c ='DDD';
        lstCallPlanningProductJunction.add(CallPlanningJunction23);
        
         MYBZ_CallPlanningProductJunction__c  CallPlanningJunction21 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction21.Call_Planning__c = CallPlanning9.id;
        CallPlanningJunction21.Product__c = IHSProduct2.id;
        CallPlanningJunction21.TRx_Units_1M__c = 1;
        CallPlanningJunction21.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction21.TRx_Units_3M__c = 1;
        CallPlanningJunction21.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction21.TRx_Units_6M__c = 1;
        CallPlanningJunction21.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction21.Physician_ID__c ='DDD';
        lstCallPlanningProductJunction.add(CallPlanningJunction21);
        
         MYBZ_CallPlanningProductJunction__c  CallPlanningJunction22 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction22.Call_Planning__c = CallPlanning10.id;
        CallPlanningJunction22.Product__c = IHSProduct2.id;
        CallPlanningJunction22.TRx_Units_1M__c = 1;
        CallPlanningJunction22.Previous_TRx_Units_1M__c = 1;
        CallPlanningJunction22.TRx_Units_3M__c = 1;
        CallPlanningJunction22.Previous_TRx_Units_3M__c = 1;
        CallPlanningJunction22.TRx_Units_6M__c = 1;
        CallPlanningJunction22.Previous_TRx_Units_6M__c = 1;
        CallPlanningJunction22.Physician_ID__c ='DDD';
        lstCallPlanningProductJunction.add(CallPlanningJunction22);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction29 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction29.Call_Planning__c = CallPlanning11.id;
        lstCallPlanningProductJunction.add(CallPlanningJunction29);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction30 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction30.Call_Planning__c = CallPlanning11.id;
        CallPlanningJunction30.Product__c = IHSProduct2.id;
        CallPlanningJunction30.TRx_Units_1M__c = 1;
        CallPlanningJunction30.Previous_TRx_Units_1M__c = 0;
        CallPlanningJunction30.TRx_Units_3M__c = 1;
        CallPlanningJunction30.Previous_TRx_Units_3M__c = 0;
        CallPlanningJunction30.TRx_Units_6M__c = 1;
        CallPlanningJunction30.Previous_TRx_Units_6M__c = 0;
        lstCallPlanningProductJunction.add(CallPlanningJunction30);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction25 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction25.Call_Planning__c = CallPlanning12.id;
        lstCallPlanningProductJunction.add(CallPlanningJunction25);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction26 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction26.Call_Planning__c = CallPlanning12.id;
        CallPlanningJunction26.Product__c = IHSProduct2.id;
        CallPlanningJunction26.TRx_Units_1M__c = 1;
        CallPlanningJunction26.Previous_TRx_Units_1M__c = 0;
        CallPlanningJunction26.TRx_Units_3M__c = 1;
        CallPlanningJunction26.Previous_TRx_Units_3M__c = 0;
        CallPlanningJunction26.TRx_Units_6M__c = 1;
        CallPlanningJunction26.Previous_TRx_Units_6M__c = 0;
        lstCallPlanningProductJunction.add(CallPlanningJunction26);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction27 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction27.Call_Planning__c = CallPlanning13.id;
        CallPlanningJunction27.Physician_ID__c ='EEE';
        lstCallPlanningProductJunction.add(CallPlanningJunction27);
        
        MYBZ_CallPlanningProductJunction__c  CallPlanningJunction28 = new MYBZ_CallPlanningProductJunction__c();
        CallPlanningJunction28.Call_Planning__c = CallPlanning13.id;
        CallPlanningJunction28.Physician_ID__c ='EEE';
        CallPlanningJunction28.Product__c = IHSProduct2.id;
        CallPlanningJunction28.TRx_Units_1M__c = 1;
        CallPlanningJunction28.Previous_TRx_Units_1M__c = 0;
        CallPlanningJunction28.TRx_Units_3M__c = 1;
        CallPlanningJunction28.Previous_TRx_Units_3M__c = 0;
        CallPlanningJunction28.TRx_Units_6M__c = 1;
        CallPlanningJunction28.Previous_TRx_Units_6M__c = 0;
        lstCallPlanningProductJunction.add(CallPlanningJunction28);
        
        insert lstCallPlanningProductJunction;
        
        MYBZ_Call__c Call = New MYBZ_Call__c();
        Call.Call_Date__c=null;
        Call.Call_Type__c='Test';
        Call.First_Name__c='FirstName';
        Call.Last_Name__c='LastName';
        Call.Product__c=IHSProduct.ID; 
        Call.Global_ID__c='2016016';
        Call.Product_Position__c=1;
        Call.Territory__c=Territory.ID;
        Call.Name='Test';
        Call.Physician_ID__c = 'AAA';
        Call.Call_ID__c='A101';
        Call.Range__c='6M';
        Call.LE_ID_IHS__c='TestSystem1';
        Call.LE_ID_PGP__c='TestPGP1';
        Call.PGP__c=PGPList[0].id;
        Call.System__c=SystemList[0].id;
        Call.LoadIdentifier__c='AFFLTN';
        Insert Call;
        system.assert(Call.id!=null);
        
        MYBZ_Call__c Call1 = New MYBZ_Call__c();
        Call1.Call_Date__c=null;
        Call1.Call_Type__c='Test';
        Call1.First_Name__c='FirstName';
        Call1.Last_Name__c='LastName';
        Call1.Product__c=IHSProduct2.ID; 
        Call1.Global_ID__c='2016016';
        Call1.Product_Position__c=2;
        Call1.Territory__c=Territory.ID;
        Call1.Name='Test';
        Call1.Physician_ID__c = 'AAA';
        Call1.Call_ID__c='A101';
        Call1.Range__c='6M';
        Call1.LE_ID_IHS__c='TestSystem1';
        Call1.LE_ID_PGP__c='TestPGP1';
        Call1.PGP__c=PGPList[0].id;
        Call1.System__c=SystemList[0].id;
        Call1.LoadIdentifier__c='AFFLTN';
        Insert Call1;
        system.assert(Call1.id!=null);
        
        MYBZ_Call__c Call2 = New MYBZ_Call__c();
        Call2.Call_Date__c=null;
        Call2.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call2.First_Name__c='FirstName';
        Call2.Last_Name__c='LastName';
        Call2.Product__c=IHSProduct.ID; 
        Call2.Global_ID__c='2016016';
        Call2.Product_Position__c=1;
        Call2.Territory__c=Territory.ID;
        Call2.Name='Test';
        Call2.Physician_ID__c = 'AAA';
        Call2.Call_ID__c='A102';
        Call2.Range__c='6M';
        Call2.LE_ID_IHS__c='TestSystem1';
        Call2.LE_ID_PGP__c='TestPGP1';
        Call2.PGP__c=PGPList[0].id;
        Call2.System__c=SystemList[0].id;
        Call2.LoadIdentifier__c='AFFLTN';
        Insert Call2;
        system.assert(Call2.id!=null);
        
        MYBZ_Call__c Call3 = New MYBZ_Call__c();
        Call3.Call_Date__c=null;
        Call3.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call3.First_Name__c='FirstName';
        Call3.Last_Name__c='LastName';
        Call3.Product__c=IHSProduct2.ID; 
        Call3.Global_ID__c='2016016';
        Call3.Product_Position__c=2;
        Call3.Territory__c=Territory.ID;
        Call3.Name='Test';
        Call3.Physician_ID__c = 'AAA';
        Call3.Call_ID__c='A102';
        Call3.Range__c='6M';
        Call3.LE_ID_IHS__c='TestSystem1';
        Call3.LE_ID_PGP__c='TestPGP1';
        Call3.PGP__c=PGPList[0].id;
        Call3.System__c=SystemList[0].id;
        Call3.LoadIdentifier__c='AFFLTN';
        Insert Call3;
        system.assert(Call3.id!=null);
        
        MYBZ_Call__c Call4 = New MYBZ_Call__c();
        Call4.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call4.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call4.Product__c=IHSProduct2.ID; 
        Call4.Global_ID__c='2016016';
        Call4.Product_Position__c=2;
        Call4.Territory__c=Territory2.ID;
        Call4.Name='Test';
        Call4.Physician_ID__c = 'BBB';
        Call4.Call_ID__c='A103';
        Call4.Range__c='6M';
        Call4.LE_ID_IHS__c='TestSystem1';
        Call4.LE_ID_PGP__c='TestPGP2';
        Call4.PGP__c=PGPList[1].id;
        Call4.System__c=SystemList[0].id;
        Call4.LoadIdentifier__c='AFFLTN';
        Insert Call4;
        system.assert(Call4.id!=null);  
        
        MYBZ_Call__c Call5 = New MYBZ_Call__c();
        Call5.Call_Date__c=null;
        Call5.Call_Type__c='Test';
        Call5.First_Name__c='FirstName';
        Call5.Last_Name__c='LastName';
        Call5.Product__c=IHSProduct.ID; 
        Call5.Global_ID__c='2016016';
        Call5.Product_Position__c=1;
        Call5.Territory__c=Territory.ID;
        Call5.Name='Test';
        Call5.Physician_ID__c = 'BBB';
        Call5.Call_ID__c='A100';
        Call5.Range__c='6M';
        Call5.LE_ID_IHS__c='TestSystem1';
        Call5.LE_ID_PGP__c='TestPGP2';
        Call5.PGP__c=PGPList[1].id;
        Call5.System__c=SystemList[0].id;
        Call5.LoadIdentifier__c='AFFLTN';
        Insert Call5;
        system.assert(Call5.id!=null);
        
                MYBZ_Call__c Call6 = New MYBZ_Call__c();
        Call6.Call_Date__c=null;
        Call6.Call_Type__c='Test';
        Call6.First_Name__c='FirstName';
        Call6.Last_Name__c='LastName';
        Call6.Product__c=IHSProduct.ID; 
        Call6.Global_ID__c='2016016';
        Call6.Product_Position__c=1;
        Call6.Territory__c=Territory.ID;
        Call6.Name='Test';
        Call6.Physician_ID__c = 'BBB';
        Call6.Call_ID__c='A104';
        Call6.Range__c='6M';
        Call6.LE_ID_IHS__c='TestSystem1';
        Call6.LE_ID_PGP__c='TestPGP2';
        Call6.PGP__c=PGPList[1].id;
        Call6.System__c=SystemList[0].id;
        Call6.LoadIdentifier__c='AFFLTN';
        Insert Call6;
        system.assert(Call6.id!=null);
        
        MYBZ_Call__c Call7 = New MYBZ_Call__c();
        Call7.Call_Date__c=null;
        Call7.Call_Type__c='Test';
        Call7.First_Name__c='FirstName';
        Call7.Last_Name__c='LastName';
        Call7.Product__c=IHSProduct.ID; 
        Call7.Global_ID__c='2016016';
        Call7.Product_Position__c=1;
        Call7.Territory__c=Territory.ID;
        Call7.Name='Test';
        Call7.Physician_ID__c = 'BBB';
        Call7.Call_ID__c='A105';
        Call7.Range__c='6M';
        Call7.LE_ID_IHS__c='TestSystem1';
        Call7.LE_ID_PGP__c='TestPGP2';
        Call7.PGP__c=PGPList[1].id;
        Call7.System__c=SystemList[0].id;
        Call7.LoadIdentifier__c='AFFLTN';
        Insert Call7;
        system.assert(Call7.id!=null);
        
        MYBZ_Call__c Call8 = New MYBZ_Call__c();
        Call8.Call_Date__c=null;
        Call8.Call_Type__c='Test';
        Call8.First_Name__c='FirstName';
        Call8.Last_Name__c='LastName';
        Call8.Product__c=IHSProduct.ID; 
        Call8.Global_ID__c='2016016';
        Call8.Product_Position__c=1;
        Call8.Territory__c=Territory.ID;
        Call8.Name='Test';
        Call8.Physician_ID__c = 'BBB';
        Call8.Call_ID__c='A106';
        Call8.Range__c='6M';
        Call8.LE_ID_IHS__c='TestSystem1';
        Call8.LE_ID_PGP__c='TestPGP2';
        Call8.PGP__c=PGPList[1].id;
        Call8.System__c=SystemList[0].id;
        Call8.LoadIdentifier__c='AFFLTN';
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
        Call9.Territory__c=Territory.ID;
        Call9.Name='Test';
        Call9.Physician_ID__c = 'BBB';
        Call9.Call_ID__c='A107';
        Call9.Range__c='6M';
        Call9.LE_ID_IHS__c='TestSystem1';
        Call9.LE_ID_PGP__c='TestPGP2';
        Call9.PGP__c=PGPList[1].id;
        Call9.System__c=SystemList[0].id;
        Call9.LoadIdentifier__c='AFFLTN';
        Insert Call9;
        system.assert(Call9.id!=null);
        
        MYBZ_Call__c Call10 = New MYBZ_Call__c();
        Call10.Call_Type__c='Test';
        Call10.First_Name__c='FirstName';
        Call10.Last_Name__c='LastName';
        Call10.Product__c=IHSProduct2.ID; 
        Call10.Global_ID__c='2096075';
        Call10.Product_Position__c=2;
        Call10.Territory__c=Territory.ID;
        Call10.Name='Test';
        Call10.Physician_ID__c = 'EEE';
        Call10.Call_ID__c='A108';
        Call10.Range__c='6M';
        Call10.LE_ID_IHS__c='TestSystem3';
        Call10.LE_ID_PGP__c='TestPGP3';
        Call10.PGP__c=PGPList[2].id;
        Call10.System__c=SystemList[2].id;
        Call10.LoadIdentifier__c='AFFLTN';
        Insert Call10;
        system.assert(Call10.id!=null);
        
    }

     /*
    * @Method Name                    :  testAsSalesRepAlignment
    * @Description                    :  method to test as Sales Representative(Role) generation of JSONS for Callplanning Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSalesRepAlignment() {
        String jsonrespasString;
         User runAsUser = createUserToRun(System.Label.MYBZ_SalesRepresentative, '2016016');  
        
        System.runas(runAsUser){ 
        
            // Insertion of Test Data
            insertTestDataCallPlanning();
        
        }
        System.runas(runAsUser){ 
            Test.startTest();
               Obj=MYBZ_CallPlanningController.callPlanningAffiliationView('TestSystem1','', Territory.Name);
               jsonrespasString = Obj+'';
               //Assertion to Check whether the generated JSON contains the Test data related to Call Planning
               system.assert(jsonrespasString.contains('05/20/2015'));             
               system.assert(jsonrespasString.contains('ATRIUS HEALTH'));
               system.assert(jsonrespasString.contains('EFFIENT'));
               Obj=MYBZ_CallPlanningController.callPlanningAffiliationView( '','TestPGP1', Territory.Name);
               jsonrespasString = Obj+'';
               //Assertion to Check whether the generated JSON contains the Test data related to Call Planning
               system.assert(jsonrespasString.contains('05/20/2015'));             
               system.assert(jsonrespasString.contains('ATRIUS HEALTH'));
               system.assert(jsonrespasString.contains('FORTEO'));
               Test.stopTest();
        }
     }
     
     static testMethod void testAsSalesRepAlignment2() {
        String jsonrespasString;
         User runAsUser = createUserToRun(System.Label.MYBZ_SalesRepresentative, '2096075');  
        
        System.runas(runAsUser){ 
            // Insertion of Test Data
            insertTestDataCallPlanning();
        }
        System.runas(runAsUser){ 
            Test.startTest();
               Obj=MYBZ_CallPlanningController.callPlanningAffiliationView('','','');
               jsonrespasString = Obj+'';
               //Assertion to Check whether the generated JSON contains the Test data related to Call Planning
               system.assert(jsonrespasString.contains('dataLoadDate=null'));
               system.assert(jsonrespasString.contains('startDate6Month=null'));
               system.assert(jsonrespasString.contains('scriptsWrittenPastMonth=null'));               
               Test.stopTest();
        }
     }
     
     static testMethod void testAsSuperUserAlignment() {
        String jsonrespasString;
        User runAsUser = createUserToRun(System.Label.MYBZ_SuperUser, '');  
        
        System.runas(runAsUser){ 
        
            // Insertion of Test Data
            insertTestDataCallPlanning();
        
        }
        System.runas(runAsUser){ 
            Test.startTest();
               Obj=MYBZ_CallPlanningController.callPlanningAffiliationView('','',Territory.Name);
               jsonrespasString = Obj+'';
               //Assertion to Check whether the generated JSON contains the Test data related to Call Planning
               system.assert(jsonrespasString.contains('type=Sample Only'));
               system.assert(jsonrespasString.contains('name=FN1 LN1'));
               Obj=MYBZ_CallPlanningController.callPlanningAffiliationView('TestSystem1','', Territory.Name);
               jsonrespasString = Obj+'';           
               //Assertion to Check whether the generated JSON contains the Test data related to Call Planning
               system.assert(jsonrespasString.contains('startDate1Month=05/20/2015'));
               system.assert(jsonrespasString.contains('name=FORTEO'));
               system.assert(jsonrespasString.contains('tier=1'));
               Obj=MYBZ_CallPlanningController.callPlanningAffiliationView( '','TestPGP1', Territory.Name);
               jsonrespasString = Obj+'';
               //Assertion to Check whether the generated JSON contains the Test data related to Call Planning
               system.assert(jsonrespasString.contains('dataLoadDate=05/20/2015'));
               system.assert(jsonrespasString.contains('product1=EFFIENT'));
               system.assert(jsonrespasString.contains('type=Test'));
               Test.stopTest();
        }
     }
     
     

}