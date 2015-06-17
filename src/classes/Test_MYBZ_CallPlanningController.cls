@isTest
private class Test_MYBZ_CallPlanningController {
    
    static MYBZ_Region__c Region = New MYBZ_Region__c();
    static MYBZ_Region__c Region1 = New MYBZ_Region__c();
    static MYBZ_District__c District = New MYBZ_District__c();
    static MYBZ_District__c District1 = New MYBZ_District__c();
    static MYBZ_Territory__c Territory = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory2 = New MYBZ_Territory__c();
    static MYBZ_Territory__c Territory3 = New MYBZ_Territory__c();
    static Object Obj;
    
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
        
        Region1.Name='PAC NW';
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
        PGP1.Aligned_Districts__c = 'MA IHS DISTRICT';
        PGP1.Aligned_Territories__c = 'CAREGROUP MA IH Partner 125395';
        PGP1.PGP_ID__c = 'Test PGP';
        PGPList.add(PGP1);
        
        MYBZ_PGP__c PGP2 = new MYBZ_PGP__c();
        PGP2.System__c = SystemList[0].id;
        PGP2.Aligned_Districts__c = 'MA IHS DISTRICT';
        PGP2.Aligned_Territories__c = 'BAYSTATE MA IH Specialist 125376';
        PGP2.PGP_ID__c = 'Test PGP 2';
        PGPList.add(PGP2);
        
