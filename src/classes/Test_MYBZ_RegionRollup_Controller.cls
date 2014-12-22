/*
 *@ Class Name                                                    : Test_MYBZ_Region_Rollup_Controller
 *@ Description                                                   : Test Class for MYBZ_RR_Controller_Dev_Update
 *@ CreatedBy                                                     : 
 *@ CreatedOn                                                     : 
 *@ Modification Log                                              :
 */
 
 @isTest(SeeAllData=false)
public class Test_MYBZ_RegionRollup_Controller{
    
    static User createUser(String Role){
     Profile pfl = [select id from profile where name='System Administrator'];
         //Declaring the User
        User runAsUser = new User(alias = 'Admin', email='appAdmin@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'u1'+Math.random()*100 ,
            timezonesidkey='America/Los_Angeles', username='appAdmin@gso_org.com'+Math.random()*100 , MYBZ_Role__c=Role,Mercury_External_Id_MERC__c=Role, Prsnl_Nbr_GLBL__c='xxxxx');
        
        Insert runAsUser;
        Return runAsUser;
    }   
    
    static void CallingMethods() {
        MYBZ_Product__c IHSProduct = New MYBZ_Product__c();
        IHSProduct.Name='EFFIENT'; 
        Insert IHSProduct;
        system.assert(IHSProduct.id!=null);
        
        MYBZ_Product__c IHSProduct2 = New MYBZ_Product__c();
        IHSProduct2.Name='TestProduct2'; 
        Insert IHSProduct2;
        system.assert(IHSProduct2.id!=null);
        
        MYBZ_IHS_Division__c Div = New MYBZ_IHS_Division__c();
        Div.Name='TestDivision';
        Insert Div;  
        system.assert(Div.id!=null);
        
        
        MYBZ_Region__c Region = New MYBZ_Region__c();
        Region.Name='TestRegion';
        Region.Parent__c=Div.ID;
        Insert Region;
        system.assert(Region.id!=null);
        
        MYBZ_District__c District = New MYBZ_District__c();
        District.Name='TestDistrict';
        District.Region__c=Region.ID;
        Insert District;
        system.assert(District.id!=null);
        
        MYBZ_Territory__c Territory = New MYBZ_Territory__c();
        Territory.Name='TestTerritory';
        Territory.State__c = District.id;
        Insert Territory;
        system.assert(Territory.id!=null);
        
        MYBZ_Market_Share__c MarketShare = New MYBZ_Market_Share__c();
        MarketShare.Name='TestMarket';
        MarketShare.Global_Id__c='xxxxx';
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
        MarketShare.Year__c=System.today().year();
        Insert MarketShare;
        system.assert(MarketShare.id!=null);
        
        MYBZ_Market_Share__c MarketShare1 = New MYBZ_Market_Share__c();
        MarketShare1.Name='TestMarket';
        MarketShare1.Global_Id__c='xxxxx';
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
        MarketShare1.Year__c=System.today().year();
        Insert MarketShare1;
        system.assert(MarketShare1.id!=null);
        
        MYBZ_Target_Goal__c TargetGoal = New MYBZ_Target_Goal__c();
        TargetGoal.Name='TestTargetGoal';
        TargetGoal.District__c=District.ID;
        TargetGoal.Global_Id__c='xxxxx';
        TargetGoal.Month__c=System.today().month();
        TargetGoal.Product__c=IHSProduct.ID;
        TargetGoal.Territory__c = null;
        TargetGoal.TRx_Goal__c=2;
        TargetGoal.TRx_Goal_Attainment__c=2;
        TargetGoal.Year__c=System.today().year();
        Insert TargetGoal;
        system.assert(TargetGoal.id!=null);
        
        MYBZ_Target_Goal__c TargetGoal1 = New MYBZ_Target_Goal__c();
        TargetGoal1.Name='TestTargetGoal';
        TargetGoal1.District__c=District.ID;
        TargetGoal1.Global_Id__c='xxxxx';
        TargetGoal1.Month__c=System.today().month();
        TargetGoal1.Product__c=IHSProduct.ID;
        TargetGoal1.Territory__c = Territory.Id;
        TargetGoal1.TRx_Goal__c=2;
        TargetGoal1.TRx_Goal_Attainment__c=2;
        TargetGoal1.Year__c=System.today().year();
        Insert TargetGoal1;
        system.assert(TargetGoal1.id!=null);
        
        MYBZ_Product_Trend_Detail__c PTD = New MYBZ_Product_Trend_Detail__c();
        PTD.Area__c=Region.ID;
        PTD.District__c=District.ID;
        PTD.End_Date__c=System.today()+30;
        PTD.HCP_First_Name__c='Test';
        PTD.Global_ID__c='xxxxx';
        PTD.IHS_Product__c=IHSProduct.ID;
        PTD.HCP_Last_Name__c='Test';
        PTD.Range__c='6M';
        PTD.Start_Date__c=System.Today();
        PTD.Territory__c=Territory.ID;
        PTD.TRx_Units__c=1;
        Insert PTD;
        system.assert(PTD.id!=null);
        
        MYBZ_Call_Planning__c CallPlanning = New MYBZ_Call_Planning__c();
        CallPlanning.Name='Test';
        //CallPlanning.End_Date__c=System.today()+30; 
        CallPlanning.First_Name__c='FirstName'; 
        CallPlanning.Global_ID__c='xxxxx'; 
       //CallPlanning.Last_Call_Date__c=System.Now(); 
        CallPlanning.Last_Name__c='LastName'; 
        //CallPlanning.Previous_TRx_Units__c=2; 
        //CallPlanning.Product__c=IHSProduct.ID; 
        //CallPlanning.Range__c='1M'; 
        //CallPlanning.Start_Date__c=System.Today(); 
        CallPlanning.Territory__c=Territory.ID; 
        CallPlanning.Tier__c=1; 
        //CallPlanning.TRx_Units__c=1; 
        CallPlanning.Physician_ID__c = 'ppp';
        Insert CallPlanning;
        system.assert(CallPlanning.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning1 = New MYBZ_Call_Planning__c();
        CallPlanning1.Name='Test';
        //CallPlanning1.End_Date__c=System.today()+30; 
        CallPlanning1.First_Name__c='FirstName'; 
        CallPlanning1.Global_ID__c='xxxxx'; 
        //CallPlanning1.Last_Call_Date__c=System.Now(); 
        CallPlanning1.Last_Name__c='LastName'; 
        //CallPlanning1.Previous_TRx_Units__c=2; 
        //CallPlanning1.Product__c=IHSProduct.ID; 
        //CallPlanning1.Range__c='3M'; 
        //CallPlanning1.Start_Date__c=System.Today(); 
        CallPlanning1.Territory__c=Territory.ID; 
        CallPlanning1.Tier__c=1; 
        //CallPlanning1.TRx_Units__c=1; 
        CallPlanning1.Physician_ID__c = 'ppp';
        Insert CallPlanning1;
        system.assert(CallPlanning1.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning2 = New MYBZ_Call_Planning__c();
        CallPlanning2.Name='Test';
        //CallPlanning2.End_Date__c=System.today()+30; 
        CallPlanning2.First_Name__c='FirstName'; 
        CallPlanning2.Global_ID__c='xxxxx'; 
        //CallPlanning2.Last_Call_Date__c=System.Now(); 
        CallPlanning2.Last_Name__c='LastName'; 
        //CallPlanning2.Previous_TRx_Units__c=2; 
        //CallPlanning2.Product__c=IHSProduct.ID; 
        //CallPlanning2.Range__c='6M'; 
        //CallPlanning2.Start_Date__c=System.Today(); 
        CallPlanning2.Territory__c=Territory.ID; 
        CallPlanning2.Tier__c=1; 
        //CallPlanning2.TRx_Units__c=1; 
        CallPlanning2.Physician_ID__c = 'ppp';
        Insert CallPlanning2;
        system.assert(CallPlanning2.id!=null);
            
        MYBZ_Call_Planning__c CallPlanning3 = New MYBZ_Call_Planning__c();
        CallPlanning3.Name='Test';
        //CallPlanning3.End_Date__c=System.today()+30; 
        CallPlanning3.First_Name__c='FirstName'; 
        CallPlanning3.Global_ID__c='xxxxx'; 
        //CallPlanning3.Last_Call_Date__c=System.Now(); 
        CallPlanning3.Last_Name__c='LastName'; 
        //CallPlanning3.Previous_TRx_Units__c=2; 
        //CallPlanning3.Product__c=IHSProduct.ID; 
        //CallPlanning3.Range__c='1M'; 
        //CallPlanning3.Start_Date__c=System.Today(); 
        CallPlanning3.Territory__c=Territory.ID; 
        CallPlanning3.Tier__c=1; 
        //CallPlanning3.TRx_Units__c=1; 
        CallPlanning3.Physician_ID__c = 'ppp';
        Insert CallPlanning3;
        system.assert(CallPlanning3.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning4 = New MYBZ_Call_Planning__c();
        CallPlanning4.Name='Test';
        //CallPlanning4.End_Date__c=System.today()+30; 
        CallPlanning4.First_Name__c='FirstName'; 
        CallPlanning4.Global_ID__c='xxxxx'; 
        //CallPlanning4.Last_Call_Date__c=System.Now(); 
        CallPlanning4.Last_Name__c='LastName'; 
        //CallPlanning4.Previous_TRx_Units__c=2; 
        //CallPlanning4.Product__c=IHSProduct.ID; 
        //CallPlanning4.Range__c='3M'; 
        //CallPlanning4.Start_Date__c=System.Today(); 
        CallPlanning4.Territory__c=Territory.ID; 
        CallPlanning4.Tier__c=1; 
        //CallPlanning4.TRx_Units__c=1; 
        CallPlanning4.Physician_ID__c = 'ppp';
        Insert CallPlanning4;   
        system.assert(CallPlanning4.id!=null);
    
        MYBZ_Call_Planning__c CallPlanning5 = New MYBZ_Call_Planning__c();
        CallPlanning5.Name='Test';
        //CallPlanning5.End_Date__c=System.today()+30; 
        CallPlanning5.First_Name__c='FirstName'; 
        CallPlanning5.Global_ID__c='xxxxx'; 
        //CallPlanning5.Last_Call_Date__c=System.Now(); 
        CallPlanning5.Last_Name__c='LastName'; 
        //CallPlanning5.Previous_TRx_Units__c=2; 
        //CallPlanning5.Product__c=IHSProduct2.ID; 
        //CallPlanning5.Range__c='1M'; 
        //CallPlanning5.Start_Date__c=System.Today(); 
        CallPlanning5.Territory__c=Territory.ID; 
        CallPlanning5.Tier__c=1; 
        //CallPlanning5.TRx_Units__c=1; 
        CallPlanning5.Physician_ID__c = 'ppp';
        Insert CallPlanning5;  
        system.assert(CallPlanning5.id!=null);
    
        MYBZ_Call__c Call = New MYBZ_Call__c();
        Call.Call_Date__c=System.Now();
        Call.Call_Type__c='Test';
        Call.First_Name__c='FirstName';
        Call.Last_Name__c='LastName';
        Call.Product__c=IHSProduct.ID; 
        Call.Global_ID__c='xxxxx';
        Call.Product_Position__c=1;
        Call.Territory__c=Territory.ID;
        Call.Name='Test';
        Call.Physician_ID__c = 'ppp';
        Insert Call;
        system.assert(Call.id!=null);
        
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
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction2 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction2.Call_Planning__c = CallPlanning2.id;
        callPlanJunction2.Product__c = IHSProduct.id;
        callPlanJunction2.Physician_ID__c ='ppp';
        callPlanJunction2.TRx_Units_1M__c = 1;
        callPlanJunction2.Previous_TRx_Units_1M__c = 1;
        callPlanJunction2.TRx_Units_3M__c = 1;
        callPlanJunction2.Previous_TRx_Units_3M__c = 1;
        callPlanJunction2.TRx_Units_6M__c = 1;
        callPlanJunction2.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction2;
        system.assert(callPlanJunction2.id!=null);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction3 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction3.Call_Planning__c = CallPlanning3.id;
        callPlanJunction3.Product__c = IHSProduct.id;
        callPlanJunction3.Physician_ID__c ='ppp';
        callPlanJunction3.TRx_Units_1M__c = 1;
        callPlanJunction3.Previous_TRx_Units_1M__c = 1;
        callPlanJunction3.TRx_Units_3M__c = 1;
        callPlanJunction3.Previous_TRx_Units_3M__c = 1;
        callPlanJunction3.TRx_Units_6M__c = 1;
        callPlanJunction3.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction3;
        system.assert(callPlanJunction3.id!=null);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction4 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction4.Call_Planning__c = CallPlanning4.id;
        callPlanJunction4.Product__c = IHSProduct.id;
        callPlanJunction4.Physician_ID__c ='ppp';
        callPlanJunction4.TRx_Units_1M__c = 1;
        callPlanJunction4.Previous_TRx_Units_1M__c = 1;
        callPlanJunction4.TRx_Units_3M__c = 1;
        callPlanJunction4.Previous_TRx_Units_3M__c = 1;
        callPlanJunction4.TRx_Units_6M__c = 1;
        callPlanJunction4.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction4;
        system.assert(callPlanJunction4.id!=null);
        
        MYBZ_CallPlanningProductJunction__c  callPlanJunction5 = new MYBZ_CallPlanningProductJunction__c();
        callPlanJunction5.Call_Planning__c = CallPlanning5.id;
        callPlanJunction5.Product__c = IHSProduct.id;
        callPlanJunction5.Physician_ID__c ='ppp';
        callPlanJunction5.TRx_Units_1M__c = 1;
        callPlanJunction5.Previous_TRx_Units_1M__c = 1;
        callPlanJunction5.TRx_Units_3M__c = 1;
        callPlanJunction5.Previous_TRx_Units_3M__c = 1;
        callPlanJunction5.TRx_Units_6M__c = 1;
        callPlanJunction5.Previous_TRx_Units_6M__c = 1;
        insert callPlanJunction5;
        system.assert(callPlanJunction5.id!=null);
        
        List<MYBZ_Region_Rollup__c> regionRollUp = new List<MYBZ_Region_Rollup__c>();
        List<string> alignments = new List<String>{'Region', 'District', 'Territory'};
        for(integer i=0; i< 3; i++){
          MYBZ_Region_Rollup__c eachRegionRollup = new MYBZ_Region_Rollup__c();
          eachRegionRollup.Alignment_Level__c = alignments.get(i);
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
          eachRegionRollup.DDD_Dollars_Start_Date_1M__c = System.now();
          eachRegionRollup.DDD_Dollars_Start_Date_3M__c = System.now();
          eachRegionRollup.DDD_Dollars_Start_Date_6M__c = System.now();
          eachRegionRollup.Gross_Margin_Start_Date_1M__c = System.now();
          eachRegionRollup.Gross_Margin_Start_Date_3M__c = System.now();
          eachRegionRollup.Gross_Margin_Start_Date_6M__c = System.now();
          eachRegionRollup.Net_Profit_Start_Date_1M__c = System.now();
          eachRegionRollup.Net_Profit_Start_Date_3M__c = System.now();
          eachRegionRollup.Net_Profit_Start_Date_6M__c = System.now();
          eachRegionRollup.NRx_Start_Date_1M__c = System.now();
          eachRegionRollup.NRx_Start_Date_3M__c = System.now();
          eachRegionRollup.NRx_Start_Date_6M__c = System.now();
          eachRegionRollup.OPEX_Start_Date_1M__c = System.now();
          eachRegionRollup.OPEX_Start_Date_3M__c = System.now();
          eachRegionRollup.OPEX_Start_Date_6M__c = System.now();
          eachRegionRollup.TRx_Start_Date_1M__c = System.now();
          eachRegionRollup.TRx_Start_Date_3M__c = System.now();
          eachRegionRollup.TRx_Start_Date_6M__c = System.now();
          
          eachRegionRollup.Global_ID__c = 'xxxxx';
          
          regionRollUp.add(eachRegionRollup);
        }
        insert regionRollUp;
        
        MYBZ_Region_Rollup_Controller TestController = New MYBZ_Region_Rollup_Controller();
        MYBZ_Region_Rollup_Controller.UserId=Userinfo.getuserID();
        MYBZ_Region_Rollup_Controller.GlobalId='xxxxx';
        
        TestController.countUsageMetrics();
        
        MYBZ_Region_Rollup_Controller.RegionRollup(Region.Name,District.Name,Territory.Name);
        MYBZ_Region_Rollup_Controller.RegionRollup1();
        MYBZ_Region_Rollup_Controller.Alignment1();
        MYBZ_Region_Rollup_Controller.Alignment(Region.Name,District.Name,Territory.Name);
    
        
        MYBZ_Region_Rollup_Controller.TargetGoal(Region.Name,District.Name,Territory.Name);
        MYBZ_Region_Rollup_Controller.TargetGoal1();    
        
        MYBZ_Region_Rollup_Controller.ProductTrends(Region.Name,District.Name,Territory.Name);
        MYBZ_Region_Rollup_Controller.ProductTrends1();
    
        MYBZ_Region_Rollup_Controller.MarketShare(Region.Name,District.Name,Territory.Name);
        MYBZ_Region_Rollup_Controller.MarketShare1();
        MYBZ_Region_Rollup_Controller.TrendsPrescriber(Region.Name,District.Name,Territory.Name);
        MYBZ_Region_Rollup_Controller.TrendsPrescriber1();
        MYBZ_Region_Rollup_Controller.callPlanning(Region.Name,District.Name,Territory.Name);
        MYBZ_Region_Rollup_Controller.callPlanning1();
    }
    
    
    /*static testMethod void SalesRepAlignment() {
        User runAsUser = createUser('Sales Representative');             
        System.runas(runAsUser){ 
            CallingMethods(); 
        }
    }
    
    static testMethod void MajorManAlignment() {
        User runAsUser = createUser('Major Market Manager');  
        System.debug('Calling here');
        System.runas(runAsUser){ 
            System.debug('Calling here 123');     
            CallingMethods();     
            System.Debug('ssssssssssss'+runAsUser.Mercury_External_Id_MERC__c);
        }
    } */
    
    static testMethod void DisManAlignment() {
        User runAsUser = createUser('District Sales Manager');             
        System.runas(runAsUser){ 
            CallingMethods(); 
        }
    }
  

}