        insert PGPList;
        
        
        MYBZ_Call_Planning__c CallPlanning = New MYBZ_Call_Planning__c();
        CallPlanning.Name='Test';   
        CallPlanning.LoadIdentifier__c='AFFLTN';     
        CallPlanning.First_Name__c='FirstName'; 
        CallPlanning.LE_ID_IHS__c = 'Test IHS';
        CallPlanning.LE_ID_PGP__c = 'Test PGP';
        CallPlanning.System__c = SystemList[0].id;
        CallPlanning.Global_ID__c='114017';        
        CallPlanning.Last_Name__c='LastName';         
        CallPlanning.Territory__c=Territory.ID;
        CallPlanning.IHS_PGP_HCP_Level__c = 'System';
        CallPlanning.Tier__c=1;        
        CallPlanning.Start_Date_1M__c = null;
        CallPlanning.Start_Date_3M__c = null;
        CallPlanning.Start_Date_6M__c = null;
        Insert CallPlanning;
        system.assert(CallPlanning.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning1 = New MYBZ_Call_Planning__c();
        CallPlanning1.Name='Test';  
        CallPlanning1.System__c = SystemList[0].id;
        CallPlanning1.LoadIdentifier__c='AFFLTN';       
        CallPlanning1.First_Name__c='FirstName'; 
        CallPlanning1.LE_ID_IHS__c = 'Test IHS';
        CallPlanning1.IHS_PGP_HCP_Level__c = 'System';
        CallPlanning1.LE_ID_PGP__c = 'Test PGP';
        CallPlanning1.Global_ID__c='114017';         
        CallPlanning1.Last_Name__c='LastName'; 
        CallPlanning1.Territory__c=Territory.ID; 
        CallPlanning1.Tier__c=1;
        CallPlanning1.Start_Date_1M__c = DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning1.Start_Date_3M__c = DateTime.valueOfGMT('2015-03-21 00:00:00');
        CallPlanning1.Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');       
        Insert CallPlanning1;
        system.assert(CallPlanning1.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning2 = New MYBZ_Call_Planning__c();
        CallPlanning2.Name='Test';       
        CallPlanning2.First_Name__c='FirstName';
        CallPlanning2.LoadIdentifier__c='AFFLTN'; 
        CallPlanning2.System__c = SystemList[0].id; 
        CallPlanning2.LE_ID_IHS__c = 'Test IHS';
        CallPlanning2.LE_ID_PGP__c = 'Test PGP';
        CallPlanning2.IHS_PGP_HCP_Level__c = 'System';
        CallPlanning2.Global_ID__c='114017';         
        CallPlanning2.Last_Name__c='LastName';         
        CallPlanning2.Territory__c=Territory.ID; 
        CallPlanning2.Tier__c=1;
        CallPlanning2.Start_Date_1M__c = DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning2.Start_Date_3M__c = DateTime.valueOfGMT('2015-03-21 00:00:00');
        CallPlanning2.Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');        
        Insert CallPlanning2;
        system.assert(CallPlanning2.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning3 = New MYBZ_Call_Planning__c();
        CallPlanning3.Name='Test';        
        CallPlanning3.First_Name__c='FirstName'; 
        CallPlanning3.LoadIdentifier__c='AFFLTN'; 
        CallPlanning3.System__c = SystemList[0].id;
        CallPlanning3.LE_ID_IHS__c = 'Test IHS';
        CallPlanning3.LE_ID_PGP__c = 'Test PGP';
        CallPlanning3.IHS_PGP_HCP_Level__c = 'PGP';
        CallPlanning3.Global_ID__c='114017';         
        CallPlanning3.Last_Name__c='LastName';         
        CallPlanning3.Territory__c=Territory.ID; 
        CallPlanning3.Start_Date_1M__c = DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning3.Start_Date_3M__c = DateTime.valueOfGMT('2015-03-21 00:00:00');
        CallPlanning3.Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
        CallPlanning3.Tier__c=1;      
        Insert CallPlanning3;
        system.assert(CallPlanning3.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning4 = New MYBZ_Call_Planning__c();
        CallPlanning4.Name='Test';        
        CallPlanning4.First_Name__c='FirstName';
        CallPlanning4.LoadIdentifier__c='AFFLTN';  
        CallPlanning4.LE_ID_IHS__c = 'Test IHS';
        CallPlanning4.LE_ID_PGP__c = 'Test PGP';
        CallPlanning4.IHS_PGP_HCP_Level__c = 'PGP';
        CallPlanning4.System__c = SystemList[0].id;
        CallPlanning4.Global_ID__c='114017';        
        CallPlanning4.Last_Name__c='LastName';
        CallPlanning4.Territory__c=Territory.ID; 
        CallPlanning4.Tier__c=1;        
        CallPlanning4.Start_Date_1M__c = DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning4.Start_Date_3M__c = DateTime.valueOfGMT('2015-03-21 00:00:00');
        CallPlanning4.Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
        Insert CallPlanning4;   
        system.assert(CallPlanning4.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning5 = New MYBZ_Call_Planning__c();
        CallPlanning5.Name='Test';       
        CallPlanning5.First_Name__c='FirstName'; 
        CallPlanning5.LoadIdentifier__c='AFFLTN';
        CallPlanning5.Global_ID__c='114017';        
        CallPlanning5.Last_Name__c='LastName'; 
        CallPlanning5.System__c = SystemList[0].id;
        CallPlanning5.IHS_PGP_HCP_Level__c = 'HCP';
        CallPlanning5.LE_ID_IHS__c = 'Test IHS';
        CallPlanning5.LE_ID_PGP__c = 'Test PGP';        
        CallPlanning5.Territory__c=Territory.ID; 
        CallPlanning5.Tier__c=1;         
        CallPlanning5.Physician_ID__c = 'ppp';
        CallPlanning5.Start_Date_1M__c = null;
        CallPlanning5.Start_Date_3M__c = null;
        CallPlanning5.Start_Date_6M__c = null;
        Insert CallPlanning5;  
        system.assert(CallPlanning5.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning6 = New MYBZ_Call_Planning__c();
        CallPlanning6.Name='Test';        
        CallPlanning6.Global_ID__c='114017';               
        CallPlanning6.Territory__c=Territory2.ID;  
        CallPlanning6.LoadIdentifier__c='AFFLTN'; 
        CallPlanning6.System__c = SystemList[0].id;  
        CallPlanning6.LE_ID_IHS__c = 'Test IHS';
        CallPlanning6.LE_ID_PGP__c = 'Test PGP';  
        CallPlanning6.IHS_PGP_HCP_Level__c = 'HCP'; 
        CallPlanning6.Physician_ID__c = 'ppp';
        CallPlanning6.Start_Date_1M__c = DateTime.valueOfGMT('2015-05-21 00:00:00');
        CallPlanning6.Start_Date_3M__c = DateTime.valueOfGMT('2015-03-21 00:00:00');
        CallPlanning6.Start_Date_6M__c = DateTime.valueOfGMT('2015-01-21 00:00:00');
        Insert CallPlanning6;
        system.assert(CallPlanning6.id!=null);
        
        MYBZ_Call__c Call = New MYBZ_Call__c();
        Call.Product__c=IHSProduct.ID; 
        Call.Call_Date__c=null;
        Call.Call_Type__c='Test';
        Call.First_Name__c='FirstName';
        Call.Last_Name__c='LastName';
        Call.LoadIdentifier__c='AFFLTN';
        Call.Product__c=IHSProduct.ID; 
        Call.Global_ID__c='114017';
        Call.Product_Position__c=1;
        Call.LE_ID_PGP__c = 'Test PGP';
        Call.Territory__c=Territory.ID;
        Call.Name='Test';
        Call.Physician_ID__c = '1111';
        Call.Call_ID__c='A101';
        Insert Call;
        system.assert(Call.id!=null);
        
        MYBZ_Call__c Call1 = New MYBZ_Call__c();
        Call1.Product__c=IHSProduct2.ID; 
        Call1.Call_Date__c=null;
        Call1.Call_Type__c='Test';
        Call1.First_Name__c='FirstName';
        Call1.LE_ID_PGP__c = 'Test PGP';
        Call1.LoadIdentifier__c='AFFLTN';
        Call1.Last_Name__c='LastName';
        Call1.Product__c=IHSProduct2.ID; 
        Call1.Global_ID__c='114017';
        Call1.Product_Position__c=2;
        Call1.Territory__c=Territory.ID;
        Call1.Name='Test';
        Call1.Physician_ID__c = '1111';
        Call1.Call_ID__c='A101';
        Insert Call1;
        system.assert(Call1.id!=null);
        
        MYBZ_Call__c Call2 = New MYBZ_Call__c();
        Call2.Call_Date__c=null;
        Call2.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call2.First_Name__c='FirstName';
        Call2.Last_Name__c='LastName';
        Call2.LoadIdentifier__c='AFFLTN';
        Call2.Product__c=IHSProduct3.ID; 
        Call2.LE_ID_PGP__c = 'Test PGP';
        Call2.Global_ID__c='114017';
        Call2.Product_Position__c=3;
        Call2.Territory__c=Territory.ID;
        Call2.Name='Test';
        Call2.Physician_ID__c = '2222';
        Call2.Call_ID__c='A102';
        Insert Call2;
        system.assert(Call2.id!=null);
        
        MYBZ_Call__c Call3 = New MYBZ_Call__c();
        Call3.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call3.Call_Type__c=System.Label.MYBZ_SampleOnly;
        Call3.First_Name__c='FirstName';
        Call3.LoadIdentifier__c='AFFLTN';
        Call3.Last_Name__c='LastName';
        Call3.LE_ID_PGP__c = 'Test PGP';
        Call3.Product__c=IHSProduct.ID; 
        Call3.Global_ID__c='114017';
        Call3.Product_Position__c=2;
        Call3.Territory__c=Territory.ID;
        Call3.Name='Test';
        Call3.Physician_ID__c = 'ppp';
        Call3.Call_ID__c='A102';
        Insert Call3;
        system.assert(Call3.id!=null);
        
        MYBZ_Call__c Call4 = New MYBZ_Call__c();
        Call4.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call4.Product__c=IHSProduct2.ID; 
        Call4.LoadIdentifier__c='AFFLTN';
        Call4.Global_ID__c='114017';
        Call4.Product_Position__c=2;
        Call4.Territory__c=Territory2.ID;
        Call4.Name='Test';
        Call4.Physician_ID__c = '2222';
        Call4.Call_ID__c='A103';
        Insert Call4;
        system.assert(Call4.id!=null);  
        
        MYBZ_Call__c Call5 = New MYBZ_Call__c();
        Call5.Call_Date__c=DateTime.valueOfGMT('2015-01-21 00:00:00');
        Call5.Call_Type__c='Test';
        Call5.First_Name__c='FirstName';        
        Call5.Last_Name__c='LastName';
        Call5.Product__c=IHSProduct.ID; 
        Call5.LoadIdentifier__c='AFFLTN';
        Call5.Global_ID__c='114017';
        Call5.Product_Position__c=1;
        Call5.Territory__c=Territory.ID;
        Call5.Name='Test';
        Call5.Physician_ID__c = '5555';
        Call5.Call_ID__c='A100';
        Insert Call5;
        system.assert(Call5.id!=null);
        
        MYBZ_Call__c Call6 = New MYBZ_Call__c();
        Call6.Call_Date__c=null;
        Call6.Call_Type__c='Test';
        Call6.First_Name__c='FirstName';
        Call6.Last_Name__c='LastName';
        Call6.Product__c=IHSProduct3.ID; 
        Call6.LoadIdentifier__c='AFFLTN';
        Call6.Global_ID__c='114017';
        Call6.Product_Position__c=2;
        Call6.Territory__c=null;
        Call6.Name='Test';
        Call6.Physician_ID__c = '9999';
        Call6.Call_ID__c='A101';
        Insert Call6;
        system.assert(Call6.id!=null);
        
        List<MYBZ_CallPlanningProductJunction__c> lstCallPlanningProductJunction = new List<MYBZ_CallPlanningProductJunction__c>(); 
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction1 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction1.Call_Planning__c = CallPlanning1.id;
        callPlanJunction1.Product__c = IHSProduct.id;
        callPlanJunction1.Physician_ID__c ='1111';
        callPlanJunction1.TRx_Units_1M__c = 1;
        callPlanJunction1.Previous_TRx_Units_1M__c = 1;
        callPlanJunction1.TRx_Units_3M__c = 1;
        callPlanJunction1.Previous_TRx_Units_3M__c = 1;
        callPlanJunction1.TRx_Units_6M__c = 1;
        callPlanJunction1.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(callPlanJunction1);
        
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction2 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction2.Call_Planning__c = CallPlanning2.id;
        callPlanJunction2.Product__c = IHSProduct2.id;
        callPlanJunction2.Physician_ID__c ='2222';
        callPlanJunction2.TRx_Units_1M__c = 2;
        callPlanJunction2.Previous_TRx_Units_1M__c = 1;
        callPlanJunction2.TRx_Units_3M__c = 4;
        callPlanJunction2.Previous_TRx_Units_3M__c = 1;
        callPlanJunction2.TRx_Units_6M__c = 8;
        callPlanJunction2.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(callPlanJunction2);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction3 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction3.Call_Planning__c = CallPlanning3.id;
        callPlanJunction3.Product__c = IHSProduct3.id;
        callPlanJunction3.Physician_ID__c ='3333';        
        callPlanJunction3.TRx_Units_1M__c = 3;
        callPlanJunction3.Previous_TRx_Units_1M__c = 1;
        callPlanJunction3.TRx_Units_3M__c = 6;
        callPlanJunction3.Previous_TRx_Units_3M__c = 1;
        callPlanJunction3.TRx_Units_6M__c = 9;
        callPlanJunction3.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(callPlanJunction3);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction4 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction4.Call_Planning__c = CallPlanning4.id;
        callPlanJunction4.Product__c = IHSProduct.id;
        callPlanJunction4.Physician_ID__c ='4444';
        callPlanJunction4.TRx_Units_1M__c = 4;
        callPlanJunction4.Previous_TRx_Units_1M__c = 1;
        callPlanJunction4.TRx_Units_3M__c = 8;
        callPlanJunction4.Previous_TRx_Units_3M__c = 1;
        callPlanJunction4.TRx_Units_6M__c = 12;
        callPlanJunction4.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(callPlanJunction4);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction5 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction5.Call_Planning__c = CallPlanning5.id;
        callPlanJunction5.Product__c = IHSProduct2.id;
        callPlanJunction5.Physician_ID__c ='5555';
        callPlanJunction5.TRx_Units_1M__c = 5;
        callPlanJunction5.Previous_TRx_Units_1M__c = 1;
        callPlanJunction5.TRx_Units_3M__c = 10;
        callPlanJunction5.Previous_TRx_Units_3M__c = 1;
        callPlanJunction5.TRx_Units_6M__c = 15;
        callPlanJunction5.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(callPlanJunction5);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction6 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction6.Call_Planning__c = CallPlanning6.id;
        callPlanJunction6.Product__c = null;
        callPlanJunction6.Physician_ID__c ='6666';
        callPlanJunction6.TRx_Units_1M__c = 6;
        callPlanJunction6.Previous_TRx_Units_1M__c = 1;
        callPlanJunction6.TRx_Units_3M__c = 12;
        callPlanJunction6.Previous_TRx_Units_3M__c = 1;
        callPlanJunction6.TRx_Units_6M__c = 18;
        callPlanJunction6.Previous_TRx_Units_6M__c = 1;
        lstCallPlanningProductJunction.add(callPlanJunction6);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction7 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction7.Call_Planning__c = CallPlanning6.id;
        callPlanJunction7.Product__c = IHSProduct.id;
        callPlanJunction7.Physician_ID__c ='2222';
        callPlanJunction7.TRx_Units_1M__c = null;
        callPlanJunction7.Previous_TRx_Units_1M__c = null;
        callPlanJunction7.TRx_Units_3M__c = null;
        callPlanJunction7.Previous_TRx_Units_3M__c = null;
        callPlanJunction7.TRx_Units_6M__c = null;
        callPlanJunction7.Previous_TRx_Units_6M__c = null;
        lstCallPlanningProductJunction.add(callPlanJunction7);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction8 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction8.Call_Planning__c = CallPlanning1.id;
        callPlanJunction8.Product__c = IHSProduct2.id;
        callPlanJunction8.Physician_ID__c ='2222';
        callPlanJunction8.TRx_Units_1M__c = null;
        callPlanJunction8.Previous_TRx_Units_1M__c = null;
        callPlanJunction8.TRx_Units_3M__c = null;
        callPlanJunction8.Previous_TRx_Units_3M__c = null;
        callPlanJunction8.TRx_Units_6M__c = null;
        callPlanJunction8.Previous_TRx_Units_6M__c = null;
        lstCallPlanningProductJunction.add(callPlanJunction8);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction9 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction9.Call_Planning__c = CallPlanning2.id;
        callPlanJunction9.Product__c = IHSProduct3.id;
        callPlanJunction9.Physician_ID__c ='9999';
        callPlanJunction9.TRx_Units_1M__c = null;
        callPlanJunction9.Previous_TRx_Units_1M__c = null;
        callPlanJunction9.TRx_Units_3M__c = null;
        callPlanJunction9.Previous_TRx_Units_3M__c = null;
        callPlanJunction9.TRx_Units_6M__c = null;
        callPlanJunction9.Previous_TRx_Units_6M__c = null;
        lstCallPlanningProductJunction.add(callPlanJunction9);
        
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction10 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction10.Call_Planning__c = CallPlanning3.id;
        callPlanJunction10.Product__c = IHSProduct3.id;
        callPlanJunction10.Physician_ID__c ='1010';
        callPlanJunction10.TRx_Units_1M__c = 10;
        callPlanJunction10.Previous_TRx_Units_1M__c = 9;
        callPlanJunction10.TRx_Units_3M__c = 20;
        callPlanJunction10.Previous_TRx_Units_3M__c = 15;
        callPlanJunction10.TRx_Units_6M__c = 30;
        callPlanJunction10.Previous_TRx_Units_6M__c = 20;
        lstCallPlanningProductJunction.add(callPlanJunction10);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction11 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction11.Call_Planning__c = CallPlanning4.id;
        callPlanJunction11.Product__c = IHSProduct2.id;
        callPlanJunction11.Physician_ID__c ='1112';
        callPlanJunction11.TRx_Units_1M__c = 11;
        callPlanJunction11.Previous_TRx_Units_1M__c = 5;
        callPlanJunction11.TRx_Units_3M__c = 22;
        callPlanJunction11.Previous_TRx_Units_3M__c = 10;
        callPlanJunction11.TRx_Units_6M__c = 33;
        callPlanJunction11.Previous_TRx_Units_6M__c = 20;
        lstCallPlanningProductJunction.add(callPlanJunction11);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction12 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction12.Call_Planning__c = CallPlanning5.id;
        callPlanJunction12.Product__c = IHSProduct.id;
        callPlanJunction12.Physician_ID__c ='1112';
        callPlanJunction12.TRx_Units_1M__c = 12;
        callPlanJunction12.Previous_TRx_Units_1M__c = 5;
        callPlanJunction12.TRx_Units_3M__c = 24;
        callPlanJunction12.Previous_TRx_Units_3M__c = 10;
        callPlanJunction12.TRx_Units_6M__c = 36;
        callPlanJunction12.Previous_TRx_Units_6M__c = 20;
        lstCallPlanningProductJunction.add(callPlanJunction12);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction13 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction13.Call_Planning__c = CallPlanning6.id;
        callPlanJunction13.Product__c = null;
        callPlanJunction13.Physician_ID__c ='2222';
        callPlanJunction13.TRx_Units_1M__c = 13;
        callPlanJunction13.Previous_TRx_Units_1M__c = 5;
        callPlanJunction13.TRx_Units_3M__c = 26;
        callPlanJunction13.Previous_TRx_Units_3M__c = 10;
        callPlanJunction13.TRx_Units_6M__c = 39;
        callPlanJunction13.Previous_TRx_Units_6M__c = 20;
        lstCallPlanningProductJunction.add(callPlanJunction13);
        
        
        insert lstCallPlanningProductJunction;
        
        
        
    }

     /*
    * @Method Name                    :  testAsSalesRepAlignment
    * @Description                    :  method to test as Sales Representative(Role) generation of JSONS for Callplanning Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSalesRepAlignment() {
        String jsonrespasString;
        User runAsUser = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_SalesRepresentative);  
        User runAsUserDataLoad = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_SalesRepresentative);
        
        System.runas(runAsUserDataLoad){ 
        
            // Insertion of Test Dat
            insertTestDataCallPlanning();
        
        }
        System.runas(runAsUser){ 
            
            Test.startTest();
            
             MYBZ_CallPlanningController.callPlanningAffiliationView('Test IHS','Test PGP', Territory.Name);
               MYBZ_CallPlanningController.callPlanningAffiliationView( null,'Test PGP', Territory.Name);
               MYBZ_CallPlanningController.callPlanningAffiliationView('Test IHS',null, Territory.Name);              
               MYBZ_CallPlanningController.callPlanningAffiliationView('Test IHS','Test PGP', null);
               
            
            Test.stopTest();
        }
     }
     
      /*
    * @Method Name                    :  testAsSuperUser
    * @Description                    :  method to test as Super User(Role) generation of JSONS for Call Planning Report
    * @Return Type                    :  void
    * @Param                          :      
    */ 
     static testMethod void testAsSuperUser() {
        String jsonrespasString;
        User runAsUser = Test_MYBZ_RegionRollup_Controller.createUser(System.Label.MYBZ_SuperUser);
        User runAsUserDataLoad = Test_MYBZ_RegionRollup_Controller.createUserDataLoad(System.Label.MYBZ_SuperUser);
        
        System.runas(runAsUser){ 
             MYBZ_CallPlanningController.callPlanningAffiliationView('Test IHS','Test PGP', Territory.Name);
        }
         
        // Insertion of Test Data
        System.runas(runAsUserDataLoad){ 
            insertTestDataCallPlanning();
        } 
        
        System.runas(runAsUser){ 
            
            Test.startTest();
               MYBZ_CallPlanningController.callPlanningAffiliationView('Test IHS','Test PGP', Territory.Name);
               MYBZ_CallPlanningController.callPlanningAffiliationView( null,'Test PGP', Territory.Name);
               MYBZ_CallPlanningController.callPlanningAffiliationView('Test IHS',null, Territory.Name);              
               MYBZ_CallPlanningController.callPlanningAffiliationView('Test IHS','Test PGP', null);
               
           Test.stopTest();
        }
            
     }
}